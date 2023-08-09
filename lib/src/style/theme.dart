import 'package:flutter/material.dart';
import 'package:ln_alerts/ln_alerts.dart';

class LnAlertsTheme extends StatelessWidget {
  const LnAlertsTheme({
    super.key,
    required this.data,
    required this.child,
  });

  final LnAlertsThemeData data;
  final Widget child;

  WidgetDecoration decorationOf(AlertWidget type) => switch (type) {
        AlertWidget.flat => data.flatAlertDecoration,
        AlertWidget.notification => data.notificationAlertDecoration,
        AlertWidget.popup => data.popupAlertDecoration,
      };

  static final _defaultLightTheme = const LnAlertsThemeData.light();
  static final _defaultDarkTheme = const LnAlertsThemeData.dark();

  static LnAlertsThemeData of(BuildContext context) {
    final _InheritedAlertsTheme? inheritedTheme =
        context.dependOnInheritedWidgetOfExactType<_InheritedAlertsTheme>();

    return inheritedTheme?.theme.data ??
        (Theme.of(context).brightness == Brightness.dark
            ? _defaultDarkTheme
            : _defaultLightTheme);
  }

  @override
  Widget build(BuildContext context) {
    return _InheritedAlertsTheme(
      theme: this,
      child: child,
    );
  }
}

class _InheritedAlertsTheme extends InheritedWidget {
  const _InheritedAlertsTheme({
    required this.theme,
    required super.child,
  });

  final LnAlertsTheme theme;

  Widget wrap(BuildContext context, Widget child) {
    return LnAlertsTheme(data: theme.data, child: child);
  }

  @override
  bool updateShouldNotify(_InheritedAlertsTheme old) =>
      theme.data != old.theme.data;
}
