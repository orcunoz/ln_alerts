import 'package:flutter/material.dart';
import 'package:ln_alerts/ln_alerts.dart';
import 'package:ln_alerts/src/defaults.dart';
import 'package:ln_alerts/src/locales/ln_alerts_locale.dart';
import 'package:ln_core/ln_core.dart';

class LnAlertManager extends InheritedWidget {
  final LnAlertHostState data;

  const LnAlertManager({
    super.key,
    required this.data,
    required super.child,
  });

  static LnAlertHostState of(BuildContext context) {
    var host =
        context.dependOnInheritedWidgetOfExactType<LnAlertManager>()?.data;
    if (host == null) {
      throw Exception("No LnAlertHost found in this context.");
    }

    return host;
  }

  @override
  bool updateShouldNotify(LnAlertManager oldWidget) => oldWidget.data != data;
}

class LnAlertHost extends StatefulWidget {
  final Duration? defaultDuration;
  final AlertPosition defaultPosition;
  final bool defaultColorFilled;
  final String? defaultButtonText;
  final Map<AlertType, LnAlertDecoration> defaultDecorations;

  final WidgetBuilder? builder;

  const LnAlertHost({
    super.key,
    this.defaultDuration = LnAlertDefaults.duration,
    this.defaultPosition = LnAlertDefaults.position,
    this.defaultColorFilled = LnAlertDefaults.colorFilled,
    this.defaultButtonText,
    this.defaultDecorations = LnAlertDefaults.decorations,
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

    alerts[pos]!.add(alert);
    setState(() {});
    if (dur != null) {
      Future.delayed(dur, () {
        setState(() {
          alerts[pos]?.remove(alert);
        });
      });
    }
  }

  void errorHandler(Object error, StackTrace stackTrace) =>
      show(LnAlert.errorAutoDetect(error));

  @override
  Widget build(BuildContext context) {
    return LnAlertManager(
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
              children: [
                if (child != null) child,
                if (alerts[AlertPosition.overTop]?.isNotEmpty == true)
                  Container(
                    alignment: Alignment.topCenter,
                    padding: padding,
                    child: SpacedColumn(
                      spacing: 4,
                      children: [
                        for (var alert in alerts[AlertPosition.overTop]!)
                          NotificationAlert(alert: alert),
                      ],
                    ),
                  ),
                if (alerts[AlertPosition.overBottom]?.isNotEmpty == true)
                  Container(
                    alignment: Alignment.bottomCenter,
                    padding: padding,
                    child: SpacedColumn(
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
                          ? const Color(0x20000000)
                          : const Color(0x20FFFFFF),
                      child: SquareAlert(
                        alert: alert,
                        card: true,
                        buttonText: "OK",
                        onPressed: () {},
                      ),
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
