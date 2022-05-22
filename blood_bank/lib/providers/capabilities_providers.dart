import 'package:flutter/material.dart';

import 'package:blood_bank/api/unit_blood_api.dart';
import 'package:blood_bank/models/http/capabilities_response.dart';
import 'package:blood_bank/services/local_storage.dart';
import 'package:blood_bank/services/notification_service.dart';

class CapabilitiesProvider extends ChangeNotifier {
  List<Capability> capabilities = [];

  getCapabilities() async {
    final centerId = LocalStorage.prefs.getInt("center_id");
    final resp = await UnitBloodApi.httpGet("/centers/$centerId/capabilities/");

    final capabilities = CapabilitiesResponse.fromMap(resp);

    this.capabilities = [...capabilities.capabilities];
    notifyListeners();
  }

  Future newCapacity(String type, int minQty, int maxQty) async {
    final data = {
      "type": type,
      "min_qty": minQty,
      "max_qty": maxQty,
    };
    try {
      final centerId = LocalStorage.prefs.getInt("center_id");
      final json =
          await UnitBloodApi.httpPost("/centers/$centerId/capabilities/", data);
      final newCapacity = Capability.fromMap(json);
      capabilities.add(newCapacity);
      NotificationService.showSnackbar(
          "Creación de nueva capacidad ${type} completada");
      notifyListeners();
    } catch (e) {
      NotificationService.showSnackbarError("Capacidad ya existente...");
    }
  }

  Future updateCapacity(int capacityId, int minQty, int maxQty) async {
    final data = {
      "min_qty": minQty,
      "max_qty": maxQty,
    };
    try {
      final centerId = LocalStorage.prefs.getInt("center_id");
      await UnitBloodApi.httpPut(
          "/centers/$centerId/capabilities/$capacityId/", data);
      this.capabilities = this.capabilities.map((c) {
        if (c.id != capacityId) return c;
        c.minQty = minQty;
        c.maxQty = maxQty;
        return c;
      }).toList();
      NotificationService.showSnackbar(
          "Actualización de capacidad ${capacityId} completada");
      notifyListeners();
    } catch (e) {
      NotificationService.showSnackbarError(
          "Error al actualizar la capacidad del centro...");
    }
  }

  Future deleteCapacity(int capacityId) async {
    try {
      final centerId = LocalStorage.prefs.getInt("center_id");
      await UnitBloodApi.httpDelete(
          "/centers/$centerId/capabilities/$capacityId/", {});
      this.capabilities.removeWhere((capacity) => capacity.id == capacityId);
      NotificationService.showSnackbar(
          "Eliminación de capacidad ${capacityId} completada");
      notifyListeners();
    } catch (e) {
      NotificationService.showSnackbarError(
          "Error al eliminar la capacidad del centro...");
    }
  }
}
