import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import '../../../utils/constant/api_constant.dart';
import '../../../utils/storage/sharepref.dart';
import '../model/outlist_model.dart';
import '../../orders/model/order_model.dart';

class OutlateService {
  Future<Outlatelist?> getOutlet() async {
    try {
      var token = await LocalStorage().getData("token");
      log("Token retrieved: $token");
      final url = Uri.parse("${ApiConstant.baseUrl}${ApiConstant.outlet}");
      log("Request URL: $url");
      final response = await http.get(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );
      log("Outlet response status: ${response.statusCode}");
      log("Outlet response: ${response.body}");
      if (response.statusCode == 200) {
        return outlatelistFromJson(response.body);
      } else {
        return null;
      }
    } catch (e) {
      log(e.toString());
    }
    return null;
  }

  // add outlate
  Future<bool> addOutlet(
    String name,
    String ownername,
    String phone,
    String email,
    String location,
    String address,
    double latitude,
    double longitude,
  ) async {
    try {
      var token = await LocalStorage().getData("token");
      log("Token retrieved: $token");
      final url = Uri.parse("${ApiConstant.baseUrl}${ApiConstant.addoutlate}");
      var body = jsonEncode({
        "outletName": name,
        "ownerName": ownername,
        "phone": phone,
        "email": email,
        "location": location,
        "address": address,
        "latitude": latitude,
        "longitude": longitude,
      });
      log("Request URL: $url");
      final response = await http.post(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: body,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        log("Outlet added successfully: ${response.body}");
        return true;
      }
    } catch (e) {
      log(e.toString());
    }
    return false;
  }

  // take order by outlet
  Future<List<OrderData>> getOrderByOutlet(int outletId) async {
    try {
      var token = await LocalStorage().getData("token");
      final endpoint = ApiConstant.orderByOutlet.replaceAll(
        "{outletId}",
        outletId.toString(),
      );
      final url = Uri.parse("${ApiConstant.baseUrl}$endpoint");
      log("Order by outlet URL: $url");
      final response = await http.get(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );
      log("Order by outlet response: ${response.body}");
      if (response.statusCode == 200) {
        final responseData = orderListResponseFromJson(response.body);
        return responseData.data;
      }
    } catch (e) {
      log(e.toString());
    }
    return [];
  }
}
