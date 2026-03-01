import 'dart:developer';
import 'package:flutter/foundation.dart';
import '../../../utils/storage/sharepref.dart';
import '../model/user_info.dart';
import '../service/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final LoginService _loginService = LoginService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Userinfo? _user;
  Userinfo? get user => _user;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;
  final _sharepref = LocalStorage();
  String? _token;
  String? get token => _token;

  void setToken(String? token) {
    _token = token;
    notifyListeners();
  }

  /// Login function
  Future<bool> login(
    String email,
    String password, {
    bool rememberMe = false,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final loggedInUser = await _loginService.login(
        email: email,
        password: password,
      );
      _user = loggedInUser;
      _isLoading = false;
      final token = loggedInUser.data.token;
      _token = token;
      log(token);
      if (rememberMe) {
        await _sharepref.setData("token", token);
        // Save user info as JSON
        await _sharepref.saveUser(userinfoToJson(loggedInUser));
      }

      notifyListeners();

      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  // change password
  Future<bool> changePassword(
    String salesRepId,
    String currentPassword,
    String newPassword,
    String confirmPassword,
  ) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await _loginService.changePassword(
        salesRepId: salesRepId,
        currentPassword: currentPassword,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      );
      _isLoading = false;
      notifyListeners();

      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  //save token
  Future<void> loadToken() async {
    _token = await _sharepref.getData("token");
    notifyListeners();
  }

  // Set user directly (e.g. from main.dart)
  void setUser(Userinfo? user) {
    _user = user;
    notifyListeners();
  }

  /// Clear user session
  void logout() {
    _user = null;
    _token = null;
    notifyListeners();
  }
}
