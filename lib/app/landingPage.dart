import 'package:flutter/material.dart';
import 'package:time_ticker/app/homePage.dart';
import 'package:time_ticker/app/sign_in/signInPage.dart';
import 'package:time_ticker/services/auth.dart';
import 'package:time_ticker/services/authProvider/authProvider.dart';

class LandingPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final auth = AuthProvider.of(context);
    return StreamBuilder<User>(
      stream: auth.onAuthStateChanged,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          User user = snapshot.data;
          if (user == null) {
            return SignInPage();
          }
          return HomePage();
        } else {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );

  }
}
