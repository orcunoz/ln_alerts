import 'package:flutter/material.dart';
import 'package:ln_core/ln_core.dart';

import '../host.dart';
import '../style/theme_data.dart';
import '../style/widget_decoration.dart';
import 'alert_widget.dart';

class NotificationAlertsContainer extends StatelessWidget {
  final NotificationAlertsContainerSettings settings;
  final NotificationAlertDecoration alertDecoration;
  final Iterable<AlertOnDisplay> alerts;

  const NotificationAlertsContainer({
    super.key,
    required this.settings,
    required this.alertDecoration,
    required this.alerts,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: settings.alignment,
      child: Container(
        padding: settings.insets,
        alignment: settings.alignment,
        constraints: BoxConstraints(
          maxWidth: settings.width,
        ),
        child: SpacedColumn(
          mainAxisSize: MainAxisSize.min,
          spacing: settings.spacing,
          children: [
            for (var alertOnDisplay in alerts)
              NotificationAlert(
                alert: alertOnDisplay.alert,
                decoration: alertDecoration,
                buttons: alertOnDisplay.buttons,
              ),
          ],
        ),
      ),
    );
  }
}
