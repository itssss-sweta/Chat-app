import 'package:chat_app/core/constants/edgeinset.dart';
import 'package:flutter/material.dart';

class OtpContainer extends StatelessWidget {
  final TextEditingController? controller;
  const OtpContainer({super.key, this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 40,
      padding: allsamePadding,
      margin: allsamePadding,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          width: 1,
          color: Colors.black,
        ),
      ),
      child: TextField(
        maxLength: 1,
        controller: controller,
        // style: TextStyle(),

        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
          counterText: '',
          hintText: '*',
        ),
      ),
    );
  }
}
