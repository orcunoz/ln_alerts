import 'package:flutter/material.dart';
import 'package:ln_alerts/ln_alerts.dart';
import 'package:ln_core/ln_core.dart';

class _LnAlertContainer extends InheritedWidget {
  final LnAlertContainerState data;

  const _LnAlertContainer({
    required this.data,
    required super.child,
  });

  @override
  bool updateShouldNotify(_LnAlertContainer oldWidget) =>
      oldWidget.data != data;
}

class LnAlertContainer extends StatefulWidget {
  final WidgetTypes? defaultWidget;
  final Widget? child;
  final WidgetBuilder? builder;
  final bool shrinkWrap;

  const LnAlertContainer({
    super.key,
    this.defaultWidget,
    bool shrinkWrap = false,
    this.child,
  })  : builder = null,
        shrinkWrap = shrinkWrap || child == null;

  const LnAlertContainer.builder({
    super.key,
    this.defaultWidget,
    bool shrinkWrap = false,
    required this.builder,
  })  : child = null,
        shrinkWrap = shrinkWrap || builder == null;

  @override
  State<LnAlertContainer> createState() => LnAlertContainerState();

  static LnAlertContainerState of(BuildContext context) {
    var host = maybeOf(context);
    if (host == null) {
      throw Exception("No LnAlertContainer found in this context.");
    }

    return host;
  }

  static LnAlertContainerState? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_LnAlertContainer>()?.data;
}

class _AlertOnDisplay {
  final Object? unique;
  final WidgetTypes widgetType;
  final LnAlert alert;

  _AlertOnDisplay(this.unique, this.widgetType, this.alert);
}

class LnAlertContainerState extends LnState<LnAlertContainer> {
  final List<_AlertOnDisplay> _alerts = <_AlertOnDisplay>[];
  final List<LnAlertContainerState> _registeredContainers = [];

  void register(LnAlertContainerState container) {
    _registeredContainers.add(container);
  }

  void unregister(LnAlertContainerState container) {
    _registeredContainers.remove(container);
  }

  void _log(String method, [String? message]) {
    //Log.colored("LnAlertContainer",
    //    "#$_generation.$method${message != null ? " => $message" : ""}");
  }

  @override
  void initState() {
    super.initState();

    if (widget.child == null && widget.builder == null) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        LnAlertContainer.maybeOf(context)?.register(this);
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    LnAlertContainer.maybeOf(context)?.unregister(this);
  }

  void clearAlertsByUnique(Object? unique) {
    if (unique != null) {
      for (var container in _registeredContainers) {
        container.clearAlertsByUnique(unique);
      }
      _alerts.removeWhere((a) => a.unique == unique);
      rebuild();
    }
  }

  void show(
    final LnAlert alert, {
    final Duration? duration,
    final WidgetTypes? widgetType,
    final Object? alertUnique,
  }) {
    clearAlertsByUnique(alertUnique);
    final lnAlerts = LnAlerts.of(context);

    if (_registeredContainers.isNotEmpty) {
      for (var childContainer in _registeredContainers) {
        childContainer._show(
          lnAlerts,
          alert,
          duration: duration,
          widgetType: widgetType,
          alertUnique: alertUnique,
        );
      }
    } else {
      _show(
        lnAlerts,
        alert,
        duration: duration,
        widgetType: widgetType,
        alertUnique: alertUnique,
      );
    }
  }

  bool _show(
    final LnAlerts lnAlerts,
    final LnAlert alert, {
    final Duration? duration,
    final WidgetTypes? widgetType,
    final Object? alertUnique,
  }) {
    final defaultWidgetType =
        widgetType ?? widget.defaultWidget ?? lnAlerts.defaultAlertWidget;

    if (!_alerts.any((a) => a.alert == alert)) {
      final newAlert = _AlertOnDisplay(alertUnique, defaultWidgetType, alert);
      _alerts.add(newAlert);
      rebuild();

      final dur = duration ?? lnAlerts.defaultsOf(defaultWidgetType).duration;
      if (dur != null) {
        Future.delayed(dur, () {
          _alerts.remove(newAlert);
          rebuild();
        });
      }
    }
    return true;
  }

  void errorHandler(Object error, StackTrace stackTrace) =>
      show(LnAlert.errorAutoDetect(error));

  Widget _build(BuildContext context) {
    final lnAlerts = LnAlerts.maybeOf(context);
    final lnTheme = Theme.of(context).brightness == Brightness.light
        ? lnAlerts?.lightTheme
        : lnAlerts?.darkTheme;

    final flatAlertDefaults = lnAlerts?.flatAlertDefaults;
    final notificationAlertsConfig = lnAlerts?.notificationAlertDefaults;
    final rectangularAlertsConfig = lnAlerts?.rectangularAlertDefaults;

    final flatAlertsOnDisplay =
        _alerts.where((a) => a.widgetType == WidgetTypes.flat);
    final notificationAlertsOnDisplay =
        _alerts.where((a) => a.widgetType == WidgetTypes.notification);
    final rectangularAlertsOnDisplay =
        _alerts.where((a) => a.widgetType == WidgetTypes.rectangular);

    final padding = EdgeInsets.all(8);

    Widget? child = widget.child ?? widget.builder?.call(context);

    if (!widget.shrinkWrap) {
      child = Expanded(child: child!);
    }

    child = Column(
      mainAxisSize: widget.shrinkWrap ? MainAxisSize.min : MainAxisSize.max,
      children: [
        if (flatAlertDefaults?.position == FlatAlertPosition.top)
          for (var alertOnDisplay in flatAlertsOnDisplay)
            FlatAlert(
              alert: alertOnDisplay.alert,
              config: flatAlertDefaults,
            ),
        if (child != null) child,
        if (flatAlertDefaults == null ||
            flatAlertDefaults.position == FlatAlertPosition.bottom)
          for (var alertOnDisplay in flatAlertsOnDisplay)
            FlatAlert(
              alert: alertOnDisplay.alert,
              config: flatAlertDefaults,
            ),
      ],
    );

    child = Stack(
      children: [
        child,
        if (rectangularAlertsOnDisplay.isNotEmpty)
          Container(
            color: lnTheme
                ?.themeFor(rectangularAlertsOnDisplay.last.alert.type)
                .scrimColor,
          ),
        if (notificationAlertsOnDisplay.isNotEmpty)
          Container(
            padding: notificationAlertsConfig?.insets,
            alignment: notificationAlertsConfig?.alignment,
            child: SpacedColumn(
              mainAxisSize: MainAxisSize.min,
              spacing: 4,
              children: [
                for (var alertOnDisplay in notificationAlertsOnDisplay)
                  NotificationAlert(
                    alert: alertOnDisplay.alert,
                    config: notificationAlertsConfig,
                  ),
              ],
            ),
          ),
        if (rectangularAlertsOnDisplay.isNotEmpty)
          for (var alertOnDisplay in rectangularAlertsOnDisplay)
            Container(
              alignment: Alignment.center,
              padding: padding,
              child: RectangularAlert(
                alert: alertOnDisplay.alert,
                config: rectangularAlertsConfig,
              ),
            ),
      ],
    );

    return child;
  }

  @override
  Widget build(BuildContext context) {
    return _LnAlertContainer(
      data: this,
      child: Builder(
        builder: _build,
      ),
    );
  }
}
