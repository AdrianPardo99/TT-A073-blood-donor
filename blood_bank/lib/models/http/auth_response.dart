import 'dart:convert';

class AuthResponse {
  AuthResponse({
    required this.token,
    required this.user,
  });

  String token;
  User user;

  factory AuthResponse.fromJson(String str) =>
      AuthResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AuthResponse.fromMap(Map<String, dynamic> json) => AuthResponse(
        token: json["token"],
        user: User.fromMap(json["user"]),
      );

  Map<String, dynamic> toMap() => {
        "token": token,
        "user": user.toMap(),
      };
}

class User {
  User({
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.center,
  });

  String email;
  String firstName;
  String lastName;
  Center center;

  factory User.fromJson(String str) => User.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory User.fromMap(Map<String, dynamic> json) => User(
        email: json["email"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        center: Center.fromMap(json["center"]),
      );

  Map<String, dynamic> toMap() => {
        "email": email,
        "first_name": firstName,
        "last_name": lastName,
        "center": center.toMap(),
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
