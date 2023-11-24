import 'dart:developer';

import 'package:chat_app/core/constants/key.dart';
import 'package:chat_app/features/homepage/presentation/cubit/cubit/homepage_cubit_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void displayDialogBox(BuildContext context) {
  String countryCode = '+977';

  TextEditingController? controller = TextEditingController();
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.white.withOpacity(0.9),
        title: const Text(
          'Phone Number',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        content: TextField(
          maxLength: 10,
          maxLines: 1,
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            counterText: '',
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              borderSide: BorderSide(
                color: Colors.black26,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              borderSide: BorderSide(
                color: Colors.black26,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              borderSide: BorderSide(
                color: Colors.black26,
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              //fix this on cubit--> fixed
              log('$countryCode${controller.text}');
              String num = countryCode + controller.text;
              context.read<HomepageCubitCubit>().searchNumber(number: num);

              // var isUserFound =
              //     await SearchNumber().getData(number: controller.text);
              // log(isUserFound.toString());
            },
            child: const Text(
              'Ok',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
          TextButton(
              onPressed: () {
                navigatorKey.currentState?.pop();
              },
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.black,
                ),
              )),
        ],
      );
    },
  );
}
