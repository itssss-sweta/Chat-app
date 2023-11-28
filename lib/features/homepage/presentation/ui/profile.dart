import 'package:chat_app/core/utils/edit.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  final String? phone;
  final String? title;
  // final String? desc;

  const ProfileScreen({
    super.key,
    this.phone,
    this.title,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return EditWidget(
      phone: widget.phone,
      title: 'Profile',
    );
  }
}
