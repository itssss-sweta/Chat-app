import 'package:chat_app/core/utils/edit.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  final String? phone;

  const RegisterScreen({super.key, this.phone});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    return const EditWidget();
  }
}

//   final TextEditingController _name = TextEditingController();
//   final TextEditingController _number = TextEditingController();
//   final TextEditingController _desc = TextEditingController();
//   late String? imagePath = '';
//   final GlobalKey<FormState> _key = GlobalKey<FormState>();

//   @override
//   void initState() {
//     super.initState();
//     fetchExistingData();
//   }

//   void fetchExistingData() async {
//     SearchNumberResult? searched =
//         await SearchNumber().getData(number: _number.text);
//     if (searched?.userFound != null && searched?.userData != null) {
//       if (searched?.userFound == true) {
//         Map<String, dynamic> searchMap =
//             searched?.userData as Map<String, dynamic>;
//         log(searchMap.toString());

//         _desc.text = searchMap["about"];
//         _name.text = searchMap["name"];
//         _number.text = searchMap["number"];
//         imagePath = searchMap["photo"];
//       }
//     } else {
//       _desc.text = '';
//       _number.text = _number.text;
//       _name.text = '';
//       imagePath = '';
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     _number.text = widget.phone ?? '';
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Register'),
//         elevation: 0.4,
//         backgroundColor: Colors.green.shade500,
//         actions: [
//           GestureDetector(
//             onTap: () async {
//               if (_key.currentState?.validate() ?? false) {
//                 StoreUserData()
//                     .storeUserData(
//                   bio: _desc.text,
//                   name: _name.text,
//                   number: _number.text,
//                   imagePath: imagePath.toString(),
//                 )
//                     .then((value) {
//                   log(value);

//                   displaySnackBar(color: Colors.green, content: value);
//                 });
//               }
//             },
//             child: Align(
//               child: Text(
//                 'Done',
//                 style: doneStyle,
//                 textAlign: TextAlign.center,
//               ),
//             ),
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: smallPadding,
//           child: Form(
//             key: _key,
//             child: Column(
//               children: [
//                 GestureDetector(
//                   onTap: () async {
//                     var result = await pickFile();

//                     log(result?.files.first.toString() ?? '');
//                     if (result != null) {
//                       setState(() {
//                         imagePath = result.files.first.path ?? '';
//                       });
//                     }
//                   },
//                   child: CircleAvatar(
//                     maxRadius: 50,
//                     backgroundColor: Colors.green.shade50,
//                     child: (imagePath != null)
//                         ? ClipOval(
//                             child: Image.file(
//                               File(imagePath ?? ''),
//                               width: 100,
//                               height: 100,
//                               fit: BoxFit.cover,
//                             ),
//                           )
//                         : Icon(
//                             Icons.person,
//                             size: 70,
//                             color: Colors.grey.shade700,
//                           ),
//                   ),
//                 ),
//                 TextFieldRegister(
//                   controller: _name,
//                   hintText: 'Enter your Name',
//                   title: 'Name',
//                   type: TextInputType.name,
//                   error: (value) {
//                     if (value?.isEmpty ?? false) {
//                       return 'Required Field';
//                     }
//                     return null;
//                   },
//                 ),
//                 TextFieldRegister(
//                   controller: _number,
//                   maxLength: 10,
//                   hintText: 'Enter your number',
//                   title: 'Phone Number',
//                   readOnly: true,
//                   type: TextInputType.phone,
//                   error: (value) {
//                     if (value?.isEmpty ?? false) {
//                       return 'Required Field';
//                     }
//                     if ((value?.length)! < 10) {
//                       return 'Please enter a 10 digit number';
//                     }

//                     return null;
//                   },
//                 ),
//                 TextFieldRegister(
//                   controller: _desc,
//                   hintText: 'Write a bio',
//                   title: 'About',
//                   type: TextInputType.text,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
