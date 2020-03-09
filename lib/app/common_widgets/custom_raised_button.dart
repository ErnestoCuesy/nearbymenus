import 'dart:ffi';

import 'package:flutter/material.dart';

class CustomRaisedButton extends StatelessWidget {
  CustomRaisedButton({
    this.context,
    this.child,
    this.textColor,
    this.color,
    this.borderRadius : 6.0,
    this.height : 50.0,
    this.onPressed,
  }) : assert(borderRadius != null);

  final BuildContext context;
  final Widget child;
  final Color textColor;
  final Color color;
  final double borderRadius;
  final double height;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: RaisedButton(
        child: child,
        textColor: textColor,
        color: color,
        disabledColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(
              borderRadius,
            ),
          ),
        ),
        onPressed: onPressed,
      ),
    );
  }
}
