import 'package:flutter/material.dart';
import 'package:ln_core/ln_core.dart';

import 'alert.dart';
import 'defaults.dart';
import 'locales/ln_alerts_locale.dart';
import 'models/alert_position.dart';
import 'models/alert_type.dart';
import 'widgets/flat_alert.dart';
import 'widgets/notification_alert.dart';
import 'widgets/rectangular_alert.dart';

class LnAlerts extends InheritedWidget {
  final LnAlertHostState data;

  const LnAlerts({
    super.key,
    required this.data,
    required super.child,
  });

  static LnAlertHostState of(BuildContext context) {
    var host = maybeOf(context);
    if (host == null) {
      throw Exception("No LnAlertHost found in this context.");
    }

    return host;
  }

  static LnAlertHostState? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<LnAlerts>()?.data;

  @override
  bool updateShouldNotify(LnAlerts oldWidget) => oldWidget.data != data;
}

class LnAlertHost extends StatefulWidget {
  final Duration? defaultDuration;
  final AlertPosition defaultPosition;
  final bool defaultColorFilled;
  final Map<AlertType, LnAlertDecoration> defaultDecorations;
  final Color defaultDarkScrimColor;
  final Color defaultLightScrimColor;
  final double? defaultNotificationAlertMaxWidth;

  final WidgetBuilder? builder;

  const LnAlertHost({
    super.key,
    this.defaultDuration = LnAlertDefaults.duration,
    this.defaultPosition = LnAlertDefaults.position,
    this.defaultColorFilled = LnAlertDefaults.colorFilled,
    this.defaultLightScrimColor = LnAlertDefaults.lightScrimColor,
    this.defaultDarkScrimColor = LnAlertDefaults.darkScrimColor,
    this.defaultDecorations = LnAlertDefaults.decorations,
    this.defaultNotificationAlertMaxWidth =
        LnAlertDefaults.notificationAlertMaxWidth,
    required this.builder,
  });

  @override
  State<LnAlertHost> createState() => LnAlertHostState();
}

class LnAlertHostState extends State<LnAlertHost> {
  final Map<AlertPosition, List<LnAlert>> alerts = {
    for (var k in AlertPosition.values) k: <LnAlert>[]
  };

  void show(
    LnAlert alert, {
    Duration? duration,
    AlertPosition? position,
  }) {
    final pos = position ?? widget.defaultPosition;
    final dur = duration ?? widget.defaultDuration;

    assert(alerts[pos] != null);
    if (alerts[pos]!.contains(alert)) return;

    alerts[pos]!.add(alert);
    setState(() {});
    if (dur != null) {
      Future.delayed(dur, () {
        setState(() {
          alerts[pos]!.remove(alert);
        });
      });
    }
  }

  void errorHandler(Object error, StackTrace stackTrace) =>
      show(LnAlert.errorAutoDetect(error));

  @override
  Widget build(BuildContext context) {
    return LnAlerts(
      data: this,
      child: Builder(
        builder: (context) {
          alertsLocalizationScope.of(context);
          Widget? child = widget.builder?.call(context);

          if (alerts[AlertPosition.top]?.isNotEmpty == true ||
              alerts[AlertPosition.bottom]?.isNotEmpty == true) {
            child = Column(
              children: [
                for (var alert in alerts[AlertPosition.top] ?? [])
                  FlatAlert(
                    alert: alert,
                    hasBottomBorder: true,
                  ),
                Expanded(child: child ?? SizedBox()),
                for (var alert in alerts[AlertPosition.bottom] ?? [])
                  FlatAlert(
                    alert: alert,
                    hasTopBorder: true,
                    additionalPadding:
                        alert == alerts[AlertPosition.bottom]!.last
                            ? MediaQuery.of(context).safeBottomPadding
                            : EdgeInsets.zero,
                  ),
              ],
            );
          }

          final padding = EdgeInsets.all(8);

          if (alerts[AlertPosition.overTop]?.isNotEmpty == true ||
              alerts[AlertPosition.overCenter]?.isNotEmpty == true ||
              alerts[AlertPosition.overBottom]?.isNotEmpty == true) {
            child = Stack(
              alignment: Alignment.topRight,
              children: [
                if (child != null) child,
                if (alerts[AlertPosition.overTop]?.isNotEmpty == true)
                  Container(
                    alignment: Alignment.topRight,
                    padding: padding,
                    child: SpacedColumn(
                      mainAxisSize: MainAxisSize.min,
                      spacing: 4,
                      children: [
                        for (var alert in alerts[AlertPosition.overTop]!)
                          NotificationAlert(alert: alert),
                      ],
                    ),
                  ),
                if (alerts[AlertPosition.overBottom]?.isNotEmpty == true)
                  Container(
                    alignment: Alignment.bottomRight,
                    padding: padding,
                    child: SpacedColumn(
                      mainAxisSize: MainAxisSize.min,
                      spacing: 4,
                      children: [
                        for (var alert in alerts[AlertPosition.overBottom]!)
                          NotificationAlert(alert: alert),
                      ],
                    ),
                  ),
                if (alerts[AlertPosition.overCenter]?.isNotEmpty == true)
                  for (var alert in alerts[AlertPosition.overCenter]!)
                    Container(
                      alignment: Alignment.center,
                      padding: padding,
                      color: Theme.of(context).brightness == Brightness.light
                          ? widget.defaultLightScrimColor
                          : widget.defaultDarkScrimColor,
                      child: RectangularAlert(alert: alert),
                    ),
              ],
            );
          }

          return child ?? SizedBox();
        },
      ),
    );
  }
}
