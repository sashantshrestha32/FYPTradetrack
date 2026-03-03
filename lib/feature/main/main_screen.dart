import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/provider/navigation_provider.dart';
import '../../utils/constant/color_constants.dart';
import '../home/home_screen.dart';
import '../attendance/attendance_screen.dart';
import '../outlet/outlet_screen.dart';
import '../product/add_product_screen.dart';
import '../orders/orders_screen.dart';
import '../profile/profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // List of screens for IndexedStack
  @override
  Widget build(BuildContext context) {
    final navigationProvider = Provider.of<NavigationProvider>(context);
    final selectedIndex = navigationProvider.currentIndex;

    debugPrint("MainScreen: Rebuilding with index $selectedIndex");

    // List of screens for IndexedStack
    final List<Widget> screens = [
      const HomeScreen(),
      const AttendanceScreen(),
      const AddProductScreen(),
      const OutletScreen(),
      const OrdersScreen(),
      const ProfileScreen(),
    ];

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        if (didPop) {
          return;
        }

        if (selectedIndex != 0) {
          navigationProvider.setIndex(0);
          return;
        }

        final shouldClose = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text('Exit App'),
            content: const Text(
              'Do you want to close the app?',
              style: TextStyle(fontSize: 16),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Exit', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        );

        if (!mounted) return;

        if (shouldClose == true) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        extendBody: true, // Important for the notch effect and transparency
        body: IndexedStack(index: selectedIndex, children: screens),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 20,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: BottomAppBar(
            shape: const CircularNotchedRectangle(),
            notchMargin: 10,
            color: Colors.white,
            surfaceTintColor: Colors.white,
            elevation: 0,
            height: 70,
            padding: EdgeInsets.zero,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(0, Icons.home_rounded, 'Home'),
                _buildNavItem(1, Icons.access_time_rounded, 'Attendance'),
                _buildNavItem(3, Icons.store_rounded, 'Outlet'),
                _buildNavItem(4, Icons.shopping_bag_rounded, 'Orders'),
                _buildNavItem(5, Icons.person_rounded, 'Profile'),
              ],
            ),
          ),
        ),
        // floatingActionButton: Container(
        //   height: 65,
        //   width: 65,
        //   decoration: BoxDecoration(
        //     shape: BoxShape.circle,
        //     gradient: LinearGradient(
        //       colors: [
        //         AppColors.primaryColor,
        //         AppColors.primaryColor.withValues(alpha: 0.8),
        //       ],
        //       begin: Alignment.topLeft,
        //       end: Alignment.bottomRight,
        //     ),
        //     boxShadow: [
        //       BoxShadow(
        //         color: AppColors.primaryColor.withValues(alpha: 0.4),
        //         blurRadius: 10,
        //         offset: const Offset(0, 5),
        //       ),
        //     ],
        //   ),
        //   child: FloatingActionButton(
        //     backgroundColor: Colors.transparent,
        //     elevation: 0,
        //     onPressed: () {
        //       navigationProvider.setIndex(2);
        //     },
        //     heroTag: 'mainScreenFab',
        //     shape: const CircleBorder(),
        //     child: Icon(
        //       selectedIndex == 2 ? Icons.add : Icons.add,
        //       color: Colors.white,
        //       size: 32,
        //     ),
        //   ),
        // ),
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final navigationProvider = Provider.of<NavigationProvider>(context);
    final selectedIndex = navigationProvider.currentIndex;
    final isSelected = selectedIndex == index;

    return InkWell(
      onTap: () => navigationProvider.setIndex(index),
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: isSelected
            ? BoxDecoration(
                color: AppColors.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              )
            : null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.primaryColor : Colors.grey.shade400,
              size: 26,
            ),
            if (isSelected) ...[
              const SizedBox(height: 4),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryColor,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
