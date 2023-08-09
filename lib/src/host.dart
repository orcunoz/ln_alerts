import 'package:flutter/material.dart';
import 'package:ln_alerts/ln_alerts.dart';
import 'package:ln_core/ln_core.dart';

import 'widgets/flat_alerts_container.dart';
import 'widgets/notification_alerts_container.dart';

class LnAlertHost extends StatefulWidget {
  final AlertWidget? defaultWidget;
  final Widget? child;
  final WidgetBuilder? builder;
  final bool? expand;

  const LnAlertHost({
    super.key,
    this.defaultWidget,
    this.expand,
    this.child,
  }) : builder = null;

  const LnAlertHost.builder({
    super.key,
    this.defaultWidget,
    this.expand,
    required this.builder,
  }) : child = null;

  @override
  State<LnAlertHost> createState() => LnAlertHostState();

  static LnAlertHostState of(BuildContext context) {
    var host = maybeOf(context);
    if (host == null) {
      throw Exception("No LnAlertHost found in this context.");
    }

    return host;
  }

  static LnAlertHostState? maybeOf(BuildContext context) =>
      context.findAncestorStateOfType<LnAlertHostState>();
}

class AlertOnDisplay {
  final Object unique;
  final AlertWidget widgetType;
  final LnAlert alert;
  final List<LnAlertActionButton> buttons;

  bool removed = false;

  AlertOnDisplay(this.unique, this.widgetType, this.alert, this.buttons);
}

class LnAlertHostState extends LnState<LnAlertHost> {
  final List<AlertOnDisplay> _alerts = <AlertOnDisplay>[];
  LnAlertHostState? parentContainer;
  List<Object?> progressUniques = <Object?>[];
  Size? size;
  double? bottomPadding = 0;
  bool _wrapWithMaterial = false;

  double flatAlertsHeight = 0;

  final animationDuration = Duration(milliseconds: 500);
  final animationCurve = Curves.easeInOut;

  @override
  void initState() {
    super.initState();
  }

  @override
  void deactivate() {
    super.deactivate();
  }

  @override
  void dispose() {
    _alerts.clear();
    super.dispose();
  }

  void removeByUnique(Object? unique) {
    if (unique != null) {
      final selectedAlertsForRemove =
          _alerts.where((a) => a.unique == unique && !a.removed).toList();
      for (var a in selectedAlertsForRemove) {
        a.removed = true;
      }
      _alerts.removeWhere((a) => selectedAlertsForRemove.contains(a));
      rebuild();

      /*Future.delayed(animationDuration, () {
        Log.wtf("-----  removeByUnique future call");
        _alerts.removeWhere((a) => selectedAlertsForRemove.contains(a));
        rebuild();
      });*/
    }
  }

  void addProgress(Object? progressUnique) {
    progressUniques.add(progressUnique);
    rebuild();
  }

  void removeProgress(Object? progressUnique) {
    progressUniques.remove(progressUnique);
    if (progressUniques.isEmpty) rebuild();
  }

  void show(
    final LnAlert alert, {
    final Duration? duration = const Duration(seconds: 10),
    final AlertWidget? widgetType,
    final Object? unique,
  }) {
    final theme = LnAlertsTheme.of(context);

    _show(
      theme,
      alert,
      duration: duration,
      widgetType: widgetType,
      unique: unique,
    );
  }

  bool _show(
    final LnAlertsThemeData theme,
    final LnAlert alert, {
    final Duration? duration,
    final AlertWidget? widgetType,
    final Object? unique,
  }) {
    final defaultWidgetType =
        widgetType ?? widget.defaultWidget ?? AlertWidget.notification;

    final alertUnique = unique ?? UniqueKey();
    final buttons = [
      LnAlertActionButton(
        icon: Icons.close_rounded,
        onPressed: () => removeByUnique(alertUnique),
      ),
    ];
    final newAlert = AlertOnDisplay(
      alertUnique,
      defaultWidgetType,
      alert,
      buttons,
    );
    _alerts.add(newAlert);
    rebuild();

    if (duration != null) {
      Future.delayed(duration, () {
        _alerts.remove(newAlert);
        rebuild();
      });
    }

    return true;
  }

  void errorHandler(Object error, StackTrace stackTrace) =>
      show(LnAlert.errorAutoDetect(error));

  Widget _build(BuildContext context, BoxConstraints constraints) {
    final theme = LnAlertsTheme.of(context);
    final scrimColor = theme.scrimColor ??
        Theme.of(context).colorScheme.background.withOpacity(.5);

    final flatAlerts =
        _alerts.where((a) => a.widgetType == AlertWidget.flat).toList();
    final notificationAlerts =
        _alerts.where((a) => a.widgetType == AlertWidget.notification).toList();
    final popupAlerts =
        _alerts.where((a) => a.widgetType == AlertWidget.popup).toList();

    Widget? child = widget.child ?? widget.builder?.call(context);

    final expand = constraints.maxHeight != double.infinity;

    child = Stack(
      children: [
        if (theme.flatAlertsContainerSettings.position ==
            FlatAlertPosition.bottom)
          Positioned(
            left: 0,
            right: 0,
            top: expand
                ? constraints.maxHeight - flatAlertsHeight
                : (size?.height ?? 0) -
                    (theme.flatAlertsContainerSettings
                            .amountOfInsertingUnderContent ??
                        0),
            child: Measurable(
              onChange: (size) {
                flatAlertsHeight = size?.height ?? 0;
                rebuild();
              },
              child: FlatAlertsContainer(
                settings: theme.flatAlertsContainerSettings,
                alertDecoration: theme.flatAlertDecoration,
                alerts: flatAlerts,
              ),
            ),
          ),
        if (child != null)
          if (expand)
            AnimatedSize(
              duration: animationDuration,
              curve: animationCurve,
              child: SizedBox(
                width: constraints.maxWidth,
                height: constraints.maxHeight - flatAlertsHeight,
                child: child,
              ),
            )
          else
            AnimatedPadding(
              duration: animationDuration,
              curve: animationCurve,
              padding: EdgeInsets.only(bottom: flatAlertsHeight),
              child: Measurable(
                onChange: (size) {
                  this.size = size;
                  rebuild();
                },
                child: child,
              ),
            ),
        if (notificationAlerts.isNotEmpty)
          NotificationAlertsContainer(
            settings: theme.notificationAlertContainerSettings,
            alertDecoration: theme.notificationAlertDecoration,
            alerts: notificationAlerts,
          ),
        if (popupAlerts.isNotEmpty)
          for (var alertOnDisplay in popupAlerts)
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(12),
              constraints: constraints,
              color: alertOnDisplay == popupAlerts.last ? scrimColor : null,
              child: PopupAlert(
                alert: alertOnDisplay.alert,
                decoration: theme.popupAlertDecoration,
                buttons: alertOnDisplay.buttons,
              ),
            ),
        if (progressUniques.isNotEmpty)
          Container(
            constraints: constraints,
            color: scrimColor,
            alignment: Alignment.center,
            child: ProgressIndicatorLayer(
              withBackLayer: false,
            ),
          ),
      ],
    );

    if (_wrapWithMaterial || Material.maybeOf(context) == null) {
      _wrapWithMaterial = true;
      child = Material(child: child);
    }

    return child;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return _build(
          context,
          constraints.copyWith(
            minHeight: widget.expand != false &&
                    constraints.maxHeight != double.infinity
                ? constraints.maxHeight
                : null,
            minWidth: widget.expand != false &&
                    constraints.maxHeight != double.infinity
                ? constraints.maxWidth
                : null,
          ),
        );
      },
    );
  }
}
