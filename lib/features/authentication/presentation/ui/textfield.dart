import 'package:chat_app/core/constants/edgeinset.dart';
import 'package:chat_app/core/constants/textstyle.dart';
import 'package:flutter/material.dart';

class TextFieldRegister extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String title;
  final TextInputType type;
  final String? Function(String?)? error;
  final bool? readOnly;
  final int? maxLength;

  const TextFieldRegister(
      {super.key,
      required this.controller,
      required this.hintText,
      required this.title,
      required this.type,
      this.error,
      this.readOnly,
      this.maxLength});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: headStyle,
        ),
        const SizedBox(
          height: 10,
        ),
        TextFormField(
          validator: error,
          controller: controller,
          style: headSmallStyle,
          keyboardType: type,
          maxLength: maxLength,
          readOnly: readOnly ?? false,
          cursorHeight: BorderSide.strokeAlignCenter,
          decoration: InputDecoration(
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(
                  color: Colors.green,
                )),
            hintText: hintText,
            contentPadding: smallPadding,
            hintStyle: hintStylesmall,
            counterText: '',
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(
                color: Colors.green,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(
                color: Colors.green,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(
                color: Colors.red,
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
