import 'package:flutter/material.dart';
import '../utils/constant/color_constants.dart';

enum MessageLevel { success, error, warning, info }

enum MessageMode { snackbar, dialog, inline }

class AppMessage extends StatelessWidget {
  final String message;
  final MessageLevel level;
  final VoidCallback? onAction;
  final String? actionText;
  final bool isDialog;

  const AppMessage({
    super.key,
    required this.message,
    required this.level,
    this.onAction,
    this.actionText,
    this.isDialog = false,
  });

  Color get color {
    switch (level) {
      case MessageLevel.success:
        return const Color(0xFF4CAF50); // Modern Green
      case MessageLevel.error:
        return const Color(0xFFE53935); // Modern Red
      case MessageLevel.warning:
        return const Color(0xFFFF9800); // Modern Orange
      case MessageLevel.info:
        return AppColors.primaryColor;
    }
  }

  IconData get icon {
    switch (level) {
      case MessageLevel.success:
        return Icons.check_circle_rounded;
      case MessageLevel.error:
        return Icons.error_rounded;
      case MessageLevel.warning:
        return Icons.warning_rounded;
      case MessageLevel.info:
        return Icons.info_rounded;
    }
  }

  String get title {
    switch (level) {
      case MessageLevel.success:
        return "Success";
      case MessageLevel.error:
        return "Error";
      case MessageLevel.warning:
        return "Warning";
      case MessageLevel.info:
        return "Information";
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isDialog) {
      return _buildDialogLayout(context);
    }
    return _buildSnackBarLayout(context);
  }

  Widget _buildSnackBarLayout(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha:0.1),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border(left: BorderSide(color: color, width: 4)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: AppColors.textColor,
                  ),
                ),
                Text(
                  message,
                  style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                ),
              ],
            ),
          ),
          if (onAction != null && actionText != null)
            TextButton(
              onPressed: onAction,
              child: Text(
                actionText!,
                style: TextStyle(color: color, fontWeight: FontWeight.bold),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDialogLayout(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color.withValues(alpha:0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 48),
        ),
        const SizedBox(height: 16),
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textColor,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: onAction ?? () => Navigator.of(context).pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child: Text(actionText ?? "Okay"),
          ),
        ),
      ],
    );
  }
}

class MessagePresenter {
  static void show({
    required BuildContext context,
    required String message,
    required MessageLevel level,
    required MessageMode mode,
    VoidCallback? onAction,
    String? actionText,
  }) {
    if (mode == MessageMode.snackbar) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          content: AppMessage(
            message: message,
            level: level,
            onAction: onAction,
            actionText: actionText,
          ),
        ),
      );
    } else if (mode == MessageMode.dialog) {
      showDialog(
        context: context,
        builder: (_) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: AppMessage(
              message: message,
              level: level,
              onAction: onAction,
              actionText: actionText,
              isDialog: true,
            ),
          ),
        ),
      );
    } else {
      throw Exception("Unknown message mode");
    }
  }
}
