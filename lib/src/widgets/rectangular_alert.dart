import 'package:flutter/material.dart';

import '../alert.dart';
import '../defaults.dart';
import '../localizations/alerts_localizations.dart';
import '../style/alert_decoration.dart';
import 'action_button.dart';
import 'alert_widget.dart';

class RectangularAlertConfig extends AlertConfig {
  final double? minWidth;
  final BorderRadius? borderRadius;
  final double? borderWidth;

  const RectangularAlertConfig({
    super.duration = const Duration(seconds: 10),
    this.minWidth = 180,
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
    this.borderWidth = .5,
  });

  const RectangularAlertConfig.frameless({
    super.duration = const Duration(seconds: 10),
    this.minWidth = 180,
  })  : borderRadius = null,
        borderWidth = null;
}

class RectangularAlert extends LnAlertWidget {
  final RectangularAlertConfig? config;

  const RectangularAlert({
    super.key,
    required super.alert,
    this.config,
  });

  @override
  Widget build(BuildContext context) {
    final decoration = super.decoration ??
        LnAlertDecoration.generate(context: context, alertType: alert.type);
    final typeSpecificConfig =
        config ?? LnAlerts.of(context).rectangularAlertDefaults;
    final constraints = typeSpecificConfig.minWidth == null
        ? null
        : BoxConstraints(minWidth: typeSpecificConfig.minWidth!);
    final textStyle = TextStyle(color: decoration.foregroundColor);

    Widget child = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          decoration.icon,
          size: 64,
          color: decoration.foregroundColor,
        ),
        SizedBox(height: 8),
        Text(effectiveMessage, style: textStyle),
        for (var button in alert.buttons) button
      ],
    );

    if (typeSpecificConfig.borderWidth != null) {
      child = Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 18.0),
        constraints: constraints,
        decoration: BoxDecoration(
          color: decoration.backgroundColor,
          borderRadius: typeSpecificConfig.borderRadius,
          border: Border.all(
            width: typeSpecificConfig.borderWidth!,
            color: decoration.foregroundColor,
          ),
        ),
        child: child,
      );
    } else if (constraints != null) {
      child = ConstrainedBox(
        constraints: constraints,
        child: child,
      );
    }

    return child;
  }

  RectangularAlert.noResultsFound({
    RectangularAlertConfig config = const RectangularAlertConfig(),
    List<LnAlertActionButton> buttons = const [],
  }) : this(
          config: config,
          alert: LnAlert.info(
            LnAlertsLocalizations.current.noResultsFound,
            icon: Icons.web_asset_off_rounded,
            buttons: buttons,
          ),
        );
}
