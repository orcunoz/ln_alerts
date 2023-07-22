import 'package:flutter/material.dart';
import 'package:ln_alerts/ln_alerts.dart';
import 'package:ln_alerts/src/style/alert_decoration.dart';
import 'package:ln_core/ln_core.dart';

class NotificationAlertConfig extends AlertConfig {
  final double? width;
  final BorderRadius? borderRadius;
  final double? borderWidth;
  final EdgeInsets? insets;
  final Alignment? alignment;

  const NotificationAlertConfig({
    super.duration = const Duration(seconds: 10),
    this.width = 400,
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
    this.borderWidth = .5,
    this.insets = const EdgeInsets.all(8),
    this.alignment = Alignment.topRight,
  });
}

class NotificationAlert extends LnAlertWidget {
  final NotificationAlertConfig? config;

  const NotificationAlert({
    super.key,
    required super.alert,
    this.config,
  });

  @override
  Widget build(BuildContext context) {
    final defaults = LnAlerts.of(context).notificationAlertDefaults;
    final decoration = super.decoration ??
        LnAlertDecoration.generate(context: context, alertType: alert.type);

    final textStyle = TextStyle(color: decoration.foregroundColor);

    Widget child = Text(effectiveMessage, style: textStyle);

    if (alert.title != null) {
      child = SpacedColumn(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 2,
        children: [
          Text(
            alert.title!,
            style: textStyle.copyWith(fontWeight: FontWeight.bold),
          ),
          child,
        ],
      );
    }

    child = SpacedRow(
      spacing: 8,
      children: [
        Icon(decoration.icon, color: decoration.foregroundColor),
        Expanded(child: child),
        for (var button in alert.buttons) button,
      ],
    );

    final constraints = defaults.width == null
        ? null
        : BoxConstraints(maxWidth: defaults.width!);

    return Container(
      padding: EdgeInsets.all(12),
      constraints: constraints,
      decoration: BoxDecoration(
        color: decoration.backgroundColor,
        border: Border.fromBorderSide(
          BorderSide(
            width: .5,
            color: decoration.backgroundColor
                .blend(decoration.foregroundColor, 50),
          ),
        ),
        borderRadius: defaults.borderRadius ?? BorderRadius.circular(8),
      ),
      child: child,
    );
  }
}
