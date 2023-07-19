// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:ln_core/ln_core.dart';

import '../alert.dart';
import '../defaults.dart';
import '../host.dart';
import '../locales/ln_alerts_locale.dart';
import '../models/alert_type.dart';

abstract class LnAlertWidget extends StatelessWidget {
  final LnAlert alert;

  const LnAlertWidget({
    super.key,
    required this.alert,
  });

  String get effectiveMessage =>
      alert.message ??
      switch (alert.type) {
        AlertType.success => alertsLocalizationScope.current.successful,
        AlertType.error => alertsLocalizationScope.current.somethingWentWrong,
        _ => "-"
      };

  @protected
  LnEffectiveAlertWidgetData effectiveData(BuildContext context) {
    Log.colored(
        "LnAlertWidget", "whenPreparing effective data: LnAlert: $alert");
    return LnEffectiveAlertWidgetData(context, alert);
  }
}

class LnEffectiveAlertWidgetData {
  //final Color accentColor;
  //final Color secondaryColor;
  //final bool colorFilled;
  final Color backgroundColor;
  final Color foregroundColor;
  final IconData? icon;

  const LnEffectiveAlertWidgetData._({
    //required this.accentColor,
    //required this.secondaryColor,
    //required this.colorFilled,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.icon,
  });

  factory LnEffectiveAlertWidgetData(BuildContext context, LnAlert alert) {
    final brightness = Theme.of(context).brightness;
    final host = LnAlerts.maybeOf(context)?.widget;
    final hostDecorationDefaults = host?.defaultDecorations[alert.type];
    final decorationDefaults = LnAlertDefaults.decorations[alert.type];

    final effectiveColorFilled = alert.colorFilled ??
        host?.defaultColorFilled ??
        LnAlertDefaults.colorFilled;

    final Color accentColor, secondaryColor;
    if (brightness == Brightness.light) {
      accentColor = alert.lightAccentColor ??
          hostDecorationDefaults?.lightAccentColor ??
          decorationDefaults!.lightAccentColor;
      secondaryColor = alert.lightSecondaryColor ??
          hostDecorationDefaults?.lightSecondaryColor ??
          decorationDefaults!.lightSecondaryColor;
    } else {
      accentColor = alert.darkAccentColor ??
          hostDecorationDefaults?.darkAccentColor ??
          decorationDefaults!.darkAccentColor;
      secondaryColor = alert.darkSecondaryColor ??
          hostDecorationDefaults?.darkSecondaryColor ??
          decorationDefaults!.darkSecondaryColor;
    }

    return LnEffectiveAlertWidgetData._(
      backgroundColor: effectiveColorFilled
          ? accentColor
          : Theme.of(context).colorScheme.background,
      foregroundColor: secondaryColor,
      icon: alert.icon ??
          hostDecorationDefaults?.icon ??
          decorationDefaults!.icon,
    );
  }

  @override
  String toString() =>
      'LnEffectiveAlertWidgetData(backgroundColor: $backgroundColor, foregroundColor: $foregroundColor, icon: $icon)';
}
