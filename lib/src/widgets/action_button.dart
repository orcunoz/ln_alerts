import 'package:flutter/material.dart';

class LnAlertActionButton extends StatelessWidget {
  final IconData? icon;
  final String? text;
  final void Function()? onPressed;
  final ButtonStyle? style;

  final bool removeButton;

  const LnAlertActionButton({
    IconData? icon,
    String? text,
    required void Function() onPressed,
  }) : this._(
          icon: icon,
          text: text,
          onPressed: onPressed,
        );

  const LnAlertActionButton._({
    this.icon,
    this.text,
    this.onPressed,
    this.style,
    this.removeButton = false,
  }) : assert(icon != null || text != null);

  LnAlertActionButton copyWith({
    IconData? icon,
    String? text,
    void Function()? onPressed,
    ButtonStyle? style,
  }) =>
      LnAlertActionButton._(
        icon: icon ?? this.icon,
        text: text ?? this.text,
        onPressed: onPressed ?? this.onPressed,
        style: style ?? this.style,
      );

  @override
  Widget build(BuildContext context) {
    if (icon != null && text != null) {
      return TextButton.icon(
        icon: Icon(icon!),
        label: Text(text!),
        style: style,
        onPressed: onPressed,
      );
    } else if (icon != null) {
      return IconButton(
        icon: Icon(icon),
        style: style,
        onPressed: onPressed,
      );
    } else {
      return TextButton(
        child: Text(text!),
        style: style,
        onPressed: onPressed,
      );
    }
  }
}
