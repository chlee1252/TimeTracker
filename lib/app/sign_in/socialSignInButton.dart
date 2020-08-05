import 'package:flutter/material.dart';
import 'package:time_ticker/widgets/customRaisedButton.dart';

class SocialSignInButton extends CustomRaisedButton {
  SocialSignInButton({
    @required String text,
    Color color,
    @required String image,
    Color textColor,
    VoidCallback onPressed,
  })  : assert(text != null),
        assert(image != null),
        super(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Image.asset(image),
              Text(
                text,
                style: TextStyle(
                  color: textColor,
                  fontSize: 15.0,
                ),
              ),
              Opacity(
                opacity: 0.0,
                child: Image.asset(image),
              ),
            ],
          ),
          color: color,
          onPressed: onPressed,
        );
}
