import 'dart:developer';

import 'package:chat_app/core/utils/snackbar.dart';
import 'package:chat_app/features/authentication/presentation/ui/otp.dart';
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
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const OtpScreen()));
                  }).catchError((e) {
                    if (e is FirebaseAuthException) {
                      displaySnackBar(context, content: e.message);
                      Navigator.of(context).pop();
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
