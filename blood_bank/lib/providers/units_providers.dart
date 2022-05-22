import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:blood_bank/api/unit_blood_api.dart';
import 'package:blood_bank/services/local_storage.dart';
import 'package:blood_bank/services/notification_service.dart';
import 'package:blood_bank/models/http/units_response.dart';

class UnitsProvider extends ChangeNotifier {
  List<Unit> units = [];

  getUnits() async {
    final centerId = LocalStorage.prefs.getInt("center_id");
    final resp = await UnitBloodApi.httpGet("/centers/$centerId/units/");
    final units = UnitsResponse.fromMap(resp);
    print(units);
    this.units = [...units.units];
    notifyListeners();
  }

  Future newUnit(
      String type,
      String bloodType,
      String expiresAt,
      bool canTransfer,
      bool isAltruistUnit,
      String donorGender,
      int donorAge) async {
    final data = {
      "type": type,
      "blood_type": bloodType,
      "expired_at": expiresAt,
      "can_transfer": canTransfer,
      "is_altruist_unit": isAltruistUnit,
      "donor_gender": donorGender,
      "donor_age": donorAge,
    };
    try {
      final centerId = LocalStorage.prefs.getInt("center_id");
      final json =
          await UnitBloodApi.httpPost("/centers/$centerId/units/", data);
      final newUnit = Unit.fromMap(json);
      units.add(newUnit);
      NotificationService.showSnackbar(
          "Creación de unidad ${type} de tipo ${bloodType} completada");
      notifyListeners();
    } catch (e) {
      String msg =
          "No se puede agregar unidad porque no existe la capacidad de este tipo de unidad";
      if (e.toString().contains("{error")) {
        msg =
            "No se puede agregar la unidad porque ya se rebaso la capacidad máxima del centro, intente utilizar alguna existente para transferir o aumente la capacidad del tipo ${type} y reintente de nuevo";
      }
      NotificationService.showSnackbarError(msg);
    }
  }

  Future deleteUnit(int unitId, String reason) async {
    final data = {
      "reason": reason,
    };
    try {
      final centerId = LocalStorage.prefs.getInt("center_id");
      final json = await UnitBloodApi.httpDelete(
          "/centers/$centerId/units/${unitId}/", data);
      this.units.removeWhere((unit) => unit.id == unitId);
      NotificationService.showSnackbar("Baja de unidad ${unitId} completada");
      notifyListeners();
    } catch (e) {
      NotificationService.showSnackbarError(
          "No se puede dar de baja la unidad");
    }
  }
}
