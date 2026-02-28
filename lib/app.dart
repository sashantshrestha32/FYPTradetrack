import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'utils/constant/color_constants.dart';

class MyApp extends StatelessWidget {
  final GoRouter router;
  const MyApp({super.key, required this.router});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryColor),
        useMaterial3: true,
        fontFamily: 'Poppins',
      ),
      debugShowMaterialGrid: false,
      routerConfig: router,
    );
  }
}
