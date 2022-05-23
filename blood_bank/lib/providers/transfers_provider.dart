import 'package:blood_bank/api/unit_blood_api.dart';
import 'package:blood_bank/models/http/transfer_detail_response.dart';
import 'package:blood_bank/models/http/transfer_list_response.dart';
import 'package:blood_bank/services/local_storage.dart';
import 'package:blood_bank/services/notification_service.dart';
import 'package:blood_bank/utils/string_extension.dart';
import 'package:flutter/material.dart';


class TransfersProvider extends ChangeNotifier {
  List<Transfer> transfers = [];
  List<Transfer> petitions = [];
  late TransferDetailResponse transferDetail;

  getTransfers() async {
    final centerId = LocalStorage.prefs.getInt("center_id");
    final resp = await UnitBloodApi.httpGet("/centers/$centerId/transfers/");
    final transfers = TransferListResponse.fromMap(resp);
    this.transfers = [...transfers.transfers];
    notifyListeners();
  }

  getDetailTransfer(int transferId) async {
    final centerId = LocalStorage.prefs.getInt("center_id");
    final resp =
        await UnitBloodApi.httpGet("/centers/$centerId/transfers/$transferId/");
    transferDetail = TransferDetailResponse.fromMap(resp[0]);
    notifyListeners();
  }

  getPetitions() async {
    final centerId = LocalStorage.prefs.getInt("center_id");
    final resp = await UnitBloodApi.httpGet("/centers/$centerId/petitions/");
    final petitions = TransferListResponse.fromMap(resp);
    this.petitions = [...petitions.transfers];
    notifyListeners();
  }

  getDetailPetition(int transferId) async {
    final centerId = LocalStorage.prefs.getInt("center_id");
    final resp =
        await UnitBloodApi.httpGet("/centers/$centerId/petitions/$transferId/");
    transferDetail = TransferDetailResponse.fromMap(resp[0]);
    notifyListeners();
  }

  createIncident(int type, int transferId, int unitId, String incident) async {
    final centerId = LocalStorage.prefs.getInt("center_id");
    final url = (type == 0) ? "transfers" : "petitions";
    final data = {
      "incident": incident,
    };
    try {
      final json = await UnitBloodApi.httpPost(
          "/centers/$centerId/$url/$transferId/units/$unitId/", data);
      NotificationService.showSnackbar(
          "Creación/Actualización de incidencia correcta");
      notifyListeners();
    } catch (e) {
      NotificationService.showSnackbarError(
          "Error al crear/actualizar la incidencia en la unidad");
    }
  }

  nextStatus(int type, int transferId) async {
    final centerId = LocalStorage.prefs.getInt("center_id");
    final url = (type == 0) ? "transfers" : "petitions";
    try {
      final json = await UnitBloodApi.httpPut(
          "/centers/$centerId/$url/$transferId/", {});
      if (json["message"].toString().contains("Cannot")) {
        NotificationService.showSnackbarError(
            "Error al pasar al siguiente estatus de la transferencia");
        return false;
      }
      String current_status = json["current_status"].toString();
      NotificationService.showSnackbar("Paso al siguiente estatus con exito");
      current_status = current_status.replaceAll("_", " ").toCapitalized();
      this.transfers = this.transfers.map((c) {
        if (c.id != transferId) return c;
        c.status = current_status;
        return c;
      }).toList();
      this.petitions = this.petitions.map((c) {
        if (c.id != transferId) return c;
        c.status = current_status;
        return c;
      }).toList();
      if (current_status == "Arrived") {
        this.petitions.removeWhere((c) => c.id == transferId);
      }
      return true;
    } catch (e) {
      NotificationService.showSnackbarError(
          "Error al pasar al siguiente estatus de la transferencia");
      return false;
    }
  }

  Future newTransfer(
    int qty,
    String name,
    String comment,
    String receptor,
    String unidad,
    String typeDeadline,
    String deadline,
  ) async {
    final data = {
      "deadline": deadline,
      "name": name,
      "comment": comment,
      "receptor_blood_type": receptor,
      "qty": qty,
      "unit_type": unidad,
      "type_deadline": typeDeadline,
    };
    try {
      final centerId = LocalStorage.prefs.getInt("center_id");
      final json =
          await UnitBloodApi.httpPost("/centers/$centerId/transfers/", data);
      if ((json as List).length == 0) {
        NotificationService.showSnackbarError(
            "Error no se puede crear esta transferencia, te recomendamos solicitar donaciones en tu centro para contar con esta y otras unidades de sangre");
        return;
      }
      for (int i = 0; i < (json as List).length; i++) {
        final newTransfer = Transfer.fromMap(json[i]);
        this.transfers.add(newTransfer);
      }
    } catch (e) {
      NotificationService.showSnackbarError(
          "Error al crear las transferencias");
    }
  }
}
