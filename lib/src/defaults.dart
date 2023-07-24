import 'package:flutter/material.dart';
import 'package:ln_alerts/ln_alerts.dart';

import 'style/theme.dart';

class LnAlerts extends InheritedWidget {
  final LnAlertsTheme lightTheme;
  final LnAlertsTheme darkTheme;

  final FlatAlertConfig flatAlertDefaults;
  final NotificationAlertConfig notificationAlertDefaults;
  final RectangularAlertConfig rectangularAlertDefaults;

  final WidgetTypes defaultAlertWidget;

  LnAlerts({
    super.key,
    this.lightTheme = const LnAlertsTheme.defaultsLight(),
    this.darkTheme = const LnAlertsTheme.defaultsDark(),
    this.flatAlertDefaults = const FlatAlertConfig(),
    this.notificationAlertDefaults = const NotificationAlertConfig(),
    this.rectangularAlertDefaults = const RectangularAlertConfig(),
    this.defaultAlertWidget = WidgetTypes.notification,
    required WidgetBuilder builder,
  }) : super(
          child: LnAlertContainer.builder(
            defaultWidget: defaultAlertWidget,
            shrinkWrap: false,
            builder: builder,
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
      oldWidget.defaultAlertWidget != defaultAlertWidget;
}
