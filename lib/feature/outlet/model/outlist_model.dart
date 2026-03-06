import 'dart:convert';

Outlatelist outlatelistFromJson(String str) =>
    Outlatelist.fromJson(json.decode(str));

String outlatelistToJson(Outlatelist data) => json.encode(data.toJson());

class Outlatelist {
  bool success;
  String message;
  List<Outlatedata> data;

  Outlatelist({
    required this.success,
    required this.message,
    required this.data,
  });

  factory Outlatelist.fromJson(Map<String, dynamic> json) => Outlatelist(
    success: json["success"],
    message: json["message"],
    data: List<Outlatedata>.from(
      json["data"].map((x) => Outlatedata.fromJson(x)),
    ),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Outlatedata {
  int id;
  String outletName;
  String ownerName;
  String phone;
  String email;
  String location;
  String address;
  double latitude;
  double longitude;
  bool isActive;
  DateTime createdAt;
  int visitCount;
  int totalPurchases;

  Outlatedata({
    required this.id,
    required this.outletName,
    required this.ownerName,
    required this.phone,
    required this.email,
    required this.location,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.isActive,
    required this.createdAt,
    required this.visitCount,
    required this.totalPurchases,
  });

  factory Outlatedata.fromJson(Map<String, dynamic> json) => Outlatedata(
    id: json["id"],
    outletName: json["outletName"],
    ownerName: json["ownerName"],
    phone: json["phone"],
    email: json["email"],
    location: json["location"],
    address: json["address"],
    latitude: (json["latitude"] as num).toDouble(),
    longitude: (json["longitude"] as num).toDouble(),
    isActive: json["isActive"],
    createdAt: DateTime.parse(json["createdAt"]),
    visitCount: json["visitCount"],
    totalPurchases: json["totalPurchases"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "outletName": outletName,
    "ownerName": ownerName,
    "phone": phone,
    "email": email,
    "location": location,
    "address": address,
    "latitude": latitude,
    "longitude": longitude,
    "isActive": isActive,
    "createdAt": createdAt.toIso8601String(),
    "visitCount": visitCount,
    "totalPurchases": totalPurchases,
  };
}
