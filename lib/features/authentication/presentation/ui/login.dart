import 'dart:developer';
import 'package:chat_app/features/authentication/presentation/bloc/cubit/otp_cubit_cubit.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:chat_app/core/constants/colors.dart';
import 'package:chat_app/core/constants/edgeinset.dart';
import 'package:chat_app/core/constants/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repository/authenticate.dart';
import '../../../../core/utils/snackbar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phone = TextEditingController();

  String selectedCountryCode = '+977';
  @override
  void dispose() {
    _phone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var loginCubit = context.read<OtpCubitCubit>();
    String number = '';
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        // title: AuthAppBar(phone: _phone.text),
        title: Align(
          child: Text(
            'Phone Number',
            style: headStyle,
            textAlign: TextAlign.center,
          ),
        ),
        backgroundColor: bgColor,
        elevation: 0,
        actions: [
          GestureDetector(
            onTap: () async {
              log('tapped');
              if ((_phone.text).isEmpty) {
                displaySnackBar(
                    content: 'Please enter your number', color: Colors.red);
              } else {
                String phonewithcode = selectedCountryCode + _phone.text;
                loginCubit.setPhoneNumber(phonewithcode);
                number = loginCubit.number ?? '';
                log(loginCubit.number ?? '');
                Authenticate().sendOtp(phone: number, context);
              }
            },
            child: Align(
              child: Text(
                'Done',
                style: doneStyle,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(
                width: MediaQuery.sizeOf(context).width,
                child: Column(
                  children: [
                    Padding(
                      padding: smallallPadding,
                      child: Text(
                        'Please confirm your country code and enter your phone number',
                        style: headSmallStyle,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.symmetric(
                          horizontal: BorderSide(
                            color: borderColor,
                            width: 0.5,
                          ),
                        ),
                      ),
                      child: CountryCodePicker(
                        padding: smallPadding,
                        showFlagDialog: true,
                        showCountryOnly: false,
                        initialSelection: 'NP',
                        favorite: const ['+977', 'NP'],
                        showOnlyCountryWhenClosed: true,
                        showFlag: false,
                        textStyle: countryStyle,
                        onChanged: (CountryCode? countryCode) {
                          setState(() {
                            selectedCountryCode = countryCode?.dialCode ?? '';
                            log(selectedCountryCode);
                          });
                        },
                        builder: (value) {
                          return Column(
                            children: [
                              Padding(
                                padding: smallPadding,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${value?.name}',
                                      style: countryStyle,
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios_outlined,
                                      color: borderColor,
                                    ),
                                  ],
                                ),
                              ),
                              Divider(
                                color: borderColor,
                                thickness: 0.5,
                                // indent: 40,
                              ),
                              Padding(
                                padding: xsmallallPadding,
                                child: IntrinsicHeight(
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Text(
                                          '$value',
                                          style: countrycodeStyle,
                                        ),
                                      ),
                                      VerticalDivider(
                                        color: borderColor,
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: TextField(
                                          controller: _phone,
                                          style: countrycodeStyle,
                                          keyboardType: TextInputType.number,
                                          maxLength: 10,
                                          cursorHeight:
                                              BorderSide.strokeAlignCenter,
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: 'Phone Number',
                                            contentPadding: smalltopPadding,
                                            hintStyle: hintStyle,
                                            counterText: '',
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
