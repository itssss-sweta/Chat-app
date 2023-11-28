import 'package:chat_app/core/utils/edit.dart';
import 'package:chat_app/features/authentication/presentation/bloc/cubit/otp_cubit_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    String? number = context.read<OtpCubitCubit>().number;
    return EditWidget(
      title: 'Register',
      phone: number,
    );
  }
}
