import 'package:flutter/material.dart';
import '../../utils/constant/color_constants.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        title: const Text(
          'Notifications',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildNotificationCategory(
            title: "New Updates",
            notifications: [
              _buildNotificationItem(
                title: "New Feature Available",
                description: "Check out our new attendance tracking feature",
                time: "10 min ago",
                isRead: false,
              ),
              _buildNotificationItem(
                title: "System Update",
                description: "We've updated our system for better performance",
                time: "1 hour ago",
                isRead: true,
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildNotificationCategory(
            title: "Previous Notifications",
            notifications: [
              _buildNotificationItem(
                title: "Order Completed",
                description: "Order #12345 has been successfully delivered",
                time: "Yesterday",
                isRead: true,
              ),
              _buildNotificationItem(
                title: "New Task Assigned",
                description:
                    "You have been assigned a new task by your manager",
                time: "2 days ago",
                isRead: true,
              ),
              _buildNotificationItem(
                title: "Meeting Reminder",
                description: "Don't forget your team meeting tomorrow at 10 AM",
                time: "3 days ago",
                isRead: true,
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildNotificationCategory(
            title: "Attendance Reminders",
            notifications: [
              _buildNotificationItem(
                title: "Check-in Reminder",
                description: "Don't forget to check in when you arrive at work",
                time: "4 days ago",
                isRead: true,
              ),
              _buildNotificationItem(
                title: "Late Check-in",
                description: "You were 15 minutes late for check-in yesterday",
                time: "5 days ago",
                isRead: true,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCategory({
    required String title,
    required List<Widget> notifications,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              "Mark all as read",
              style: TextStyle(fontSize: 12, color: AppColors.primaryColor),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...notifications,
      ],
    );
  }

  Widget _buildNotificationItem({
    required String title,
    required String description,
    required String time,
    required bool isRead,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isRead ? Colors.white : Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isRead
                  ? Colors.grey.shade100
                  : AppColors.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.notifications_outlined,
              color: isRead ? Colors.grey : AppColors.primaryColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isRead ? FontWeight.w500 : FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 8),
                Text(
                  time,
                  style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
                ),
              ],
            ),
          ),
          if (!isRead)
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: AppColors.primaryColor,
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
    );
  }
}
