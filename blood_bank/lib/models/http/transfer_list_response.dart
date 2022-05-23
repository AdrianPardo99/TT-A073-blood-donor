import 'dart:convert';

import 'package:blood_bank/models/http/center_response.dart';

class TransferListResponse {
  TransferListResponse({
    required this.count,
    required this.transfers,
  });

  int count;
  List<Transfer> transfers;

  factory TransferListResponse.fromJson(String str) =>
      TransferListResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory TransferListResponse.fromMap(Map<String, dynamic> json) =>
      TransferListResponse(
        count: json["count"],
        transfers: List<Transfer>.from(
            json["results"].map((x) => Transfer.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "count": count,
        "transfers": List<dynamic>.from(transfers.map((x) => x.toMap())),
      };
}

class Transfer {
  Transfer({
    required this.id,
    required this.origin,
    required this.destination,
    required this.status,
    required this.deadline,
    required this.typeDeadline,
    required this.receptorBloodType,
    required this.unitType,
  });

  int id;
  Center origin;
  Center destination;
  String status;
  DateTime deadline;
  String typeDeadline;
  String receptorBloodType;
  String unitType;

  factory Transfer.fromJson(String str) => Transfer.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Transfer.fromMap(Map<String, dynamic> json) => Transfer(
        id: json["id"],
        origin: Center.fromMap(json["origin"]),
        destination: Center.fromMap(json["destination"]),
        status: json["status"],
        deadline: DateTime.parse(json["deadline"]),
        typeDeadline: json["type_deadline"],
        receptorBloodType: json["receptor_blood_type"],
        unitType: json["unit_type"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "origin": origin.toMap(),
        "destination": destination.toMap(),
        "status": status,
        "deadline": deadline.toIso8601String(),
        "type_deadline": typeDeadline,
        "receptor_blood_type": receptorBloodType,
        "unit_type": unitType,
      };
}
