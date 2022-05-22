import 'dart:convert';

class CapabilitiesResponse {
  CapabilitiesResponse({
    required this.count,
    required this.capabilities,
  });

  int count;
  List<Capability> capabilities;

  factory CapabilitiesResponse.fromJson(String str) =>
      CapabilitiesResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CapabilitiesResponse.fromMap(Map<String, dynamic> json) =>
      CapabilitiesResponse(
        count: json["count"],
        capabilities: List<Capability>.from(
            json["results"].map((x) => Capability.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "count": count,
        "capabilities": List<dynamic>.from(capabilities.map((x) => x.toMap())),
      };
}

class Capability {
  Capability({
    required this.id,
    required this.type,
    required this.minQty,
    required this.maxQty,
  });

  int id;
  String type;
  int minQty;
  int maxQty;

  factory Capability.fromJson(String str) =>
      Capability.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Capability.fromMap(Map<String, dynamic> json) => Capability(
        id: json["id"],
        type: json["type"],
        minQty: json["min_qty"],
        maxQty: json["max_qty"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "type": type,
        "min_qty": minQty,
        "max_qty": maxQty,
      };
  @override
  String toString() {
    return "Tipo de unidad: ${type} con capacidad min: ${minQty} y max: ${maxQty}";
  }
}
