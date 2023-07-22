import 'package:flutter/material.dart';

import '../models/alert_types.dart';
import 'alert_type_theme.dart';

class LnAlertsTheme {
  final LnAlertTypeTheme infoTheme;
  final LnAlertTypeTheme successTheme;
  final LnAlertTypeTheme warningTheme;
  final LnAlertTypeTheme errorTheme;

  const LnAlertsTheme({
    required this.infoTheme,
    required this.successTheme,
    required this.warningTheme,
    required this.errorTheme,
  });

  factory LnAlertsTheme.defaults(Brightness brightness) =>
      brightness == Brightness.light
          ? LnAlertsTheme.defaultsLight()
          : LnAlertsTheme.defaultsDark();

  const LnAlertsTheme.defaultsLight({
    this.infoTheme = const LnAlertTypeTheme.infoLight(),
    this.successTheme = const LnAlertTypeTheme.successLight(),
    this.warningTheme = const LnAlertTypeTheme.warningLight(),
    this.errorTheme = const LnAlertTypeTheme.errorLight(),
  });

  const LnAlertsTheme.defaultsDark({
    this.infoTheme = const LnAlertTypeTheme.infoDark(),
    this.successTheme = const LnAlertTypeTheme.successDark(),
    this.warningTheme = const LnAlertTypeTheme.warningDark(),
    this.errorTheme = const LnAlertTypeTheme.errorDark(),
  });

  LnAlertTypeTheme themeFor(AlertTypes type) => switch (type) {
        AlertTypes.info => infoTheme,
        AlertTypes.success => successTheme,
        AlertTypes.warning => warningTheme,
        AlertTypes.error => errorTheme,
        AlertTypes.custom => infoTheme,
      };

  LnAlertsTheme copyWith({
    LnAlertTypeTheme? infoTheme,
    LnAlertTypeTheme? successTheme,
    LnAlertTypeTheme? warningTheme,
    LnAlertTypeTheme? errorTheme,
  }) {
    return LnAlertsTheme(
      infoTheme: infoTheme ?? this.infoTheme,
      successTheme: successTheme ?? this.successTheme,
      warningTheme: warningTheme ?? this.warningTheme,
      errorTheme: errorTheme ?? this.errorTheme,
    );
  }
}
