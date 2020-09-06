import 'package:flutter/material.dart';
import 'package:smart_trading_advisor/screens/home.dart';
import 'package:smart_trading_advisor/screens/login.dart';
import 'package:smart_trading_advisor/screens/signup.dart';
import 'package:smart_trading_advisor/screens/startup.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Trading Advisor',
      theme: ThemeData(primaryColor: Colors.blue),
      home: HomePage(),
      routes: {
        SignupScreen.routeName: (ctx) => SignupScreen(),
        LoginScreen.routeName: (ctx) => LoginScreen(),
        HomePage.routeName: (ctx) => HomePage(),
        Start.routeName: (ctx) => Start(),
      },
    );
  }
}
