import 'package:flutter/material.dart';
import 'package:ln_core/ln_core.dart';

import '../alert.dart';
import '../host.dart';
import '../models/alert_position.dart';

extension LnAlertFutureExtensions<T> on Future<T> {
  Future<T> manageAlerts(BuildContext context, {AlertPosition? position}) {
    final host = LnAlerts.of(context);
    return this
      .._manageSuccessAlerts(host, position ?? host.widget.defaultPosition)
      .._manageErrorAlerts(host, position ?? host.widget.defaultPosition);
  }

  Future<T> manageSuccessAlerts(BuildContext context,
      {AlertPosition? position}) {
    final host = LnAlerts.of(context);
    return _manageSuccessAlerts(host, position ?? host.widget.defaultPosition);
  }

  Future<T> manageErrorAlerts(BuildContext context, {AlertPosition? position}) {
    final host = LnAlerts.of(context);
    return _manageErrorAlerts(host, position ?? host.widget.defaultPosition);
  }

  Future<T> _manageSuccessAlerts(
      LnAlertHostState host, AlertPosition position) {
    return this
      ..then((value) {
        host.show(LnAlert.successAutoDetect(value), position: position);
        return value;
      });
  }

  Future<T> _manageErrorAlerts(LnAlertHostState host, AlertPosition position) {
    return this
      ..catchError((error, stackTrace) {
        Log.e(error, stackTrace: stackTrace);
        host.show(LnAlert.errorAutoDetect(error), position: position);
        throw error;
      });
  }
}
