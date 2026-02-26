import 'app.dart';
import 'core/provider/navigation_provider.dart';
import 'feature/attendance/provider/attendence_provider.dart';
import 'feature/outlet/provider/outlate_provider.dart';
import 'feature/orders/provider/order_provider.dart';
import 'feature/product/provider/product_provider.dart';
import 'feature/auth/model/user_info.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tradetrac/feature/auth/provider/auth_pod.dart';
import 'core/router/router_config.dart';
import 'utils/storage/sharepref.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sharepref = LocalStorage();
  final token = await sharepref.getData("token");
  final userJson = await sharepref.getUser();
  Userinfo? user;
  if (userJson != null) {
    try {
      user = userinfoFromJson(userJson);
    } catch (e) {
      // Handle decode error if any
    }
  }

  final initialLocation = token != null ? '/' : '/splash';
  final router = createAppRouter(initialLocation);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider()
            ..setToken(token)
            ..setUser(user),
        ),
        ChangeNotifierProvider(create: (_) => AttendanceProvider()),
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
        ChangeNotifierProvider(create: (_) => OutlateProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
      ],
      child: MyApp(router: router),
    ),
  );
}
