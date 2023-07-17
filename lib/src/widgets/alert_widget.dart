// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:ln_alerts/ln_alerts.dart';
import 'package:ln_alerts/src/defaults.dart';
import 'package:ln_alerts/src/locales/ln_alerts_locale.dart';
import 'package:ln_core/ln_core.dart';

abstract class LnAlertWidget extends StatelessWidget {
  final LnAlert alert;
  final bool? colorFilled;
  final String? buttonText;
  final Function()? onPressed;

  const LnAlertWidget({
    super.key,
    required this.alert,
    required this.colorFilled,
    required this.buttonText,
    required this.onPressed,
  });

  String get effectiveMessage =>
      alert.message ??
      switch (alert.type) {
        AlertType.success => alertsLocalizationScope.instance.successful,
        AlertType.error => alertsLocalizationScope.instance.somethingWentWrong,
        _ => "-"
      };

  @protected
  LnEffectiveAlertWidgetData effectiveData(BuildContext context) {
    Log.colored(
        "LnAlertWidget", "whenPreparing effective data: LnAlert: $alert");
    return LnEffectiveAlertWidgetData(context, alert, colorFilled);
  }
}

class LnEffectiveAlertWidgetData {
  //final Color accentColor;
  //final Color secondaryColor;
  //final bool colorFilled;
  final Color backgroundColor;
  final Color foregroundColor;
  final IconData icon;

  const LnEffectiveAlertWidgetData._({
    //required this.accentColor,
    //required this.secondaryColor,
    //required this.colorFilled,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.icon,
  });

  factory LnEffectiveAlertWidgetData(
      BuildContext context, LnAlert alert, bool? colorFilled) {
    final brightness = Theme.of(context).brightness;
    final alertHost = LnAlertManager.of(context).widget;
    final effectiveColorFilled = colorFilled ?? alertHost.defaultColorFilled;
    final accentColor = brightness == Brightness.light
        ? effectiveLightAccentColor(alert, alertHost)
        : effectiveDarkAccentColor(alert, alertHost);
    final secondaryColor = brightness == Brightness.light
        ? effectiveLightSecondaryColor(alert, alertHost)
        : effectiveDarkSecondaryColor(alert, alertHost);
    return LnEffectiveAlertWidgetData._(
      //accentColor: accentColor,
      //secondaryColor: secondaryColor,
      //colorFilled: colorFilled,
      backgroundColor: effectiveColorFilled ? accentColor : secondaryColor,
      foregroundColor: effectiveColorFilled ? secondaryColor : accentColor,
      icon: effectiveIcon(alert, alertHost),
    );
  }

  @protected
  static IconData effectiveIcon(LnAlert alert, LnAlertHost host) =>
      alert.icon ??
      host.defaultDecorations[alert.type]?.icon ??
      LnAlertDefaults.decorations[alert.type]!.icon!;

  @protected
  static Color effectiveLightAccentColor(LnAlert alert, LnAlertHost host) =>
      alert.lightAccentColor ??
      host.defaultDecorations[alert.type]?.lightAccentColor ??
      LnAlertDefaults.decorations[alert.type]!.lightAccentColor;

  @protected
  static Color effectiveDarkAccentColor(LnAlert alert, LnAlertHost host) =>
      alert.darkAccentColor ??
      host.defaultDecorations[alert.type]?.darkAccentColor ??
      LnAlertDefaults.decorations[alert.type]!.darkAccentColor;

  @protected
  static Color effectiveLightSecondaryColor(LnAlert alert, LnAlertHost host) =>
      alert.lightSecondaryColor ??
      host.defaultDecorations[alert.type]?.lightForegroundColor ??
      LnAlertDefaults.decorations[alert.type]!.lightForegroundColor;

  @protected
  static Color effectiveDarkSecondaryColor(LnAlert alert, LnAlertHost host) =>
      alert.darkSecondaryColor ??
      host.defaultDecorations[alert.type]?.darkForegroundColor ??
      LnAlertDefaults.decorations[alert.type]!.darkForegroundColor;

  @override
  String toString() =>
      'LnEffectiveAlertWidgetData(backgroundColor: $backgroundColor, foregroundColor: $foregroundColor, icon: $icon)';
}
