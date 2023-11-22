import 'dart:async';
import 'dart:developer';
import 'package:chat_app/config/routes/route.dart';
import 'package:chat_app/core/constants/key.dart';
import 'package:chat_app/core/utils/snackbar.dart';
import 'package:chat_app/features/authentication/presentation/bloc/cubit/otp_cubit_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../presentation/ui/otp.dart';

class Authenticate {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late PhoneAuthCredential credential;
  String _verificationId = '';
  int? _resendToken;
  Future<void> sendOtp(BuildContext context,
      {String? phone, String? code}) async {
    var completer = Completer<bool>();
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phone,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (credential) async {
          _auth
              .signInWithCredential(credential)
              .then((UserCredential userCredential) {
            navigatorKey.currentState?.pushNamed(Routes.homeScreen,
                arguments: [false, false, '', '']);
          }).catchError((e) {
            throw (e);
          });
          completer.complete(true);
        },
        verificationFailed: (FirebaseAuthException authException) {
          displaySnackBar(context,
              content: (authException.message)?.split('.').first,
              color: Colors.red);
          log(authException.message ?? '');
        },
        codeSent: (String verificationId, [int? resentToken]) {
          log('hello0');
          _verificationId = verificationId;
          _resendToken = resentToken;
          // dialogDisplay(context, credential, verificationId);
          navigatorKey.currentState?.push(MaterialPageRoute(
            builder: (context) => FutureBuilder(
              future: null,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                //     return OtpScreen(
                //       verificationId: _verificationId,
                //       resentToken: _resendToken,
                //       phone: phone,
                //     );
                //   },
                // ),
                return BlocBuilder<OtpCubitCubit, OtpCubitState>(
                  builder: (context, state) {
                    if (state is OtpLoadingState) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return OtpScreen(
                      verificationId: _verificationId,
                      resentToken: _resendToken,
                      phone: phone,
                    );
                  },
                );
              },
            ),
          ));
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          verificationId = _verificationId;
        },
        forceResendingToken: _resendToken,
      );
      log(_verificationId);
    } catch (e) {
      log('Swetaaaaa');
    }
  }
}

class OtpVerfication {
  late PhoneAuthCredential credential;

  void verification(BuildContext context,
      {String? code, String? verificationId}) {
    final smsCode = code;

    if (smsCode?.isEmpty ?? false) {
      log('smsCode is empty');
    }
    if (smsCode?.isNotEmpty ?? false) {
      log(smsCode ?? '');
    }

    credential = PhoneAuthProvider.credential(
        verificationId: verificationId ?? '', smsCode: smsCode ?? '');
    log(credential.toString());
    log(verificationId ?? '');
    log(smsCode ?? '');
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      auth
          .signInWithCredential(credential)
          .then((UserCredential userCredential) {
        navigatorKey.currentState?.pushNamedAndRemoveUntil(
          Routes.homeScreen,
          arguments: [false, false, '', ''],
          (route) => false,
        );
      }).catchError((e) {
        if (e is FirebaseAuthException) {
          displaySnackBar(context, content: e.message, color: Colors.red);
          // Navigator.of(context).pop();
          log(e.message ?? '');
        } else {
          log(e);
        }
      });
    } catch (e) {
      log(e.toString());
    }
  }
}
