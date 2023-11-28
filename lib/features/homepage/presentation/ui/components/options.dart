import 'package:chat_app/config/routes/route.dart';
import 'package:chat_app/core/constants/key.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MenuWidget extends StatelessWidget {
  final String? number;
  const MenuWidget({super.key, this.number});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (String value) async {
        if (value == '1') {
          navigatorKey.currentState
              ?.pushNamed(Routes.profileScreen, arguments: number);
        }
        if (value == '2') {
          await FirebaseAuth.instance.signOut();
          navigatorKey.currentState?.pushReplacementNamed(Routes.loginScreen);
        }
      },
      position: PopupMenuPosition.under,
      elevation: 0.8,
      itemBuilder: (BuildContext context) => [
        const PopupMenuItem(
          value: '1',
          child: PopUpItemOptions(
            icon: Icons.person,
            text: 'Profile',
          ),
        ),
        const PopupMenuItem(
          value: '2',
          child: PopUpItemOptions(
            icon: Icons.logout_outlined,
            text: 'Logout',
          ),
        ),
      ],
    );
  }
}

class PopUpItemOptions extends StatelessWidget {
  final String? value;
  final String? text;
  final IconData? icon;
  final VoidCallback? onTap;
  const PopUpItemOptions(
      {super.key, this.value, this.text, this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Icon(
          icon,
          color: Colors.black,
        ),
        Text(text ?? ''),
      ],
    );
  }
}
