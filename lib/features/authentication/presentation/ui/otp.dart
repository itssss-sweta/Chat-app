import 'dart:async';
import 'dart:developer';
import 'package:chat_app/core/constants/colors.dart';
import 'package:chat_app/core/constants/edgeinset.dart';
import 'package:chat_app/core/constants/textstyle.dart';
import 'package:chat_app/features/authentication/domain/repository/authenticate.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class OtpScreen extends StatefulWidget {
  final String? verificationId;
  final int? resentToken;
  final String? phone;
  const OtpScreen(
      {super.key, this.verificationId, this.resentToken, this.phone});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  Timer? _resendTimer;
  int _resendTimeout = 60;
  String currentText = '';
  TextEditingController codeController = TextEditingController();
  final defaultPinTheme = PinTheme(
    width: 56,
    height: 56,
    textStyle: TextStyle(
      fontSize: 22,
      color: textColor,
    ),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(5),
      border: Border.all(color: borderColor),
    ),
  );
  FocusNode otpFocusNode = FocusNode();

  //TODO: keyboard focus not supported when reset timer on
  void _resendOtp() {
    _resendTimer?.cancel();
    Authenticate().sendOtp(
      context,
      phone: widget.phone,
    );
    _startResendTimer();
  }

  void _startResendTimer() {
    setState(() {
      _resendTimeout = 60;
    });

    Future.delayed(const Duration(milliseconds: 100), () {
      otpFocusNode.requestFocus();
    });

    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendTimeout > 0) {
        setState(() {
          _resendTimeout--;
        });
      } else {
        _resendTimer?.cancel();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  @override
  void dispose() {
    _resendTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Align(
          child: Text(
            'Verify OTP',
            style: headStyle,
            textAlign: TextAlign.center,
          ),
        ),
        backgroundColor: bgColor,
        elevation: 0,
        actions: <Widget>[
          GestureDetector(
            onTap: () {
              log('hijo');
              OtpVerfication().verification(
                context,
                code: codeController.text,
                verificationId: widget.verificationId,
              );
              codeController.clear();
            },
            child: Align(
              child: Text(
                "Done",
                style: doneStyle,
                textAlign: TextAlign.center,
              ),
            ),
          )
        ],
      ),
      body: FocusScope(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Form(
              key: GlobalKey<FormState>(),
              child: Container(
                padding: allsamePadding,
                margin: allsamePadding,
                width: MediaQuery.sizeOf(context).width,
                child: Pinput(
                  controller: codeController,
                  keyboardType: TextInputType.number,
                  listenForMultipleSmsOnAndroid: true,
                  defaultPinTheme: defaultPinTheme,
                  length: 6,
                  onCompleted: (pin) {
                    log('onCompleted: $pin');
                    // codeController.clear();
                  },
                  onChanged: (value) {
                    log('onChanged: $value');
                  },
                  focusedPinTheme: defaultPinTheme.copyWith(
                    decoration: defaultPinTheme.decoration!.copyWith(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: focusedBorderColor),
                    ),
                  ),
                  submittedPinTheme: defaultPinTheme.copyWith(
                    decoration: defaultPinTheme.decoration!.copyWith(
                      color: fillColor,
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: focusedBorderColor),
                    ),
                  ),
                  errorPinTheme: defaultPinTheme.copyBorderWith(
                    border: Border.all(color: errorColor),
                  ),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                if (!(_resendTimeout > 0)) {
                  _resendOtp();
                  _startResendTimer();
                }
              },
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: 'Didn\'t receive a code?',
                  style: headSmallStyle,
                  children: [
                    _resendTimeout > 0
                        ? TextSpan(
                            text: ' Resend in $_resendTimeout seconds',
                            style: headdisableStyle,
                            // recognizer:
                          )
                        : TextSpan(text: 'Resend', style: headStyle),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
