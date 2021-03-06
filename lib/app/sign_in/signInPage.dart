import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:time_ticker/app/sign_in/emailSignInPage.dart';
import 'package:time_ticker/app/sign_in/signInManager.dart';
import 'package:time_ticker/app/sign_in/signInButton.dart';
import 'package:time_ticker/app/sign_in/socialSignInButton.dart';
import 'package:time_ticker/services/auth.dart';
import 'package:time_ticker/widgets/platformExceptionAlertDialog.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({Key key, @required this.manager, @required this.isLoading})
      : super(key: key);

  final SignInManager manager;
  final bool isLoading;

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return ChangeNotifierProvider<ValueNotifier<bool>>(
        create: (_) => ValueNotifier<bool>(false),
        child: Consumer<ValueNotifier<bool>>(
          builder: (_, isLoading, __) => Provider<SignInManager>(
            create: (context) => SignInManager(auth: auth, isLoading: isLoading),
            child: Consumer<SignInManager>(
              builder: (context, manager, _) => SignInPage(
                manager: manager,
                isLoading: isLoading.value,
              ),
            ),
          ),
        ));
  }

  void _showSignInError(
      BuildContext context, PlatformException exception, String title) {
    PlatformExceptionAlertDialog(
      title: title,
      exception: exception,
    ).show(context);
  }

  Future<void> _signInAnonymously(BuildContext context) async {
    try {
      await manager.signInAnonymously();
    } on PlatformException catch (e) {
      _showSignInError(context, e, "Anonymous Sign in failed");
    }
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      await manager.signInWithGoogle();
    } on PlatformException catch (e) {
      if (e.code != "ERROR_ABORTED_BY_USER") {
        _showSignInError(context, e, "Google Sign in failed");
      }
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
          SizedBox(
            height: 50.0,
            child: _buildHeader(),
          ),
          SizedBox(height: 48.0),
          SocialSignInButton(
            text: "Sign in With Google",
            image: "images/google-logo.png",
            color: Colors.white,
            textColor: Colors.black87,
            onPressed: isLoading ? null : () => _signInWithGoogle(context),
          ),
          SizedBox(height: 8.0),
          SocialSignInButton(
            text: "Sign in with Facebook",
            image: "images/facebook-logo.png",
            color: Color(0xFF334D92),
            textColor: Colors.white,
            onPressed: isLoading ? null : () {},
          ),
          SizedBox(height: 8.0),
          SignInButton(
            text: "Sign in with Email",
            textColor: Colors.white,
            color: Colors.teal[700],
            onPressed: isLoading ? null : () => _signInWithEmail(context),
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
            onPressed: isLoading ? null : () => _signInAnonymously(context),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return Text(
      "Sign in",
      textAlign: TextAlign.center,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 32.0,
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
//
//class SignInPage extends StatelessWidget {
//
//
//}
