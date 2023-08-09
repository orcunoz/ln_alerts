import 'package:flutter/material.dart';

import '../host.dart';
import '../style/theme_data.dart';
import '../style/widget_decoration.dart';
import 'alert_widget.dart';

class FlatAlertsContainer extends StatelessWidget {
  final FlatAlertsContainerSettings settings;
  final FlatAlertDecoration alertDecoration;
  final Iterable<AlertOnDisplay> alerts;

  const FlatAlertsContainer({
    super.key,
    required this.settings,
    required this.alertDecoration,
    required this.alerts,
  });

  @override
  Widget build(BuildContext context) {
    Widget child = ClipRRect(
      borderRadius: settings.borderRadius,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: settings.borderRadius,
          border: settings.borderSide == null
              ? null
              : Border.fromBorderSide(settings.borderSide!),
        ),
        child: Column(
          children: [
            for (final alertOnDisplay in alerts)
              FlatAlert(
                alert: alertOnDisplay.alert,
                decoration: alertDecoration,
                buttons: alertOnDisplay.buttons,
              ),
          ],
        ),
      ),
    );

    if (settings.horizontalMargin != null) {
      child = Padding(
        padding: EdgeInsets.symmetric(horizontal: settings.horizontalMargin!),
        child: child,
      );
    }

    return child;
  }
}
