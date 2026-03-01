import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:tradetrac/utils/storage/sharepref.dart';
import '../../../utils/constant/api_constant.dart';
import '../model/user_info.dart';

class LoginService {
  Future<Userinfo> login({
    required String email,
    required String password,
  }) async {
    try {
      final url = Uri.parse(
        "${ApiConstant.baseUrl}${ApiConstant.loginEndpoint}",
      );
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );
      log(response.body);
      if (response.statusCode == 200) {
        return Userinfo.fromJson(jsonDecode(response.body));
      } else {
        throw Exception(
          "Login failed. Status: ${response.statusCode}, Body: ${response.body}",
        );
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  //change password

  Future<void> changePassword({
    required String salesRepId,
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,

  }) async {
    try {
      var token = await LocalStorage().getData("token");
      final url = Uri.parse(
        "${ApiConstant.baseUrl}${ApiConstant.changepassword}",
      );
      final response = await http.post(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "salesRepId": 2,
          "currentPassword": currentPassword,
          "newPassword": newPassword,
          "confirmPassword": confirmPassword,
        }),
      );
      log(response.body);
      if (response.statusCode != 200) {
        throw Exception(
          "Change password failed. Status: ${response.statusCode}, Body: ${response.body}",
        );
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
