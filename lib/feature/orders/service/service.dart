import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import '../../../utils/constant/api_constant.dart';
import '../../../utils/storage/sharepref.dart';
import '../model/order_model.dart';

class OrderService {
  Future<OrderListResponse?> fetchOrders() async {
    try {
      var token = await LocalStorage().getData("token");
      log("Token retrieved: $token");
      final url = Uri.parse("${ApiConstant.baseUrl}${ApiConstant.orderlis}");
      log("Order Request URL: $url");
      final response = await http.get(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );
      log("Order response status: ${response.statusCode}");
      log("Order response: ${response.body}");
      if (response.statusCode == 200) {
        return orderListResponseFromJson(response.body);
      } else {
        log("Server Error: ${response.body}");
        return null;
      }
    } catch (e) {
      log("Connection Error: ${e.toString()}");
      return null;
    }
  }

  Future<bool> createOrder(Map<String, dynamic> orderData) async {
    try {
      var token = await LocalStorage().getData("token");
      final url = Uri.parse("${ApiConstant.baseUrl}${ApiConstant.orderlis}");
      log("Create Order URL: $url");
      log("Order Data: $orderData");

      final response = await http.post(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode(orderData),
      );

      log("Create Order Response: ${response.statusCode}");
      log("Create Order Body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      log("Error creating order: ${e.toString()}");
      return false;
    }
  }
}
