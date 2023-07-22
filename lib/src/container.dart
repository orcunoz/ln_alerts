import 'package:flutter/material.dart';
import 'package:ln_core/ln_core.dart';

import 'alert.dart';
import 'defaults.dart';
import 'models/container_types.dart';
import 'models/widget_types.dart';
import 'widgets/flat_alert.dart';
import 'widgets/notification_alert.dart';
import 'widgets/rectangular_alert.dart';

class LnAlertContainer extends InheritedWidget {
  final LnAlertContainerState data;

  const LnAlertContainer({
    super.key,
    required this.data,
    required super.child,
  });

  static Widget stack({
    Key? key,
    AlignmentGeometry alignment = AlignmentDirectional.topEnd,
    TextDirection? textDirection,
    StackFit fit = StackFit.expand,
    Clip clipBehavior = Clip.hardEdge,
    required List<Widget> Function(BuildContext) childrenBuilder,
  }) =>
      _LnAlertContainer(
        type: ContainerTypes.stack,
        defaultWidget: WidgetTypes.notification,
        childrenBuilder: childrenBuilder,
        builder: (context, children) => Stack(
          key: key,
          alignment: alignment,
          textDirection: textDirection,
          fit: fit,
          clipBehavior: clipBehavior,
          children: children,
        ),
      );

  static Widget column({
    Key? key,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    MainAxisSize mainAxisSize = MainAxisSize.max,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
    TextDirection? textDirection,
    VerticalDirection verticalDirection = VerticalDirection.down,
    TextBaseline? textBaseline,
    required List<Widget> Function(BuildContext) childrenBuilder,
  }) =>
      _LnAlertContainer(
        type: ContainerTypes.column,
        defaultWidget: WidgetTypes.flat,
        childrenBuilder: childrenBuilder,
        builder: (context, children) => Column(
          key: key,
          mainAxisAlignment: mainAxisAlignment,
          mainAxisSize: mainAxisSize,
          crossAxisAlignment: crossAxisAlignment,
          textDirection: textDirection,
          verticalDirection: verticalDirection,
          textBaseline: textBaseline,
          children: children,
        ),
      );

  static LnAlertContainerState of(BuildContext context) {
    var host = maybeOf(context);
    if (host == null) {
      throw Exception("No LnAlertContainer found in this context.");
    }

    return host;
  }

  static LnAlertContainerState? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<LnAlertContainer>()?.data;

  @override
  bool updateShouldNotify(LnAlertContainer oldWidget) => oldWidget.data != data;
}

class _LnAlertContainer extends StatefulWidget {
  final ContainerTypes type;
  final WidgetTypes defaultWidget;
  final List<Widget> Function(BuildContext) childrenBuilder;
  final Widget Function(BuildContext context, List<Widget> children) builder;

  const _LnAlertContainer({
    required this.type,
    required this.defaultWidget,
    required this.childrenBuilder,
    required this.builder,
  });

  @override
  State<_LnAlertContainer> createState() =>
      LnAlertContainerState(++_generation);
}

int _generation = 0;

class LnAlertContainerState extends LnState<_LnAlertContainer> {
  final Map<WidgetTypes, List<LnAlert>> _alerts = {
    for (var k in WidgetTypes.values) k: <LnAlert>[]
  };
  final int _generation;

  LnAlertContainerState(this._generation) {
    _log("constructor");
  }

  void _log(String method, [String? message]) {
    Log.colored("LnAlertContainer",
        "#$_generation.$method${message != null ? " => $message" : ""}");
  }

