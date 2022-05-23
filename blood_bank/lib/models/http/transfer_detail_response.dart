import 'dart:convert';

import 'package:blood_bank/models/http/center_response.dart';
import 'package:blood_bank/models/http/units_response.dart';

class TransferDetailResponse {
  TransferDetailResponse({
    required this.id,
    required this.origin,
    required this.destination,
    required this.status,
    required this.deadline,
    required this.typeDeadline,
    required this.name,
    required this.comment,
    required this.receptorBloodType,
    required this.unitType,
    required this.qty,
    required this.units,
  });

  int id;
  Center origin;
  Center destination;
  String status;
  DateTime deadline;
  String typeDeadline;
  String name;
  String comment;
  String receptorBloodType;
  String unitType;
  int qty;
  List<UnitElement> units;

  factory TransferDetailResponse.fromJson(String str) =>
      TransferDetailResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory TransferDetailResponse.fromMap(Map<String, dynamic> json) =>
      TransferDetailResponse(
        id: json["id"],
        origin: Center.fromMap(json["origin"]),
        destination: Center.fromMap(json["destination"]),
        status: json["status"],
        deadline: DateTime.parse(json["deadline"]),
        typeDeadline: json["type_deadline"],
        name: json["name"],
        comment: json["comment"],
        receptorBloodType: json["receptor_blood_type"],
        unitType: json["unit_type"],
        qty: json["qty"],
        units:
            List<UnitElement>.from(json["units"].map((x) => UnitElement.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "origin": origin.toMap(),
        "destination": destination.toMap(),
        "status": status,
        "deadline": deadline.toIso8601String(),
        "type_deadline": typeDeadline,
        "name": name,
        "comment": comment,
        "receptor_blood_type": receptorBloodType,
        "unit_type": unitType,
        "qty": qty,
        "units": List<dynamic>.from(units.map((x) => x.toMap())),
      };
}

class UnitElement {
  UnitElement({
    required this.id,
    required this.unit,
  });

  int id;
  Unit unit;

  factory UnitElement.fromJson(String str) =>
      UnitElement.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory UnitElement.fromMap(Map<String, dynamic> json) => UnitElement(
        id: json["id"],
        unit: Unit.fromMap(json["unit"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "unit": unit.toMap(),
      };
}
