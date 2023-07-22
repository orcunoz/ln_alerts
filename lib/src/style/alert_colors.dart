import 'package:flutter/material.dart';

import '../models/alert_types.dart';

const defaultColors = {
  (Brightness.light, AlertTypes.info): LnAlertColors.infoLight(),
  (Brightness.dark, AlertTypes.info): LnAlertColors.infoDark(),
  (Brightness.light, AlertTypes.success): LnAlertColors.successLight(),
  (Brightness.dark, AlertTypes.success): LnAlertColors.successDark(),
  (Brightness.light, AlertTypes.warning): LnAlertColors.warningLight(),
  (Brightness.dark, AlertTypes.warning): LnAlertColors.warningDark(),
  (Brightness.light, AlertTypes.error): LnAlertColors.errorLight(),
  (Brightness.dark, AlertTypes.error): LnAlertColors.errorDark(),
  (Brightness.light, AlertTypes.custom): LnAlertColors.infoLight(),
  (Brightness.dark, AlertTypes.custom): LnAlertColors.infoDark(),
};

class LnAlertColors {
  final Color accent;
  final Color secondary;

  const LnAlertColors({
    required this.accent,
    required this.secondary,
  });

  factory LnAlertColors.defaultsOf({
    required Brightness brightness,
    required AlertTypes alertType,
  }) =>
      defaultColors[(brightness, alertType)]!;

  const LnAlertColors.infoLight({
    this.accent = const Color(0xFFf3f3f3),
    this.secondary = const Color(0xFF585858),
  });
  const LnAlertColors.infoDark({
    this.accent = const Color(0xFF282828),
    this.secondary = const Color(0xFFEBEBEB),
  });
  const LnAlertColors.successLight({
    this.accent = const Color(0xFFA8F1C6),
    this.secondary = const Color(0xFF198343),
  });
  const LnAlertColors.successDark({
    this.accent = const Color(0xFF198343),
    this.secondary = const Color(0xFFA8F1C6),
  });
  const LnAlertColors.warningLight({
    this.accent = const Color(0xFFFFD38A),
    this.secondary = const Color(0xFF8B5502),
  });
  const LnAlertColors.warningDark({
    this.accent = const Color(0xFFFEA840),
    this.secondary = Colors.white,
  });
  const LnAlertColors.errorLight({
    this.accent = const Color(0xffF6A7A3),
    this.secondary = const Color(0xff90110E),
  });
  const LnAlertColors.errorDark({
    this.accent = const Color(0xff942F41),
    this.secondary = const Color(0xffF6A7A3),
  });

  LnAlertColors copyWith({
    Color? accent,
    Color? secondary,
  }) {
    return LnAlertColors(
      accent: accent ?? this.accent,
      secondary: secondary ?? this.secondary,
    );
  }
}
