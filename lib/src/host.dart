import 'package:flutter/material.dart';
import 'package:ln_alerts/ln_alerts.dart';
import 'package:ln_core/ln_core.dart';

class LnAlertHost extends StatefulWidget {
  final AlertWidgets? defaultWidget;
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

class _AlertOnDisplay {
  final Object unique;
  final AlertWidgets widgetType;
  final LnAlert alert;
  final List<LnAlertActionButton> buttons;

  double? height;
  double? width;

  _AlertOnDisplay(this.unique, this.widgetType, this.alert, this.buttons);
}

int counter = 0;

class LnAlertHostState extends LnState<LnAlertHost> {
  final List<_AlertOnDisplay> _alerts = <_AlertOnDisplay>[];
  final List<LnAlertHostState> _registeredContainers = [];
  LnAlertHostState? parentContainer;
  List<Object?> progressUniques = <Object?>[];
  Size? size;
  double? bottomPadding = 0;
  bool _wrapWithMaterial = false;

  void _register(LnAlertHostState container) {
    _registeredContainers.add(container);
  }

  void _unregister(LnAlertHostState container) {
    _registeredContainers.remove(container);
  }

  @override
  void initState() {
    super.initState();

    if (widget.child == null && widget.builder == null) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        parentContainer = LnAlertHost.maybeOf(context)?.._register(this);
      });
    }
  }

  @override
  void deactivate() {
    parentContainer?._unregister(this);
    super.deactivate();
  }

  @override
  void dispose() {
    _registeredContainers.clear();
    _alerts.clear();
    super.dispose();
  }

  void removeByUnique(Object? unique) {
    if (unique != null) {
      for (var container in _registeredContainers) {
        container.removeByUnique(unique);
      }
      _alerts.removeWhere((a) => a.unique == unique);
      rebuild();
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
    final AlertWidgets? widgetType,
    final Object? unique,
  }) {
    final theme = LnAlertsTheme.of(context);

    if (_registeredContainers.isNotEmpty) {
      for (var childContainer in _registeredContainers) {
        childContainer._show(
          theme,
          alert,
          duration: duration,
          widgetType: widgetType,
          unique: unique.toString() + (++counter).toString(),
        );
      }
    } else {
      _show(
        theme,
        alert,
        duration: duration,
        widgetType: widgetType,
        unique: unique.toString() + (++counter).toString(),
      );
    }
  }

  bool _show(
    final LnAlertsThemeData theme,
    final LnAlert alert, {
    final Duration? duration,
    final AlertWidgets? widgetType,
    final Object? unique,
  }) {
    removeByUnique(unique);
    final defaultWidgetType =
        widgetType ?? widget.defaultWidget ?? AlertWidgets.notification;

    if (!_alerts.any((a) => a.alert == alert)) {
      final alertUnique = unique ?? UniqueKey();
      final buttons = [
        LnAlertActionButton(
          icon: Icons.close_rounded,
          onPressed: () => removeByUnique(alertUnique),
        ),
      ];
      final newAlert = _AlertOnDisplay(
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
        _alerts.where((a) => a.widgetType == AlertWidgets.flat).toList();
    final notificationAlerts =
        _alerts.where((a) => a.widgetType == AlertWidgets.notification);
    final popupAlerts =
        _alerts.where((a) => a.widgetType == AlertWidgets.popup);

    Widget? child = widget.child ?? widget.builder?.call(context);

    /*if (child != null && widget.expanded) {
      child = Expanded(child: child);
    }

    child = Column(
      verticalDirection:
          lnAlerts.flatAlertSettings.position == FlatAlertPosition.bottom
              ? VerticalDirection.up
              : VerticalDirection.down,
      children: [
        if (lnAlerts.flatAlertSettings.position == FlatAlertPosition.top)
          for (var alertOnDisplay in flatAlerts)
            FlatAlert(
              alert: alertOnDisplay.alert,
              settings: lnAlerts.flatAlertSettings,
              onTapClose: () => removeAlertsByUnique(alertOnDisplay.unique),
            ),
        if (lnAlerts.flatAlertSettings.position == FlatAlertPosition.bottom)
          for (var alertOnDisplay in flatAlerts) ...[
            if (alertOnDisplay.height == null)
              Padding(
                padding: EdgeInsets.only(top: 32, left: 4, right: 4),
                child: Measurable(
                  onChange: (size) {
                    alertOnDisplay.height = size?.height;
                    alertOnDisplay.width = size?.width;
                    rebuild();
                  },
                  child: FlatAlert(
                    alert: alertOnDisplay.alert,
                    settings: lnAlerts.flatAlertSettings,
                    onTapClose: () =>
                        removeAlertsByUnique(alertOnDisplay.unique),
                  ),
                ),
              ),
            if (alertOnDisplay.height != null)
              SizedOverflowBox(
                size: Size.fromHeight(alertOnDisplay.height ?? 0),
                child: Container(
                  transform: Matrix4.translationValues(0, -16, 0),
                  height: alertOnDisplay.height! + 64,
                  padding: EdgeInsets.only(top: 32, left: 4, right: 4),
                  child: FlatAlert(
                    alert: alertOnDisplay.alert,
                    settings: lnAlerts.flatAlertSettings,
                    onTapClose: () =>
                        removeAlertsByUnique(alertOnDisplay.unique),
                  ),
                ),
              ),
          ],
        if (child != null) child,
      ],
    );*/

    final expand = constraints.maxHeight != double.infinity;
    final flatAlertsHeightSum = flatAlerts.isEmpty
        ? 0.0
        : flatAlerts
            .map((e) => e.height ?? 0.0)
            .reduce((value, h) => value + h);

    child = Stack(
      children: [
        if (theme.flatAlertDecoration.position == FlatAlertPosition.bottom)
          for (var alertOnDisplay in flatAlerts)
            Positioned(
              left: 0,
              right: 0,
              top: expand
                  ? constraints.maxHeight - (flatAlertsHeightSum)
                  : size?.height,
              child: Measurable(
                onChange: (size) {
                  alertOnDisplay.height = size?.height ?? 0;
                  rebuild();
                },
                child: FlatAlert(
                  alert: alertOnDisplay.alert,
                  decoration: theme.flatAlertDecoration,
                  buttons: alertOnDisplay.buttons,
                ),
              ),
            ),
        if (child != null)
          if (expand)
            Container(
              width: constraints.maxWidth,
              height: constraints.maxHeight - (flatAlertsHeightSum),
              child: child,
            )
          else
            Padding(
              padding: EdgeInsets.only(bottom: flatAlertsHeightSum),
              child: Measurable(
                onChange: (size) {
                  this.size = size;
                  rebuild();
                },
                child: child,
              ),
            ),
        if (notificationAlerts.isNotEmpty)
          _buildNotificationList(
            theme.notificationAlertContainerSettings,
            [
              for (var alertOnDisplay in notificationAlerts)
                NotificationAlert(
                  alert: alertOnDisplay.alert,
                  decoration: theme.notificationAlertDecoration,
                  buttons: alertOnDisplay.buttons,
                ),
            ],
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
      child = Material(
        child: child,
      );
    }

    return child;
  }

  Widget _buildNotificationList(NotificationAlertContainerSettings settings,
      List<Widget> notificationWidgets) {
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
          children: notificationWidgets,
        ),
      ),
    );
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
