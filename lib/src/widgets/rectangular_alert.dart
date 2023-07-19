import 'package:flutter/material.dart';

import '../alert.dart';
import '../defaults.dart';
import '../locales/ln_alerts_locale.dart';
import '../models/action_button.dart';
import 'alert_widget.dart';

class RectangularAlert extends LnAlertWidget {
  final double? minWidth;
  final bool frameless;

  const RectangularAlert({
    super.key,
    required super.alert,
    this.minWidth = LnAlertDefaults.rectangularAlertMinWidth,
    this.frameless = false,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveData = this.effectiveData(context);
    final textStyle = TextStyle(color: effectiveData.foregroundColor);

    Widget child = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          effectiveData.icon,
          size: 64,
          color: effectiveData.foregroundColor,
        ),
        SizedBox(height: 8),
        Text(effectiveMessage, style: textStyle),
        for (var button in alert.buttons) button
      ],
    );

    if (!frameless) {
      child = Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 18.0),
        constraints:
            minWidth != null ? BoxConstraints(minWidth: minWidth!) : null,
        decoration: BoxDecoration(
          color: effectiveData.backgroundColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(width: .5, color: effectiveData.foregroundColor),
        ),
        child: child,
      );
    }

    return child;
  }

  RectangularAlert.noResultsFound({
    bool frameless = true,
    List<LnAlertActionButton> buttons = const [],
  }) : this(
          frameless: frameless,
          alert: LnAlert(
            lightAccentColor: Colors.grey.shade800,
            lightSecondaryColor: Colors.grey.shade800,
            darkAccentColor: Colors.grey.shade100,
            darkSecondaryColor: Colors.grey.shade500,
            icon: Icons.web_asset_off_rounded,
            message: alertsLocalizationScope.current.noResultsFound,
            buttons: buttons,
          ),
        );
}
