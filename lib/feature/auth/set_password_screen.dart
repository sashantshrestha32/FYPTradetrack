// import 'package:flutter/material.dart';
// import '../../utils/constant/color_constants.dart';
// import 'password_reset_success_screen.dart';

// class SetPasswordScreen extends StatefulWidget {
//   const SetPasswordScreen({super.key});

//   @override
//   State<SetPasswordScreen> createState() => _SetPasswordScreenState();
// }

// class _SetPasswordScreenState extends State<SetPasswordScreen> {
//   final _passwordController = TextEditingController();
//   final _confirmPasswordController = TextEditingController();
//   bool _obscurePassword = true;
//   bool _obscureConfirmPassword = true;

//   @override
//   void dispose() {
//     _passwordController.dispose();
//     _confirmPasswordController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: AppColors.textColor),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(24.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Set a new password',
//               style: TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//                 color: AppColors.textColor,
//               ),
//             ),
//             const SizedBox(height: 12),
//             const Text(
//               'Create a strong password that\'s at least 8 characters long. A strong password combines letters, numbers, and symbols.',
//               style: TextStyle(fontSize: 14, color: AppColors.lightTextColor),
//             ),
//             const SizedBox(height: 30),

//             // New Password field
//             const Text(
//               'New Password',
//               style: TextStyle(
//                 fontSize: 14,
//                 fontWeight: FontWeight.w500,
//                 color: AppColors.textColor,
//               ),
//             ),
//             const SizedBox(height: 8),
//             TextField(
//               controller: _passwordController,
//               obscureText: _obscurePassword,
//               decoration: InputDecoration(
//                 hintText: 'Enter your new password',
//                 prefixIcon: const Icon(Icons.lock_outline, color: Colors.grey),
//                 suffixIcon: IconButton(
//                   icon: Icon(
//                     _obscurePassword ? Icons.visibility_off : Icons.visibility,
//                     color: Colors.grey,
//                   ),
//                   onPressed: () {
//                     setState(() {
//                       _obscurePassword = !_obscurePassword;
//                     });
//                   },
//                 ),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(8),
//                   borderSide: BorderSide(color: Colors.grey.shade300),
//                 ),
//                 enabledBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(8),
//                   borderSide: BorderSide(color: Colors.grey.shade300),
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(8),
//                   borderSide: const BorderSide(color: AppColors.primaryColor),
//                 ),
//                 contentPadding: const EdgeInsets.symmetric(vertical: 16),
//                 filled: true,
//                 fillColor: Colors.white,
//               ),
//             ),
//             const SizedBox(height: 20),

//             // Confirm New Password field
//             const Text(
//               'Confirm New Password',
//               style: TextStyle(
//                 fontSize: 14,
//                 fontWeight: FontWeight.w500,
//                 color: AppColors.textColor,
//               ),
//             ),
//             const SizedBox(height: 8),
//             TextField(
//               controller: _confirmPasswordController,
//               obscureText: _obscureConfirmPassword,
//               decoration: InputDecoration(
//                 hintText: 'Confirm your new password',
//                 prefixIcon: const Icon(Icons.lock_outline, color: Colors.grey),
//                 suffixIcon: IconButton(
//                   icon: Icon(
//                     _obscureConfirmPassword
//                         ? Icons.visibility_off
//                         : Icons.visibility,
//                     color: Colors.grey,
//                   ),
//                   onPressed: () {
//                     setState(() {
//                       _obscureConfirmPassword = !_obscureConfirmPassword;
//                     });
//                   },
//                 ),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(8),
//                   borderSide: BorderSide(color: Colors.grey.shade300),
//                 ),
//                 enabledBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(8),
//                   borderSide: BorderSide(color: Colors.grey.shade300),
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(8),
//                   borderSide: const BorderSide(color: AppColors.primaryColor),
//                 ),
//                 contentPadding: const EdgeInsets.symmetric(vertical: 16),
//                 filled: true,
//                 fillColor: Colors.white,
//               ),
//             ),
//             const SizedBox(height: 30),

//             // Reset Password button
//             SizedBox(
//               width: double.infinity,
//               height: 50,
//               child: ElevatedButton(
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => const PasswordResetSuccessScreen(),
//                     ),
//                   );
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: AppColors.primaryColor,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//                 child: const Text(
//                   'Reset Password',
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
