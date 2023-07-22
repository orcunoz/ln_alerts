// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:ln_alerts/ln_alerts.dart';

import 'alert_colors.dart';

const Map<(Brightness, AlertTypes), LnAlertTypeTheme> defaultThemes = {
  (Brightness.light, AlertTypes.info): LnAlertTypeTheme.infoLight(),
  (Brightness.dark, AlertTypes.info): LnAlertTypeTheme.infoDark(),
  (Brightness.light, AlertTypes.success): LnAlertTypeTheme.successLight(),
  (Brightness.dark, AlertTypes.success): LnAlertTypeTheme.successDark(),
  (Brightness.light, AlertTypes.warning): LnAlertTypeTheme.warningLight(),
  (Brightness.dark, AlertTypes.warning): LnAlertTypeTheme.warningDark(),
  (Brightness.light, AlertTypes.error): LnAlertTypeTheme.errorLight(),
  (Brightness.dark, AlertTypes.error): LnAlertTypeTheme.errorDark(),
  (Brightness.light, AlertTypes.custom): LnAlertTypeTheme.infoLight(),
  (Brightness.dark, AlertTypes.custom): LnAlertTypeTheme.infoDark(),
};

class LnAlertTypeTheme {
  final IconData? icon;
  final LnAlertColors colors;
  final Color scrimColor;
  final bool colorFilled;

  const LnAlertTypeTheme({
    this.icon,
    required this.colors,
    required this.scrimColor,
    this.colorFilled = true,
  });

  const LnAlertTypeTheme.infoLight({
    this.icon = Icons.info_outline_rounded,
    this.colors = const LnAlertColors.infoLight(),
    this.scrimColor = const Color(0x10000000),
    this.colorFilled = true,
  });

  const LnAlertTypeTheme.infoDark({
    this.icon = Icons.info_outline_rounded,
    this.colors = const LnAlertColors.infoDark(),
    this.scrimColor = const Color(0x10FFFFFF),
    this.colorFilled = true,
  });

  const LnAlertTypeTheme.successLight({
    this.icon = Icons.check_circle_outline_rounded,
    this.colors = const LnAlertColors.successLight(),
    this.scrimColor = const Color(0x10000000),
    this.colorFilled = true,
  });

  const LnAlertTypeTheme.successDark({
    this.icon = Icons.check_circle_outline_rounded,
    this.colors = const LnAlertColors.successDark(),
    this.scrimColor = const Color(0x10FFFFFF),
    this.colorFilled = true,
  });

  const LnAlertTypeTheme.warningLight({
    this.icon = Icons.error_outline_rounded,
    this.colors = const LnAlertColors.warningLight(),
    this.scrimColor = const Color(0x10000000),
    this.colorFilled = true,
  });

  const LnAlertTypeTheme.warningDark({
    this.icon = Icons.error_outline_rounded,
    this.colors = const LnAlertColors.warningDark(),
    this.scrimColor = const Color(0x10FFFFFF),
    this.colorFilled = true,
  });

  const LnAlertTypeTheme.errorLight({
    this.icon = Icons.error_outline_rounded,
    this.colors = const LnAlertColors.errorLight(),
    this.scrimColor = const Color(0x10000000),
    this.colorFilled = true,
  });

  const LnAlertTypeTheme.errorDark({
    this.icon = Icons.error_outline_rounded,
    this.colors = const LnAlertColors.errorDark(),
    this.scrimColor = const Color(0x10FFFFFF),
    this.colorFilled = true,
  });

  factory LnAlertTypeTheme.byType(AlertTypes type) => defaultThemes[type]!;

  LnAlertTypeTheme copyWith({
    IconData? icon,
    LnAlertColors? colors,
    Color? scrimColor,
    bool? colorFilled,
  }) {
    return LnAlertTypeTheme(
      icon: icon ?? this.icon,
      colors: colors ?? this.colors,
      scrimColor: scrimColor ?? this.scrimColor,
      colorFilled: colorFilled ?? this.colorFilled,
    );
  }
}
