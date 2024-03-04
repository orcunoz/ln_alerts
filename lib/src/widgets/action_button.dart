import 'dart:ui';
import 'dart:math' as math;

import 'package:flutter/material.dart';

class LnAlertActionButton extends StatelessWidget {
  const LnAlertActionButton({
    IconData? icon,
    String? text,
    required void Function() onPressed,
  }) : this._(
          icon: icon,
          text: text,
          style: null,
          onPressed: onPressed,
          removeButton: false,
        );

  const LnAlertActionButton.remove({
    String? text,
  }) : this._(
          icon: Icons.close_rounded,
          text: text,
          style: null,
          onPressed: null,
          removeButton: true,
        );

  const LnAlertActionButton._({
    required this.icon,
    required this.text,
    required this.onPressed,
    required this.style,
    required this.removeButton,
  }) : assert(icon != null || text != null);

  final IconData? icon;
  final String? text;
  final ButtonStyle? style;
  final VoidCallback? onPressed;

  final bool removeButton;

  LnAlertActionButton copyWith({
    IconData? icon,
    String? text,
    VoidCallback? onPressed,
    ButtonStyle? style,
  }) =>
      LnAlertActionButton._(
        icon: icon ?? this.icon,
        text: text ?? this.text,
        style: style ?? this.style,
        onPressed: onPressed ?? this.onPressed,
        removeButton: removeButton,
      );

  Widget _buildChild(BuildContext context) {
    final icon = this.icon == null ? null : Icon(this.icon!);
    final text = this.text == null ? null : Text(this.text!);
    if (icon != null && text != null) {
      final double scale = MediaQuery.textScalerOf(context).scale(1);
      final double gap =
          scale <= 1 ? 8 : lerpDouble(8, 4, math.min(scale - 1, 1))!;
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[icon, SizedBox(width: gap), Flexible(child: text)],
      );
    } else if (icon != null) {
      return icon;
    } else {
      return text!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: style,
      onPressed: onPressed,
      child: _buildChild(context),
    );
  }
}
