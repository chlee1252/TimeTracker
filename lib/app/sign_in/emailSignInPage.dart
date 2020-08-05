import 'package:flutter/material.dart';
import 'package:time_ticker/app/sign_in/emailSignInForm.dart';

class EmailSignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text("Sign In"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            child: _buildContent(),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return EmailSignInForm();
  }
}