  void show(
    final LnAlert alert, {
    final Duration? duration,
    final WidgetTypes? widgetType,
  }) {
    _log("show", alert.message);
    final lnAlerts = LnAlerts.of(context);
    WidgetTypes alertWidgetType;
    LnAlertContainerState container = this;

    if (widgetType == null) {
      alertWidgetType = switch (widget.type) {
        ContainerTypes.column => lnAlerts.columnContainerDefaultWidget,
        ContainerTypes.stack => lnAlerts.stackContainerDefaultWidget,
      };
    } else {
      alertWidgetType = widgetType;
      final requiredContainerType = switch (alertWidgetType) {
        WidgetTypes.flat => ContainerTypes.column,
        WidgetTypes.notification => ContainerTypes.stack,
        WidgetTypes.rectangular => ContainerTypes.stack,
      };
      if (container.widget.type != requiredContainerType) {
        LnAlertContainer.of(context).show(
          alert,
          duration: duration,
          widgetType: alertWidgetType,
        );
        return;
      }
    }

    final dur = duration ?? lnAlerts.defaultsOf(alertWidgetType).duration;
    final targetAlertList = _alerts[alertWidgetType];

    assert(targetAlertList != null);
    if (targetAlertList!.contains(alert)) return;

    targetAlertList.add(alert);
    rebuild();
    if (dur != null) {
      Future.delayed(dur, () {
        targetAlertList.remove(alert);
        rebuild();
      });
    }
  }

  void errorHandler(Object error, StackTrace stackTrace) =>
      show(LnAlert.errorAutoDetect(error));

  List<Widget> _buildColumnChildren(
      BuildContext context, List<Widget> passedChildren) {
    final defaults = LnAlerts.maybeOf(context)?.flatAlertDefaults;
    final flatAlerts = _alerts[WidgetTypes.flat]!;

    return [
      if (defaults?.position == FlatAlertPosition.top)
        for (var alert in flatAlerts)
          FlatAlert(
            alert: alert,
            config: defaults,
          ),
      ...passedChildren,
      if (defaults == null || defaults.position == FlatAlertPosition.bottom)
        for (var alert in flatAlerts)
          FlatAlert(
            alert: alert,
            config: defaults,
          ),
    ];
  }

  List<Widget> _buildStackChildren(
      BuildContext context, List<Widget> passedChildren) {
    final lnAlerts = LnAlerts.maybeOf(context);
    final theme = Theme.of(context).brightness == Brightness.light
        ? lnAlerts?.lightTheme
        : lnAlerts?.darkTheme;
    final padding = EdgeInsets.all(8);

    final notificationAlerts = _alerts[WidgetTypes.notification]!;
    final rectangularAlerts = _alerts[WidgetTypes.rectangular]!;

    final notificationAlertsConfig = lnAlerts?.notificationAlertDefaults;
    final rectangularAlertsConfig = lnAlerts?.rectangularAlertDefaults;

    return [
      ...passedChildren,
      if (rectangularAlerts.isNotEmpty)
        Container(
          color: theme?.themeFor(rectangularAlerts.last.type).scrimColor,
        ),
      if (notificationAlerts.isNotEmpty)
        Container(
          padding: notificationAlertsConfig?.insets,
          alignment: notificationAlertsConfig?.alignment,
          child: SpacedColumn(
            mainAxisSize: MainAxisSize.min,
            spacing: 4,
            children: [
              for (var alert in notificationAlerts)
                NotificationAlert(
                  alert: alert,
                  config: notificationAlertsConfig,
                ),
            ],
          ),
        ),
      if (rectangularAlerts.isNotEmpty)
        for (var alert in rectangularAlerts)
          Container(
            alignment: Alignment.center,
            padding: padding,
            child: RectangularAlert(
              alert: alert,
              config: rectangularAlertsConfig,
            ),
          ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return LnAlertContainer(
      data: this,
      child: Builder(
        builder: (context) {
          final passedChildren = widget.childrenBuilder(context);
          final mergedChildren = widget.type == ContainerTypes.column
              ? _buildColumnChildren(context, passedChildren)
              : _buildStackChildren(context, passedChildren);
          return widget.builder(context, mergedChildren);
        },
      ),
    );
  }
}
