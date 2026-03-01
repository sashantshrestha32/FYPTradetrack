import 'dart:convert';

Attendance attendanceFromJson(String str) =>
    Attendance.fromJson(json.decode(str));
String attendanceToJson(Attendance data) => json.encode(data.toJson());

class Attendance {
  bool success;
  String message;
  Data data;
  Attendance({
    required this.success,
    required this.message,
    required this.data,
  });

  factory Attendance.fromJson(Map<String, dynamic> json) => Attendance(
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
  int id;
  int salesRepId;
  String salesRepName;
  DateTime checkIn;
  dynamic checkOut;
  double latitude;
  double longitude;
  String locationAddress;
  dynamic hoursWorked;

  Data({
    required this.id,
    required this.salesRepId,
    required this.salesRepName,
    required this.checkIn,
    required this.checkOut,
    required this.latitude,
    required this.longitude,
    required this.locationAddress,
    required this.hoursWorked,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    salesRepId: json["salesRepId"],
    salesRepName: json["salesRepName"],
    checkIn: DateTime.parse(json["checkIn"]),
    checkOut: json["checkOut"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    locationAddress: json["locationAddress"],
    hoursWorked: json["hoursWorked"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "salesRepId": salesRepId,
    "salesRepName": salesRepName,
    "checkIn": checkIn.toIso8601String(),
    "checkOut": checkOut,
    "latitude": latitude,
    "longitude": longitude,
    "locationAddress": locationAddress,
    "hoursWorked": hoursWorked,
  };
}
