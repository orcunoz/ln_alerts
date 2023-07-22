import 'package:flutter/material.dart';
import 'package:ln_alerts/src/models/alert_types.dart';
import 'package:ln_alerts/src/style/alert_type_theme.dart';
import '../defaults.dart';

class LnAlertDecoration {
  final Color backgroundColor;
  final Color foregroundColor;
  final Color scrimColor;
  final IconData? icon;

  factory LnAlertDecoration.generate({
    required BuildContext context,
    required AlertTypes alertType,
  }) {
    final theme = Theme.of(context);
    final typeTheme = (theme.brightness == Brightness.light
                ? LnAlerts.maybeOf(context)?.lightTheme
                : LnAlerts.maybeOf(context)?.darkTheme)
            ?.themeFor(alertType) ??
        LnAlertTypeTheme.byType(alertType);

    final effectiveColors = typeTheme.colors;

    return LnAlertDecoration(
      backgroundColor: typeTheme.colorFilled
          ? effectiveColors.accent
          : theme.colorScheme.background,
      foregroundColor: effectiveColors.secondary,
      scrimColor: typeTheme.scrimColor,
      icon: typeTheme.icon,
    );
  }

  const LnAlertDecoration({
    required this.backgroundColor,
    required this.foregroundColor,
    required this.scrimColor,
    required this.icon,
  });
}
