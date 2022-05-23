import 'dart:convert';

class CenterResponse {
  CenterResponse({
    required this.count,
    required this.centers,
  });

  int count;
  List<Center> centers;

  factory CenterResponse.fromJson(String str) =>
      CenterResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CenterResponse.fromMap(Map<String, dynamic> json) => CenterResponse(
        count: json["count"],
        centers:
            List<Center>.from(json["results"].map((x) => Center.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "count": count,
        "centers": List<dynamic>.from(centers.map((x) => x.toMap())),
      };
}

class Center {
  Center({
    required this.id,
    required this.name,
    required this.address,
    required this.city,
    required this.type,
    required this.latitude,
    required this.longitude,
  });

  int id;
  String name;
  String address;
  String city;
  String type;
  String latitude;
  String longitude;

  factory Center.fromJson(String str) => Center.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Center.fromMap(Map<String, dynamic> json) => Center(
        id: json["id"],
        name: json["name"],
        address: json["address"],
        city: json["city"],
        type: json["type"],
        latitude: json["latitude"],
        longitude: json["longitude"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "address": address,
        "city": city,
        "type": type,
        "latitude": latitude,
        "longitude": longitude,
      };
}
