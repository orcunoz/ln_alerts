import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ln_alerts/src/alert.dart';
import 'package:ln_core/ln_core.dart';

import 'models/display_type.dart';
import 'style/theme.dart';
import 'style/widget_decoration.dart';
import 'widgets/action_button.dart';
import 'widgets/alert_widget.dart';

import 'dart:math' as math;

part 'widget_containers/alerts_container.dart';
part 'widget_containers/flat_alerts_container.dart';
part 'widget_containers/notification_alerts_container.dart';
part 'widget_containers/popup_alerts_container.dart';

part 'controller.dart';

class LnAlerts extends InheritedWidget {
  const LnAlerts._({
    required this.controller,
    required super.child,
  });

  final LnAlertsController controller;
  static LnAlertsController? _rootController;
  static LnAlertsController get rootController =>
      _rootController ??= LnAlertsController();

  @override
  bool updateShouldNotify(LnAlerts oldWidget) =>
      controller != oldWidget.controller;

  static LnAlertsController of(BuildContext context) {
    return context.getInheritedWidgetOfExactType<LnAlerts>()?.controller ??
        rootController;
  }
}

class LnAlertsArea extends StatefulWidget {
  /*LnAlertsArea({
    super.key,
    required this.containers,
    required this.child,
    required this.debugLabel,
  })  : controller = null,
        _scope = false,
        manageProgress = false;*/

  LnAlertsArea.scope({
    super.key,
    this.controller,
    required this.containers,
    this.progressOverlay = true,
    this.progressView = progressIndicatorBox,
    required this.child,
  }) : _scope = true;

  final bool _scope;
  final LnAlertsController? controller;
  final List<AlertDisplayType> containers;
  final bool progressOverlay;
  final Widget progressView;
  final Widget child;

  static const progressIndicatorBox = Center(
    child: CircularProgressIndicator(),
  );
  static const linearProgressIndicator = Align(
    alignment: Alignment.topCenter,
    child: LinearProgressIndicator(),
  );

  static Widget flat({
    FlatAlertsContainerSettings? settings,
    bool primary = false,
  }) {
    return Builder(
      builder: (context) {
        final alertsTheme = Theme.of(context).alertsTheme;
        return FlatAlertsContainer._(
          settings: settings ?? alertsTheme.flatAlertsContainerSettings,
          alertDecoration: alertsTheme.flatAlertDecoration,
          scopeController: LnAlerts.of(context),
          primary: primary,
          root: false,
        );
      },
    );
  }

  static Widget notification({
    NotificationAlertsContainerSettings? settings,
    bool primary = false,
  }) {
    return Builder(
      builder: (context) {
        final alertsTheme = Theme.of(context).alertsTheme;
        return NotificationAlertsContainer._(
          settings: settings ?? alertsTheme.notificationAlertContainerSettings,
          alertDecoration: alertsTheme.notificationAlertDecoration,
          scopeController: LnAlerts.of(context),
          primary: primary,
          root: false,
        );
      },
    );
  }

  static Widget popup({bool primary = false}) {
    return Builder(
      builder: (context) {
        final alertsTheme = Theme.of(context).alertsTheme;
        return PopupAlertsContainer._(
          alertDecoration: alertsTheme.popupAlertDecoration,
          scopeController: LnAlerts.of(context),
          primary: primary,
          root: false,
        );
      },
    );
  }

  @override
  State<LnAlertsArea> createState() =>
      _scope ? _LnAlertsAreaScopeState() : _LnAlertsAreaState();
}

class _LnAlertsAreaScopeState extends _LnAlertsAreaState {
  late LnAlertsController? _internalController =
      widget.controller == null ? LnAlertsController() : null;
  LnAlertsController get controller {
    return widget.controller ?? _internalController!;
  }

