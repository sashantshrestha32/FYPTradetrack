import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:tradetrac/utils/constant/api_constant.dart';
import '../../../utils/storage/sharepref.dart';
import '../model/checkin.dart';

class AttendenceService {
  //check in
  Future<Attendance?> markAttendance(
    String latitude,
    String longitude,
    String locationAddress,
    int salesRepId,
  ) async {
    try {
      var token = await LocalStorage().getData("token");
      final url = Uri.parse("${ApiConstant.baseUrl}${ApiConstant.checkin}");
      final response = await http.post(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "latitude": latitude,
          "longitude": longitude,
          "locationAddress": locationAddress,
          "SalesRepId": salesRepId,
        }),
      );
      log(response.body);
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        log(jsonResponse.toString());
        return Attendance.fromJson(jsonResponse);
      } else {
        return null;
      }
    } catch (e) {
      log(e.toString());
    }
    return null;
  }

  //checkout
  Future<void> checkout(int id) async {
    try {
      var token = await LocalStorage().getData("token");
      // Replace {id} placeholder with actual id value
      final endpoint = ApiConstant.checkout.replaceAll("{id}", id.toString());
      final url = Uri.parse("${ApiConstant.baseUrl}$endpoint");
      log("Checkout URL: $url");
      final response = await http.post(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );
      log("Checkout response: ${response.body}");
      if (response.statusCode != 200) {
        return;
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  // Get attendance by date
  Future<List<dynamic>> getAttendancebydate(String date) async {
    var token = await LocalStorage().getData("token");
    final url = Uri.parse(
      "${ApiConstant.baseUrl}${ApiConstant.getattendancebydate}",
    ).replace(queryParameters: {"date": date});
    final response = await http.get(
      url,
      headers: {"Authorization": "Bearer $token", "Accept": "application/json"},
    );
    log("Attendance by date response: ${response.body}");
    if (response.statusCode != 200) {
      throw Exception(
        "Failed to get attendance. Status: ${response.statusCode}, Body: ${response.body}",
      );
    }
    final decoded = jsonDecode(response.body);
    return decoded["data"] is List ? decoded["data"] : [decoded["data"]];
  }

  // Get attendance summary
  Future<Map<String, dynamic>?> getAttendanceSummary(int salesRepId) async {
    var token = await LocalStorage().getData("token");
    final endpoint = ApiConstant.attendancerepo.replaceAll(
      "{salesRepId}",
      salesRepId.toString(),
    );
    final url = Uri.parse("${ApiConstant.baseUrl}$endpoint");
    log("Attendance summary URL: $url");
    final response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );
    log("Attendance summary response: ${response.body}");
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return null;
  }

  //attendance byrep
  Future<List<dynamic>> getAttendancebyrep(int salesRepId) async {
    var token = await LocalStorage().getData("token");
    final endpoint = ApiConstant.attendancebyrep.replaceAll(
      "{salesRepId}",
      salesRepId.toString(),
    );
    final url = Uri.parse("${ApiConstant.baseUrl}$endpoint");
    log("Attendance by rep URL: $url");
    final response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );
    log("Attendance by rep response: ${response.body}");
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return [];
  }
}
