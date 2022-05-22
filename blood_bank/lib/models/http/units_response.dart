import 'dart:convert';

class UnitsResponse {
  UnitsResponse({
    required this.count,
    required this.units,
  });

  int count;
  List<Unit> units;

  factory UnitsResponse.fromJson(String str) =>
      UnitsResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory UnitsResponse.fromMap(Map<String, dynamic> json) => UnitsResponse(
        count: json["count"],
        units: List<Unit>.from(json["results"].map((x) => Unit.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "count": count,
        "units": List<dynamic>.from(units.map((x) => x.toMap())),
      };
}

class Unit {
  Unit({
    required this.id,
    required this.type,
    required this.bloodType,
    required this.expiredAt,
    required this.canTransfer,
    required this.isAltruistUnit,
    required this.donorGender,
    required this.donorAge,
  });

  int id;
  String type;
  String bloodType;
  String expiredAt;
  bool canTransfer;
  bool isAltruistUnit;
  String donorGender;
  int donorAge;

  factory Unit.fromJson(String str) => Unit.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Unit.fromMap(Map<String, dynamic> json) => Unit(
        id: json["id"],
        type: json["type"],
        bloodType: json["blood_type"],
        expiredAt: json["expired_at"],
        canTransfer: json["can_transfer"],
        isAltruistUnit: json["is_altruist_unit"],
        donorGender: json["donor_gender"],
        donorAge: json["donor_age"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "type": type,
        "blood_type": bloodType,
        "expired_at": expiredAt,
        "can_transfer": canTransfer,
        "is_altruist_unit": isAltruistUnit,
        "donor_gender": donorGender,
        "donor_age": donorAge,
      };
  @override
  String toString() {
    return "Unidad: ${type} del grupo: ${bloodType} de donador: ${(donorGender == "Male") ? "Hombre" : (donorGender == "Female") ? "Mujer" : "Otro genero"}";
  }
}
