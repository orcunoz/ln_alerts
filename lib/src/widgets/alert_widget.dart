import 'package:flutter/material.dart';

import '../alert.dart';
import '../localizations/alerts_localizations.dart';
import '../models/alert_types.dart';
import '../style/alert_decoration.dart';

abstract class AlertConfig {
  final Duration? duration;

  const AlertConfig({this.duration});
}

abstract class LnAlertWidget extends StatelessWidget {
  final LnAlert alert;
  final LnAlertDecoration? decoration;

  const LnAlertWidget({
    super.key,
    required this.alert,
    this.decoration,
  });

  String get effectiveMessage =>
      alert.message ??
      switch (alert.type) {
        AlertTypes.info => LnAlertsLocalizations.current.information,
        AlertTypes.success => LnAlertsLocalizations.current.successful,
        AlertTypes.warning => LnAlertsLocalizations.current.warning,
        AlertTypes.error => LnAlertsLocalizations.current.somethingWentWrong,
        _ => "-"
      };
}
