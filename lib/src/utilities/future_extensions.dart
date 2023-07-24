import "package:stack_trace/stack_trace.dart";
import 'package:flutter/material.dart';
import 'package:ln_core/ln_core.dart';

import '../alert.dart';
import '../container.dart';
import '../models/widget_types.dart';

extension LnAlertFutureExtensions<T> on Future<T> {
  Future<T> manageAlerts(
    BuildContext context, {
    Duration? duration,
    WidgetTypes? widgetType,
  }) {
    final alertUnique = Trace.current().frames[1].toString();
    final container = LnAlertContainer.of(context);
    return this
      .._manageSuccessAlerts(
        container,
        duration: duration,
        widgetType: widgetType,
        alertUnique: alertUnique,
      )
      .._manageErrorAlerts(
        container,
        duration: duration,
        widgetType: widgetType,
        alertUnique: alertUnique,
      );
  }

  Future<T> manageSuccessAlerts(
    BuildContext context, {
    Duration? duration,
    WidgetTypes? widgetType,
  }) {
    final alertUnique = Trace.current().frames[1].toString();
    final container = LnAlertContainer.of(context);
    return _manageSuccessAlerts(
      container,
      duration: duration,
      widgetType: widgetType,
      alertUnique: alertUnique,
    );
  }

  Future<T> manageErrorAlerts(
    BuildContext context, {
    Duration? duration,
    WidgetTypes? widgetType,
  }) {
    final alertUnique = Trace.current().frames[1].toString();
    final container = LnAlertContainer.of(context);
    return _manageErrorAlerts(
      container,
      duration: duration,
      widgetType: widgetType,
      alertUnique: alertUnique,
    );
  }

  Future<T> _manageSuccessAlerts(
    LnAlertContainerState host, {
    Duration? duration,
    WidgetTypes? widgetType,
    Object? alertUnique,
  }) {
    host.clearAlertsByUnique(alertUnique);

    return this
      ..then((value) {
        host.show(
          LnAlert.successAutoDetect(value),
          duration: duration,
          widgetType: widgetType,
          alertUnique: alertUnique,
        );
        return value;
      });
  }

  Future<T> _manageErrorAlerts(
    LnAlertContainerState host, {
    Duration? duration,
    WidgetTypes? widgetType,
    Object? alertUnique,
  }) {
    host.clearAlertsByUnique(alertUnique);

    return this
      ..catchError((error, stackTrace) {
        Log.e(error, stackTrace: stackTrace);
        host.show(
          LnAlert.errorAutoDetect(error),
          duration: duration,
          widgetType: widgetType,
          alertUnique: alertUnique,
        );
        throw error;
      });
  }
}
