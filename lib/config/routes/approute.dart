import 'package:chat_app/config/routes/route.dart';
import 'package:chat_app/features/authentication/presentation/ui/login.dart';
import 'package:chat_app/features/authentication/presentation/ui/otp.dart';
import 'package:chat_app/features/authentication/presentation/ui/register.dart';
import 'package:chat_app/features/chatpage/presentation/ui/chatpage.dart';
import 'package:chat_app/features/homepage/presentation/ui/homepage.dart';
import 'package:flutter/material.dart';

class AppRoute {
  Route? ongenerateRoute(RouteSettings settings) {
    //to pass as a query with the url
    final argument = settings.arguments;

    switch (settings.name) {
      case Routes.chatScreen:
        {
          return MaterialPageRoute(
            builder: (context) => ChatPage(title: argument as String),
          );
        }
      case Routes.homeScreen:
        {
          return MaterialPageRoute(
            builder: (context) => HomePage(
              arg: argument as List,
            ),
          );
        }

      //path conflict
      case Routes.homeScreen2:
        {
          return MaterialPageRoute(
            builder: (context) => HomePage(
              arg: argument as List,
            ),
          );
        }
      case Routes.loginScreen:
        {
          return MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          );
        }

      case Routes.otpScreen:
        {
          return MaterialPageRoute(
            builder: (context) => const OtpScreen(),
          );
        }
      case Routes.registerScreen:
        {
          return MaterialPageRoute(
            builder: (context) => RegisterScreen(phone: argument as String),
          );
        }
      default:
        {
          return MaterialPageRoute(
            builder: (context) => HomePage(
              arg: argument as List,
            ),
          );
        }
    }
  }
}
