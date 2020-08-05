import 'package:flutter/material.dart';

class CustomRaisedButton extends StatelessWidget {
  CustomRaisedButton({
    @required this.child,
    this.color = Colors.white,
    this.borderRadius = 4.0,
    this.height = 50.0,
    this.onPressed,
  })  : assert(borderRadius != null),
        assert(height != null);

  final Widget child;
  final Color color;
  final double borderRadius;
  final double height;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: this.height,
      child: RaisedButton(
        child: this.child,
        color: this.color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        onPressed: this.onPressed,
      ),
    );
  }
}
