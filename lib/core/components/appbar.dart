// import 'dart:developer';

// import 'package:flutter/material.dart';

// // import '../../../../core/constants/colors.dart';
// import '../constants/edgeinset.dart';
// import '../constants/textstyle.dart';
// import '../../features/authentication/domain/repository/authenticate.dart';

// class AuthAppBar extends StatelessWidget {
//   final String? phone;

//   const AuthAppBar({super.key, this.phone});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: xsmallPadding,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.end,
//         children: [
//           Text(
//             'Phone Number',
//             style: headStyle,
//           ),
//           const SizedBox(
//             width: 100,
//           ),
//           GestureDetector(
//             onTap: () {
//               log('tapped');
//               Authenticate().sendOtp(phone: phone, context);
//             },
//             child: Text(
//               'Done',
//               style: doneStyle,
//             ),
//           ),
//         ],
//       ),
//     );
//     // ));
//   }
// }
