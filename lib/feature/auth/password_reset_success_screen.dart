// import 'package:flutter/material.dart';
// import '../../utils/constant/color_constants.dart';
// import 'sign_in_screen.dart';

// class PasswordResetSuccessScreen extends StatelessWidget {
//   const PasswordResetSuccessScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(24.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               // Success icon
//               Container(
//                 width: 80,
//                 height: 80,
//                 decoration: BoxDecoration(
//                   color: AppColors.primaryColor,
//                   shape: BoxShape.circle,
//                 ),
//                 child: const Icon(Icons.check, color: Colors.white, size: 40),
//               ),
//               const SizedBox(height: 24),

//               // Success text
//               const Text(
//                 'PASSWORD RESET',
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   color: AppColors.textColor,
//                   letterSpacing: 1.2,
//                 ),
//               ),
//               const SizedBox(height: 16),
//               const Text(
//                 'Your password has been reset successfully!',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(fontSize: 14, color: AppColors.lightTextColor),
//               ),
//               const SizedBox(height: 40),

//               // Back to Login button
//               SizedBox(
//                 width: double.infinity,
//                 height: 50,
//                 child: ElevatedButton(
//                   onPressed: () {
//                     Navigator.pushAndRemoveUntil(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) =>  SignInScreen(),
//                       ),
//                       (route) => false,
//                     );
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: AppColors.primaryColor,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ),
//                   child: const Text(
//                     'Back to Login',
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
