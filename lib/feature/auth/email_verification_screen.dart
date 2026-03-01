// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import '../../utils/color_constants.dart';
// import 'set_password_screen.dart';

// class EmailVerificationScreen extends StatefulWidget {
//   final String email;

//   const EmailVerificationScreen({super.key, required this.email});

//   @override
//   State<EmailVerificationScreen> createState() =>
//       _EmailVerificationScreenState();
// }
// class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
//   final List<TextEditingController> _controllers = List.generate(
//     6,
//     (index) => TextEditingController(),
//   );

//   final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());

//   @override
//   void dispose() {
//     for (var controller in _controllers) {
//       controller.dispose();
//     }
//     for (var node in _focusNodes) {
//       node.dispose();
//     }
//     super.dispose();
//   }

//   void _onCodeChanged(String value, int index) {
//     if (value.length == 1 && index < 5) {
//       _focusNodes[index + 1].requestFocus();
//     }
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
//               'Check Your Email',
//               style: TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//                 color: AppColors.textColor,
//               ),
//             ),
//             const SizedBox(height: 12),
//             Text(
//               'We sent a code to ${widget.email}. Enter it here to verify that the email address is yours.',
//               style: const TextStyle(
//                 fontSize: 14,
//                 color: AppColors.lightTextColor,
//               ),
//             ),
//             const SizedBox(height: 40),

//             // OTP input fields
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: List.generate(
//                 6,
//                 (index) => SizedBox(
//                   width: 45,
//                   height: 50,
//                   child: TextField(
//                     controller: _controllers[index],
//                     focusNode: _focusNodes[index],
//                     keyboardType: TextInputType.number,
//                     textAlign: TextAlign.center,
//                     maxLength: 1,
//                     onChanged: (value) => _onCodeChanged(value, index),
//                     inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//                     decoration: InputDecoration(
//                       counterText: '',
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(8),
//                         borderSide: BorderSide(color: Colors.grey.shade300),
//                       ),
//                       enabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(8),
//                         borderSide: BorderSide(color: Colors.grey.shade300),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(8),
//                         borderSide: const BorderSide(
//                           color: AppColors.primaryColor,
//                         ),
//                       ),
//                       filled: true,
//                       fillColor: Colors.white,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 40),

//             // Verify Code button
//             SizedBox(
//               width: double.infinity,
//               height: 50,
//               child: ElevatedButton(
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => const SetPasswordScreen(),
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
//                   'Verify Code',
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),

//             // Didn't get the email?
//             Center(
//               child: RichText(
//                 text: const TextSpan(
//                   style: TextStyle(
//                     fontSize: 14,
//                     color: AppColors.lightTextColor,
//                   ),
//                   children: [
//                     TextSpan(text: "Didn't get the email? "),
//                     TextSpan(
//                       text: 'Resend email',
//                       style: TextStyle(
//                         color: AppColors.primaryColor,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
