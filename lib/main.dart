import 'package:flutter/material.dart';
import 'package:time_ticker/app/landingPage.dart';
import 'package:time_ticker/services/auth.dart';
import 'package:time_ticker/services/authProvider/authProvider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AuthProvider(
      auth: Auth(),
      child: MaterialApp(
        title: 'Time Tracker',
        theme: ThemeData(
          primarySwatch: Colors.indigo,
        ),
        home: LandingPage(),
      ),
    );
  }
}
