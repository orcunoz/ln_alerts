import 'package:flutter/material.dart';
import 'package:ln_core/ln_core.dart';

import '../alert.dart';
import '../host.dart';

extension LnAlertFutureExtensions<T> on Future<T> {
  Future<T> manageAlerts(BuildContext context) {
    final host = LnAlertManager.of(context);
    return this
      .._manageSuccessAlerts(host)
      .._manageErrorAlerts(host);
  }

  Future<T> _manageSuccessAlerts(LnAlertHostState host) {
    return this
      ..then((value) {
        host.show(LnAlert.successAutoDetect(value));
        return value;
      });
  }

  Future<T> manageSuccessAlerts(BuildContext context) =>
      _manageSuccessAlerts(LnAlertManager.of(context));

  Future<T> _manageErrorAlerts(LnAlertHostState host) {
    return this
      ..catchError((error, stackTrace) {
        Log.e(error, stackTrace: stackTrace);
        host.show(LnAlert.errorAutoDetect(error));
        throw error;
      });
  }

  Future<T> manageErrorAlerts(BuildContext context) =>
      _manageErrorAlerts(LnAlertManager.of(context));
}
