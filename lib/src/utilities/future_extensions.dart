import "package:stack_trace/stack_trace.dart";
import 'package:flutter/material.dart';
import 'package:ln_core/ln_core.dart';

import '../alert.dart';
import '../host.dart';
import '../models/widget_types.dart';

extension LnAlertFutureExtensions<T> on Future<T> {
  Future<T> manageAlerts(
    BuildContext context, {
    Duration? duration,
    AlertWidgets? widgetType,
  }) {
    final alertUnique = Trace.current().frames[1].toString();
    final container = LnAlertHost.of(context);
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
    AlertWidgets? widgetType,
  }) {
    final alertUnique = Trace.current().frames[1].toString();
    final container = LnAlertHost.of(context);
    return this
      .._manageSuccessAlerts(
        container,
        duration: duration,
        widgetType: widgetType,
        alertUnique: alertUnique,
      );
  }

  Future<T> manageErrorAlerts(
    BuildContext context, {
    Duration? duration,
    AlertWidgets? widgetType,
  }) {
    final alertUnique = Trace.current().frames[1].toString();
    final container = LnAlertHost.of(context);
    return this
      .._manageErrorAlerts(
        container,
        duration: duration,
        widgetType: widgetType,
        alertUnique: alertUnique,
      );
  }

  Future<T> manageProgressIndicator(BuildContext context) {
    final progressUnique = Trace.current().frames[1].toString();
    final container = LnAlertHost.of(context);
    container.addProgress(progressUnique);
    return this..whenComplete(() => container.removeProgress(progressUnique));
  }

  Future<T> _manageSuccessAlerts(
    LnAlertHostState host, {
    Duration? duration,
    AlertWidgets? widgetType,
    Object? alertUnique,
  }) {
    host.removeByUnique(alertUnique);
    Log.colored("_manageSuccessAlerts", alertUnique.toString());

    return this
      ..then((value) {
        host.show(
          LnAlert.successAutoDetect(value),
          duration: duration,
          widgetType: widgetType,
          unique: alertUnique,
        );
        return value;
      });
  }

  Future<T> _manageErrorAlerts(
    LnAlertHostState host, {
    Duration? duration,
    AlertWidgets? widgetType,
    Object? alertUnique,
  }) {
    host.removeByUnique(alertUnique);
    Log.colored("_manageSuccessAlerts", alertUnique.toString());

    return this
      ..catchError((error, stackTrace) {
        Log.e(error, stackTrace: stackTrace);
        host.show(
          LnAlert.errorAutoDetect(error),
          duration: duration,
          widgetType: widgetType,
          unique: alertUnique,
        );
        throw error;
      });
  }
}
