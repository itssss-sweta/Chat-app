import 'dart:developer';
import 'package:chat_app/config/routes/approute.dart';
import 'package:chat_app/core/constants/key.dart';
import 'package:chat_app/features/authentication/presentation/bloc/cubit/otp_cubit_cubit.dart';
import 'package:chat_app/features/authentication/presentation/ui/login.dart';
import 'package:chat_app/features/homepage/data/repository/searchnumber.dart';
import 'package:chat_app/features/homepage/presentation/cubit/cubit/homepage_cubit_cubit.dart';
import 'package:chat_app/features/homepage/presentation/ui/homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      runApp(ChatApp(
        user: user,
      ));
      checkUser();
      log('User is signed out');
    });
  } catch (e) {
    log('Firebase initialization failed:$e');
  }

  // await SharedPreferences.getInstance();
}

void checkUser() async {
  FirebaseAuth auth = FirebaseAuth.instance;
  User? user = auth.currentUser;

  if (user != null) {
    String uid = user.uid;
    String phoneNum = user.phoneNumber ?? 'No email available';
    SearchNumber().getData(number: phoneNum);

    log('User is logged in with UID: $uid and Email: $phoneNum');
  } else {
    log('No user is currently logged in.');
  }
}

class ChatApp extends StatelessWidget {
  final User? user;
  const ChatApp({super.key, this.user});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<OtpCubitCubit>(
          create: (context) => OtpCubitCubit(),
        ),
        BlocProvider<HomepageCubitCubit>(
          create: (context) => HomepageCubitCubit(),
        )
      ],
      child: MaterialApp(
        onGenerateRoute: AppRoute().ongenerateRoute,
        home: user != null
            ? const HomePage(arg: [false, false, '', '', '', ''])
            : const LoginScreen(),
        // home: const ChatPage(title: 'Sweta'),
        navigatorKey: navigatorKey,
      ),
    );
  }
}
