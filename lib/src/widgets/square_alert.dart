import 'package:flutter/material.dart';
import 'package:ln_alerts/ln_alerts.dart';
import 'package:ln_alerts/src/locales/ln_alerts_locale.dart';

class SquareAlert extends LnAlertWidget {
  final bool card;

  const SquareAlert({
    super.key,
    required super.alert,
    super.colorFilled,
    super.buttonText,
    super.onPressed,
    this.card = false,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveData = this.effectiveData(context);
    final textStyle = TextStyle(color: effectiveData.foregroundColor);

    var child = Container(
      color: effectiveData.backgroundColor,
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 18.0),
      child: Column(
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
          if (buttonText != null)
            TextButton(
              onPressed: onPressed,
              child: Text(buttonText!, style: textStyle),
            )
        ],
      ),
    );
    return card ? Card(child: child) : child;
  }

  SquareAlert.noResultsFound({
    bool border = true,
    List<LnAlertActionButton> buttons = const [],
  }) : this(
          alert: LnAlert(
            lightAccentColor: Colors.grey.shade800,
            lightSecondaryColor: Colors.grey.shade100,
            darkAccentColor: Colors.grey.shade100,
            darkSecondaryColor: Colors.grey.shade800,
            icon: Icons.web_asset_off_rounded,
            message: alertsLocalizationScope.instance.noResultsFound,
            buttons: buttons,
          ),
          card: border,
        );
}
