import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:tradetrac/feature/attendance/provider/attendence_provider.dart';
import '../../utils/constant/color_constants.dart';
import '../../core/faildialog.dart';
import '../auth/provider/auth_pod.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.user!.data.user;
    // context.read<AttendanceProvider>().attendance!.data.salesRepId;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        title: const Text(
          'Change Password',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Create Password',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),

              // Current password
              _buildPasswordField(
                label: 'Enter your current password',
                controller: _currentPasswordController,
                obscureText: _obscureCurrentPassword,
                onToggleVisibility: () {
                  setState(() {
                    _obscureCurrentPassword = !_obscureCurrentPassword;
                  });
                },
              ),

              const SizedBox(height: 16),

              // New password
              _buildPasswordField(
                label: 'Enter your new password',
                controller: _newPasswordController,
                obscureText: _obscureNewPassword,
                onToggleVisibility: () {
                  setState(() {
                    _obscureNewPassword = !_obscureNewPassword;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Confirm password
              _buildPasswordField(
                label: 'Confirm your new password',
                controller: _confirmPasswordController,
                obscureText: _obscureConfirmPassword,
                onToggleVisibility: () {
                  setState(() {
                    _obscureConfirmPassword = !_obscureConfirmPassword;
                  });
                },
              ),
              const SizedBox(height: 24),

              // Save button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: authProvider.isLoading
                      ? null
                      : () async {
                          if (!_formKey.currentState!.validate()) return;

                          if (_newPasswordController.text.trim() !=
                              _confirmPasswordController.text.trim()) {
                            MessagePresenter.show(
                              context: context,
                              message: 'New and confirm password do not match',
                              level: MessageLevel.error,
                              mode: MessageMode.dialog,
                            );
                            return;
                          }
                          final success = await authProvider.changePassword(
                            user.toString(),
                            _currentPasswordController.text.trim(),
                            _newPasswordController.text.trim(),
                            _confirmPasswordController.text.trim(),
                          );
                          if (!mounted) return;
                          if (success) {
                            MessagePresenter.show(
                              context: context,
                              message: 'Password changed successfully',
                              level: MessageLevel.success,
                              mode: MessageMode.dialog,
                              onAction: () {
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                            );
                            MessagePresenter.show(
                              context: context,
                              message: 'Password changed successfully',
                              level: MessageLevel.success,
                              mode: MessageMode.dialog,
                              onAction: () {
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                              },
                            );
                          } else {
                            MessagePresenter.show(
                              context: context,
                              message: 'Something went wrong,Please ',
                              level: MessageLevel.error,
                              mode: MessageMode.dialog,
                            );
                          }
                        },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Save',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required String label,
    required TextEditingController controller,
    required bool obscureText,
    required VoidCallback onToggleVisibility,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        suffixIcon: IconButton(
          icon: Icon(
            obscureText ? Icons.visibility_off : Icons.visibility,
            color: Colors.grey,
          ),
          onPressed: onToggleVisibility,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your password';
        }
        if (value.length < 6) {
          return 'Password must be at least 6 characters';
        }
        return null;
      },
    );
  }
}
