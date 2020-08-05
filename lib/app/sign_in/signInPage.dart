import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:time_ticker/app/sign_in/emailSignInPage.dart';
import 'package:time_ticker/app/sign_in/signInButton.dart';
import 'package:time_ticker/app/sign_in/socialSignInButton.dart';
import 'package:time_ticker/services/auth.dart';
import 'package:time_ticker/widgets/platformAlertDialog.dart';
import 'package:time_ticker/widgets/platformExceptionAlertDialog.dart';

class SignInPage extends StatelessWidget {
  Future<void> _signInAnonymously(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signInAnonymously();
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(
        title: "Anonymous Sign in failed",
        exception: e,
      ).show(context);
    }
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signInWithGoogle();
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(
        title: "Google Sign in failed",
        exception: e,
      ).show(context);
    }
  }

  void _signInWithEmail(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (context) => EmailSignInPage(),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            "Sign in",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 32.0,
            ),
          ),
          SizedBox(height: 48.0),
          SocialSignInButton(
            text: "Sign in With Google",
            image: "images/google-logo.png",
            color: Colors.white,
            textColor: Colors.black87,
            onPressed: () => _signInWithGoogle(context),
          ),
          SizedBox(height: 8.0),
          SocialSignInButton(
            text: "Sign in with Facebook",
            image: "images/facebook-logo.png",
            color: Color(0xFF334D92),
            textColor: Colors.white,
            onPressed: () {},
          ),
          SizedBox(height: 8.0),
          SignInButton(
            text: "Sign in with Email",
            textColor: Colors.white,
            color: Colors.teal[700],
            onPressed: () => _signInWithEmail(context),
          ),
          SizedBox(height: 8.0),
          Text(
            "or",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14.0, color: Colors.black87),
          ),
          SizedBox(height: 8.0),
          SignInButton(
            text: "Go anonymous",
            color: Colors.lime[300],
            onPressed: () => _signInAnonymously(context),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text("Time Tracker"),
      ),
      body: _buildContent(context),
    );
  }
}
