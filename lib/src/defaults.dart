import 'package:flutter/material.dart';
import 'package:ln_alerts/ln_alerts.dart';

class LnAlertDecoration {
  final IconData? icon;
  final Color lightAccentColor;
  final Color lightForegroundColor;
  final Color darkAccentColor;
  final Color darkForegroundColor;

  const LnAlertDecoration({
    this.icon,
    required this.lightAccentColor,
    required this.lightForegroundColor,
    required this.darkAccentColor,
    required this.darkForegroundColor,
  });
}

sealed class LnAlertDefaults {
  LnAlertDefaults._();

  static const AlertPosition position = AlertPosition.bottom;

  static const bool colorFilled = true;

  static const Duration duration = Duration(seconds: 10);

  static const decorations = <AlertType, LnAlertDecoration>{
    AlertType.info: LnAlertDecoration(
      icon: Icons.info_outline_rounded,
      lightAccentColor: Color(0xFF6C6C6C),
      lightForegroundColor: Color(0xFFEBEBEB),
      darkAccentColor: Color(0xFFA0A0A0),
      darkForegroundColor: Color(0xFF101010),
    ),
    AlertType.success: LnAlertDecoration(
      icon: Icons.check_circle_outline_rounded,
      lightAccentColor: Color(0xFF188443),
      lightForegroundColor: Color(0xFFA9F0C6),
      darkAccentColor: Color(0xFF7AE7A5),
      darkForegroundColor: Color(0xff10592D),
    ),
    AlertType.warning: LnAlertDecoration(
      icon: Icons.error_outline_rounded,
      lightAccentColor: Color(0xFF8B5502),
      lightForegroundColor: Color(0xFFFED38A),
      darkAccentColor: Color(0xFFFFF5E2),
      darkForegroundColor: Color(0xFFEC9D00),
    ),
    AlertType.error: LnAlertDecoration(
      icon: Icons.error_outline_rounded,
      lightAccentColor: Color(0xff90130E),
      lightForegroundColor: Color(0xFFF5A7A3),
      darkAccentColor: Color(0xfffdf3f5),
      darkForegroundColor: Color(0xffb1384e),
    ),
  };
}
