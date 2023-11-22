import 'package:flutter/material.dart';

class NavBarContainer extends StatelessWidget {
  final IconData? icon;
  final VoidCallback? onTap;
  const NavBarContainer({super.key, required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onTap != null) {
          onTap!();
        }
        // log('message');
      },
      child: Container(
        padding: const EdgeInsets.only(left: 20, right: 20),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        decoration: const BoxDecoration(
          border: Border(
            right: BorderSide(
              color: Colors.white,
            ),
          ),
        ),
        child: Icon(
          icon,
          color: Colors.white,
        ),
      ),
    );
  }
}
