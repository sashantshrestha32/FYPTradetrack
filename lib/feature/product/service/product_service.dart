import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

import '../../../utils/constant/api_constant.dart';
import '../../../utils/storage/sharepref.dart';
import '../model/product_model.dart';

class ProductService {
  // Fetch product list
  Future<ProductListResponse?> fetchProducts() async {
    try {
      var token = await LocalStorage().getData("token");
      log("Token retrieved: $token");
      final url = Uri.parse("${ApiConstant.baseUrl}${ApiConstant.productlist}");
      log("Product Request URL: $url");

      final response = await http.get(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      log("Product response status: ${response.statusCode}");
      log("Product response: ${response.body}");

      if (response.statusCode == 200) {
        return productListResponseFromJson(response.body);
      } else {
        log("Server Error: ${response.body}");
        return null;
      }
    } catch (e) {
      log("Connection Error: ${e.toString()}");
      return null;
    }
  }

  // add product
  Future<Object?> addproduct(
    int id,
    String name,
    String code,
    String unitprice,
    String currentstock,
    bool isactive,
    String createdAt,
  ) async {
    try {
      var token = await LocalStorage().getData("token");
      log("Token retrieved: $token");
      final url = Uri.parse("${ApiConstant.baseUrl}${ApiConstant.addproduct}");
      log("Product Request URL: $url");

      final response = await http.post(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "id": id,
          "name": name,
          "code": code,
          "unitPrice": unitprice,
          "currentStock": currentstock,
          "isActive": true,
          "createdAt": createdAt,
        }),
      );

      log("Product response status: ${response.statusCode}");
      log("Product response: ${response.body}");

      if (response.statusCode == 200) {
        return productListResponseFromJson(response.body);
      } else {
        log("Server Error: ${response.body}");
        return null;
      }
    } catch (e) {
      log("Connection Error: ${e.toString()}");
      return null;
    }
  }
}