  @override
  void didUpdateWidget(covariant LnAlertsArea oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.controller != oldWidget.controller) {
      if (oldWidget.controller == null) {
        _internalController!.dispose();
        _internalController = null;
      }

      if (widget.controller == null) {
        _internalController = LnAlertsController();
      }
    }
  }

  @override
  void dispose() {
    _internalController?.dispose();
    _internalController = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LnAlerts._(
      controller: controller,
      child: _buildInScope(context, controller),
    );
  }
}

class _LnAlertsAreaState extends State<LnAlertsArea> {
  static const _animationCurve = Curves.easeInOut;
  static const _animationDuration = Duration(milliseconds: 500);
  Size? _flatsContainerSize;

  late ThemeData _theme;
  late LnAlertsTheme _alertsTheme;

  late LnAlertsController? parent;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _theme = Theme.of(context);
    _alertsTheme = _theme.alertsTheme;
    parent = this is _LnAlertsAreaScopeState &&
            (this as _LnAlertsAreaScopeState).controller ==
                LnAlerts._rootController
        ? null
        : LnAlerts.of(context);
  }

  Widget _buildInScope(BuildContext context, LnAlertsController controller) {
    if (!widget.progressOverlay && widget.containers.isEmpty) {
      return widget.child;
    }

    final underInset =
        _alertsTheme.flatAlertsContainerSettings.insertingUnderContent;
    final flatsContainerHeight = _flatsContainerSize?.height ?? 0;

    Widget child = AnimatedPadding(
      duration: _animationDuration,
      curve: _animationCurve,
      padding: EdgeInsets.only(
        bottom: math.max(.0, flatsContainerHeight - underInset),
      ),
      child: widget.child,
    );

    return Stack(
      clipBehavior: Clip.none,
      children: [
        if (underInset == 0) child,
        if (widget.containers.contains(AlertDisplayType.flat))
          AnimatedPositioned(
            duration: _animationDuration,
            curve: _animationCurve,
            bottom: 0,
            left: 0,
            right: 0,
            height: flatsContainerHeight,
            child: UnconstrainedBox(
              alignment: Alignment.bottomCenter,
              constrainedAxis: Axis.horizontal,
              clipBehavior: Clip.hardEdge,
              child: Measurable(
                computedSize: _flatsContainerSize,
                onLayout: (size) => LnSchedulerCallbacks.endOfFrame(
                    () => setState(() => _flatsContainerSize = size)),
                child: FlatAlertsContainer._(
                  scopeController: controller,
                  settings: _alertsTheme.flatAlertsContainerSettings,
                  alertDecoration: _alertsTheme.flatAlertDecoration,
                  primary: widget.containers.first == AlertDisplayType.flat,
                  root: true,
                ),
              ),
            ),
          ),
        if (underInset != 0) child,
        if (widget.containers.contains(AlertDisplayType.notification))
          Positioned.fill(
            child: NotificationAlertsContainer._(
              scopeController: controller,
              settings: _alertsTheme.notificationAlertContainerSettings,
              alertDecoration: _alertsTheme.notificationAlertDecoration,
              primary: widget.containers.first == AlertDisplayType.notification,
              root: true,
            ),
          ),
        if (widget.containers.contains(AlertDisplayType.popup))
          Positioned.fill(
            child: PopupAlertsContainer._(
              scopeController: controller,
              alertDecoration: _alertsTheme.popupAlertDecoration,
              primary: widget.containers.first == AlertDisplayType.popup,
              root: true,
            ),
          ),
        if (widget.progressOverlay)
          Positioned.fill(
            child: ListenableBuilder(
              listenable: parent == null
                  ? controller.progressListenable
                  : Listenable.merge([
                      controller.progressListenable,
                      parent!.progressListenable,
                    ]),
              builder: (context, child) {
                return Visibility(
                  visible:
                      !(parent?.inProgress ?? false) && controller.inProgress,
                  child: child!,
                );
              },
              child: ColoredBox(
                color: _alertsTheme.scrimColor ??
                    _theme.colorScheme.scrim.withOpacity(.1),
                child: widget.progressView,
              ),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildInScope(context, LnAlerts.of(context));
  }
}
