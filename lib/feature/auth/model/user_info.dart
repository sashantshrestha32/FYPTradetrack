import 'dart:convert';

Userinfo userinfoFromJson(String str) => Userinfo.fromJson(json.decode(str));
String userinfoToJson(Userinfo data) => json.encode(data.toJson());

class Userinfo {
  bool success;
  String message;
  Data data;

  Userinfo({required this.success, required this.message, required this.data});

  factory Userinfo.fromJson(Map<String, dynamic> json) => Userinfo(
    success: json["success"],
    message: json["message"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data.toJson(),
  };
}

class Data {
  String token;
  DateTime expiry;
  User user;

  Data({required this.token, required this.expiry, required this.user});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    token: json["token"],
    expiry: DateTime.parse(json["expiry"]),
    user: User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "token": token,
    "expiry": expiry.toIso8601String(),
    "user": user.toJson(),
  };
}

class User {
  int id;
  String fullName;
  String email;
  String phone;
  String role;
  User({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    fullName: json["fullName"],
    email: json["email"],
    phone: json["phone"],
    role: json["role"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "fullName": fullName,
    "email": email,
    "phone": phone,
    "role": role,
  };
}
