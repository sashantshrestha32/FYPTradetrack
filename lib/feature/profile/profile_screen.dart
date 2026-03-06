import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../utils/constant/color_constants.dart';
import '../auth/provider/auth_pod.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var authProvider = context.watch<AuthProvider>();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        title: const Text(
          'Profile',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile header
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Profile image
                  const CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.grey,
                    child: Icon(Icons.person, size: 50, color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  // Name
                  Text(
                    authProvider.user?.data.user.fullName ?? 'User Name',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Email
                  Text(
                    authProvider.user?.data.user.email ?? '',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 4),
                  // Phone
                  Text(
                    authProvider.user?.data.user.phone ?? '',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 4),
                  // Role
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      authProvider.user?.data.user.role ?? '',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Stats row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStatItem('Sales Today', '₹ 25,000'),
                      _buildStatItem('Attendance', '100%'),
                      _buildStatItem('Outlets Visited', '8/10'),
                    ],
                  ),
                ],
              ),
            ),

            const Divider(),

            // Menu items
            _buildMenuItem(
              icon: Icons.assignment_outlined,
              title: 'Attendance History',
              onTap: () => context.push('/attendance'),
            ),
            _buildMenuItem(
              icon: Icons.history,
              title: 'Order History',
              onTap: () => context.push('/orders'),
            ),
            _buildMenuItem(
              icon: Icons.support_agent_outlined,
              title: 'View Support',
              onTap: () => context.push('/support'),
            ),
            _buildMenuItem(
              icon: Icons.password_outlined,
              title: 'Change Password',
              onTap: () => context.push('/change-password'),
            ),
            _buildMenuItem(
              icon: Icons.privacy_tip_outlined,
              title: 'Privacy Policy',
              onTap: () => context.push('/privacy-policy'),
            ),
            _buildMenuItem(
              icon: Icons.description_outlined,
              title: 'Terms & Conditions',
              onTap: () => context.push('/terms-conditions'),
            ),
            _buildMenuItem(
              icon: Icons.info_outline,
              title: 'About Us',
              onTap: () => context.push('/about-us'),
            ),
            _buildMenuItem(
              icon: Icons.star_outline,
              title: 'Rate this App',
              onTap: () {},
            ),
            // Logout button
            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton.icon(
                onPressed: () {
                  authProvider.logout();
                  context.go('/SignIn');
                },
                icon: const Icon(Icons.logout, color: Colors.red),
                label: const Text(
                  'Log Out',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.red,
                  elevation: 0,
                  side: const BorderSide(color: Colors.red),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      ],
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey[700]),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
    );
  }
}
