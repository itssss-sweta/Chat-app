import 'package:chat_app/core/utils/edit.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  final String? phone;

  const RegisterScreen({super.key, this.phone});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // final TextEditingController _name = TextEditingController();
  // final TextEditingController _number = TextEditingController();
  // final TextEditingController _desc = TextEditingController();
  // late File imagePath = File('');
  // final GlobalKey<FormState> _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // _number.text = widget.phone ?? '';
    return const EditWidget(
      title: 'Register',
    );
  }
}
