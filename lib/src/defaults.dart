import 'package:flutter/material.dart';

import 'container.dart';
import 'models/widget_types.dart';
import 'style/theme.dart';
import 'widgets/alert_widget.dart';
import 'widgets/flat_alert.dart';
import 'widgets/notification_alert.dart';
import 'widgets/rectangular_alert.dart';

class LnAlerts extends InheritedWidget {
  final LnAlertsTheme lightTheme;
  final LnAlertsTheme darkTheme;

  final FlatAlertConfig flatAlertDefaults;
  final NotificationAlertConfig notificationAlertDefaults;
  final RectangularAlertConfig rectangularAlertDefaults;

  final WidgetTypes columnContainerDefaultWidget;
  final WidgetTypes stackContainerDefaultWidget;

  LnAlerts({
    super.key,
    this.lightTheme = const LnAlertsTheme.defaultsLight(),
    this.darkTheme = const LnAlertsTheme.defaultsDark(),
    this.flatAlertDefaults = const FlatAlertConfig(),
    this.notificationAlertDefaults = const NotificationAlertConfig(),
    this.rectangularAlertDefaults = const RectangularAlertConfig(),
    this.columnContainerDefaultWidget = WidgetTypes.flat,
    this.stackContainerDefaultWidget = WidgetTypes.notification,
    required WidgetBuilder builder,
  }) : super(
          child: LnAlertContainer.stack(
            childrenBuilder: (context) => [builder(context)],
          ),
        );

  AlertConfig defaultsOf(WidgetTypes type) => switch (type) {
        WidgetTypes.flat => flatAlertDefaults,
        WidgetTypes.notification => notificationAlertDefaults,
        WidgetTypes.rectangular => rectangularAlertDefaults,
      };

  static LnAlerts of(BuildContext context) {
    var host = maybeOf(context);
    if (host == null) {
      throw Exception("No LnAlerts found in this context.");
    }

    return host;
  }

  static LnAlerts? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<LnAlerts>();

  @override
  bool updateShouldNotify(LnAlerts oldWidget) =>
      oldWidget.lightTheme != lightTheme ||
      oldWidget.darkTheme != darkTheme ||
      oldWidget.flatAlertDefaults != flatAlertDefaults ||
      oldWidget.notificationAlertDefaults != notificationAlertDefaults ||
      oldWidget.rectangularAlertDefaults != rectangularAlertDefaults ||
      oldWidget.columnContainerDefaultWidget != columnContainerDefaultWidget ||
      oldWidget.stackContainerDefaultWidget != stackContainerDefaultWidget;
}
