import 'package:flutter/material.dart';
import '../../utils/constant/color_constants.dart';

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        title: const Text(
          'Terms & Conditions',
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Terms and Conditions',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Last Updated: June 10, 2023',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 24),
            _buildSection(
              title: '1. Acceptance of Terms',
              content: 'By accessing or using the SaleDes application ("App"), you agree to be bound by these Terms and Conditions. If you do not agree to these terms, please do not use the App.',
            ),
            _buildSection(
              title: '2. User Accounts',
              content: 'You are responsible for maintaining the confidentiality of your account credentials and for all activities that occur under your account. You must immediately notify us of any unauthorized use of your account.',
            ),
            _buildSection(
              title: '3. User Conduct',
              content: 'You agree not to use the App for any illegal purposes or in any way that could damage, disable, or impair the App. You further agree not to attempt to gain unauthorized access to any part of the App.',
            ),
            _buildSection(
              title: '4. Intellectual Property',
              content: 'All content, features, and functionality of the App, including but not limited to text, graphics, logos, and software, are owned by SaleDes and are protected by copyright, trademark, and other intellectual property laws.',
            ),
            _buildSection(
              title: '5. Limitation of Liability',
              content: 'To the maximum extent permitted by law, SaleDes shall not be liable for any indirect, incidental, special, consequential, or punitive damages, including loss of profits, data, or business opportunities.',
            ),
            _buildSection(
              title: '6. Modifications to Terms',
              content: 'We reserve the right to modify these Terms at any time. Your continued use of the App after any changes indicates your acceptance of the modified Terms.',
            ),
            _buildSection(
              title: '7. Governing Law',
              content: 'These Terms shall be governed by and construed in accordance with the laws of the jurisdiction in which SaleDes operates, without regard to its conflict of law provisions.',
            ),
            _buildSection(
              title: '8. Contact Information',
              content: 'If you have any questions about these Terms, please contact us at support@saledes.com.',
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required String content}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}