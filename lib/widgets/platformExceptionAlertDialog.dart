import 'package:time_ticker/widgets/platformAlertDialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PlatformExceptionAlertDialog extends PlatformAlertDialog {
  PlatformExceptionAlertDialog({
    @required String title,
    @required PlatformException exception,
  }) : super(
    title: title,
    content: exception.message,
    defaultActionText: "OK",
  );
}
