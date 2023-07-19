import 'package:flutter/material.dart';

import 'models/alert_position.dart';
import 'models/alert_type.dart';

class LnAlertDecoration {
  final IconData? icon;
  final Color lightAccentColor;
  final Color lightSecondaryColor;
  final Color darkAccentColor;
  final Color darkSecondaryColor;

  const LnAlertDecoration({
    this.icon,
    required this.lightAccentColor,
    required this.lightSecondaryColor,
    required this.darkAccentColor,
    required this.darkSecondaryColor,
  });
}

sealed class LnAlertDefaults {
  LnAlertDefaults._();

  static const AlertPosition position = AlertPosition.bottom;

  static const bool colorFilled = true;

  static const Duration duration = Duration(seconds: 5);

  static const double rectangularAlertMinWidth = 180;

  static const double notificationAlertMaxWidth = 400;

  static const lightScrimColor = Color(0x10000000);

  static const darkScrimColor = Color(0x10FFFFFF);

  static const decorations = <AlertType, LnAlertDecoration>{
    AlertType.info: LnAlertDecoration(
      icon: Icons.info_outline_rounded,
      lightAccentColor: Color(0xFFEBEBEB),
      lightSecondaryColor: Color(0xFF6C6C6C),
      darkAccentColor: Color(0xFF383838),
      darkSecondaryColor: Color(0xFFEBEBEB),
    ),
    AlertType.success: LnAlertDecoration(
      icon: Icons.check_circle_outline_rounded,
      lightAccentColor: Color(0xFFA8F1C6),
      lightSecondaryColor: Color(0xFF198343),
      darkAccentColor: Color(0xFF198343),
      darkSecondaryColor: Color(0xFFA8F1C6),
    ),
    AlertType.warning: LnAlertDecoration(
      icon: Icons.error_outline_rounded,
      lightAccentColor: Color(0xFFFFD38A),
      lightSecondaryColor: Color(0xFF8B5502),
      darkAccentColor: Color(0xFFFEA840),
      darkSecondaryColor: Colors.white,
    ),
    AlertType.error: LnAlertDecoration(
      icon: Icons.error_outline_rounded,
      lightAccentColor: Color(0xffF6A7A3),
      lightSecondaryColor: Color(0xff90110E),
      darkAccentColor: Color(0xff942F41),
      darkSecondaryColor: Color(0xffF6A7A3),
    ),
  };
}
