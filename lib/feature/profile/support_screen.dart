import 'package:flutter/material.dart';
import '../../utils/constant/color_constants.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Support & Help",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Center(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.support_agent_rounded,
                      size: 60,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "How can we help you?",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Our team is here to assist you with any questions or issues.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // Contact Options
            const Text(
              "Contact Us",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textColor,
              ),
            ),
            const SizedBox(height: 16),
            _buildContactCard(
              icon: Icons.phone_in_talk,
              title: "Customer Support",
              subtitle: "+1-800-123-4567",
              onTap: () => _launchUrl('tel:+18001234567'),
              color: Colors.blue,
            ),
            const SizedBox(height: 12),
            _buildContactCard(
              icon: Icons.email_outlined,
              title: "Email Support",
              subtitle: "support@saledes.com",
              onTap: () => _launchUrl('mailto:support@saledes.com'),
              color: Colors.orange,
            ),
            const SizedBox(height: 12),
            _buildContactCard(
              icon: Icons.chat_bubble_outline,
              title: "WhatsApp",
              subtitle: "Chat with us",
              onTap: () => _launchUrl('https://wa.me/18001234567'),
              color: Colors.green,
            ),

            const SizedBox(height: 30),
            // FAQ Section
            const Text(
              "Frequently Asked Questions",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textColor,
              ),
            ),
            const SizedBox(height: 16),
            _buildExpansionTile(
              "How do I reset my password?",
              "Go to the Profile screen and select 'Change Password'. If you forgot your password, use the 'Forgot Password' link on the login screen.",
            ),
            _buildExpansionTile(
              "How can I update my profile?",
              "Currently, profile details are managed by your administrator. Please contact support for changes.",
            ),
            _buildExpansionTile(
              "Where can I see my sales reports?",
              "Navigate to the 'Reports' section from the main menu or profile screen to access your daily sales summaries.",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildExpansionTile(String title, String content) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: ExpansionTile(
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textColor,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(
              content,
              style: TextStyle(fontSize: 13, color: Colors.grey[700]),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }
}
