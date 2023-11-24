import 'dart:developer';

import 'package:chat_app/config/routes/route.dart';
import 'package:chat_app/core/constants/key.dart';
import 'package:chat_app/core/utils/snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Future<void> dialogDisplay(BuildContext context, PhoneAuthCredential credential,
    String verificationId) {
  final TextEditingController codeController = TextEditingController();
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
            title: const Text("Enter SMS Code"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  controller: codeController,
                ),
              ],
            ),
            actions: <Widget>[
              ElevatedButton(
                // textColor: Colors.white,
                // color: Colors.redAccent,
                onPressed: () {
                  FirebaseAuth auth = FirebaseAuth.instance;

                  final smsCode = codeController.text.trim();

                  credential = PhoneAuthProvider.credential(
                      verificationId: verificationId, smsCode: smsCode);
                  auth
                      .signInWithCredential(credential)
                      .then((UserCredential userCredential) {
                    navigatorKey.currentState
                        ?.pushReplacementNamed(Routes.otpScreen);
                  }).catchError((e) {
                    if (e is FirebaseAuthException) {
                      displaySnackBar(content: e.message);
                      navigatorKey.currentState?.pop();
                      log(e.message ?? '');
                    }
                    log(e);
                  });
                },
                child: const Text("Done"),
              )
            ],
          ));
}
