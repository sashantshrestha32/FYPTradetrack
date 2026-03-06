import 'package:flutter/material.dart';
import '../../utils/constant/color_constants.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        title: const Text(
          'About Us',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            Image.asset(
              'assets/images/logo.png',
              height: 80,
              // If asset doesn't exist, use a placeholder
              errorBuilder: (context, error, stackTrace) => Container(
                height: 80,
                width: 80,
                color: AppColors.primaryColor,
                child: const Icon(
                  Icons.business,
                  color: Colors.white,
                  size: 40,
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'SaleDes',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
              ),
            ),
            const Text(
              'Version 1.0.0',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Our Mission',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'To empower businesses with innovative sales management solutions that drive growth and efficiency.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'About SaleDes',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'SaleDes is a comprehensive sales management platform designed to help businesses streamline their sales operations, track performance, and boost productivity. Our intuitive mobile application provides real-time insights, efficient order management, and seamless communication between sales teams and management.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Our Team',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildTeamMember(
              name: 'John Smith',
              role: 'Founder & CEO',
              imageUrl: 'assets/images/team/john.jpg',
            ),
            _buildTeamMember(
              name: 'Sarah Johnson',
              role: 'CTO',
              imageUrl: 'assets/images/team/sarah.jpg',
            ),
            _buildTeamMember(
              name: 'Michael Brown',
              role: 'Head of Product',
              imageUrl: 'assets/images/team/michael.jpg',
            ),
            const SizedBox(height: 32),
            const Text(
              'Contact Us',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            _buildContactItem(
              icon: Icons.email,
              text: 'support@saledes.com',
            ),
            _buildContactItem(
              icon: Icons.phone,
              text: '+1 (555) 123-4567',
            ),
            _buildContactItem(
              icon: Icons.location_on,
              text: '123 Business Avenue, Tech City, CA 94103',
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamMember({
    required String name,
    required String role,
    required String imageUrl,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.grey[200],
            backgroundImage: AssetImage(imageUrl),
            onBackgroundImageError: (exception, stackTrace) {},
            child: Icon(
              Icons.person,
              color: Colors.grey[400],
              size: 30,
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                role,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem({
    required IconData icon,
    required String text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 20,
            color: AppColors.primaryColor,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}