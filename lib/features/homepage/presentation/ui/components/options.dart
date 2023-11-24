import 'package:flutter/material.dart';

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
