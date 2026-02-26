import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../feature/attendance/attendance_screen.dart';
import '../../feature/auth/sign_in_screen.dart';
import '../../feature/main/main_screen.dart';
import '../../feature/onboarding/onboarding_screen.dart';
import '../../feature/orders/orders_screen.dart';
import '../../feature/profile/profile_screen.dart';
import '../../feature/profile/reports_screen.dart';
import '../../feature/profile/privacy_policy_screen.dart';
import '../../feature/profile/change_password_screen.dart';
import '../../feature/profile/terms_conditions_screen.dart';
import '../../feature/profile/about_us_screen.dart';
import '../../feature/profile/support_screen.dart';
import '../../feature/splash/splash_screen.dart';
import '../../feature/outlet/add_outlate.dart';
import '../../feature/outlet/outlet_detail_screen.dart';
import '../../feature/outlet/model/outlist_model.dart';
import '../../feature/orders/create_order_screen.dart';
import '../../feature/orders/order_detail_screen.dart';
import '../../feature/orders/model/order_model.dart';
import '../../feature/map/map_view_screen.dart';

// Router configuration for the app
GoRouter createAppRouter(String initialLocation) {
  return GoRouter(
    initialLocation: initialLocation,
    routes: [
      // Splash screen
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),

      // Main route (bottom navigation)
      GoRoute(path: '/', builder: (context, state) => const MainScreen()),

      // Profile routes
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/reports',
        builder: (context, state) => const ReportsScreen(),
      ),
      GoRoute(
        path: '/privacy-policy',
        builder: (context, state) => const PrivacyPolicyScreen(),
      ),
      GoRoute(
        path: '/change-password',
        builder: (context, state) => const ChangePasswordScreen(),
      ),
      GoRoute(
        path: '/terms-conditions',
        builder: (context, state) => const TermsConditionsScreen(),
      ),
      GoRoute(
        path: '/about-us',
        builder: (context, state) => const AboutUsScreen(),
      ),
      GoRoute(
        path: '/support',
        builder: (context, state) => const SupportScreen(),
      ),
      GoRoute(
        path: '/SignIn',
        builder: (context, state) => const SignInScreen(),
      ),
      GoRoute(
        path: '/orders',
        builder: (context, state) => const OrdersScreen(),
      ),
      GoRoute(path: '/main', builder: (context, state) => const MainScreen()),
      GoRoute(
        path: '/attendance',
        builder: (context, state) => const AttendanceScreen(),
      ),
      GoRoute(
        path: '/add_outlet',
        builder: (context, state) => const AddOutlate(),
      ),
      GoRoute(
        path: '/outlet_detail',
        builder: (context, state) {
          final outlet = state.extra as Outlatedata;
          return OutletDetailScreen(outlet: outlet);
        },
      ),
      GoRoute(
        path: '/create_order',
        builder: (context, state) {
          final outlet = state.extra as Outlatedata;
          return CreateOrderScreen(outlet: outlet);
        },
      ),
      GoRoute(
        path: '/order_detail',
        builder: (context, state) {
          final order = state.extra as OrderData;
          return OrderDetailScreen(order: order);
        },
      ),
      GoRoute(
        path: '/map_view',
        builder: (context, state) {
          final params = state.extra as Map<String, dynamic>;
          return MapViewScreen(
            lat: params['lat'],
            lng: params['lng'],
            address: params['address'],
            title: params['title'] ?? 'Map',
          );
        },
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Page Not Found')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Page not found',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go('/'),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );
}
