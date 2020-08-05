import 'package:time_ticker/widgets/platformAlertDialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PlatformExceptionAlertDialog extends PlatformAlertDialog {
  PlatformExceptionAlertDialog({
    @required String title,
    @required PlatformException exception,
  }) : super(
    title: title,
    content: _message(exception),
    defaultActionText: "OK",
  );

  static String _message(PlatformException exception) {
    return _errors[exception.code] ?? exception.message;
  }

  static Map<String, String> _errors = {
    "ERROR_WEAK_PASSWORD": "Your password is too weak.",
    "ERROR_INVALID_EMAIL": "Your email is invalid.",
    "ERROR_EMAIL_ALREADY_IN_USE": "Your email is already in use.",
    "ERROR_WRONG_PASSWORD": "Password or Username is incorrect.",
    "ERROR_USER_NOT_FOUND": "Your email is not registered.",
    "ERROR_USER_DISABLED": "Your account is blocked.",
    "ERROR_TOO_MANY_REQUESTS": "Your account has been blocked. - Too many attempts",
    "ERROR_OPERATION_NOT_ALLOWED": "Wrong Sign in method, please contact developer."
  };
}


