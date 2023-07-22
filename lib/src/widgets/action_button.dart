import 'package:flutter/material.dart';

class LnAlertActionButton extends StatelessWidget {
  final IconData? icon;
  final String? text;
  final void Function()? onPressed;

  const LnAlertActionButton({this.icon, this.text, this.onPressed})
      : assert(icon != null || text != null);

  @override
  Widget build(BuildContext context) {
    if (icon != null && text != null) {
      return TextButton.icon(
        onPressed: onPressed,
        icon: Icon(icon!),
        label: Text(text!),
      );
    } else if (icon != null) {
      return IconButton(
        onPressed: onPressed,
        icon: Icon(icon),
      );
    } else {
      return TextButton(
        child: Text(text!),
        onPressed: onPressed,
      );
    }
  }
}
