import 'package:flutter/material.dart';
import 'package:ln_core/ln_core.dart';

import '../alert.dart';
import '../container.dart';

extension LnAlertFutureExtensions<T> on Future<T> {
  Future<T> manageAlerts(BuildContext context) {
    final container = LnAlertContainer.of(context);
    return this
      .._manageSuccessAlerts(container)
      .._manageErrorAlerts(container);
  }

  Future<T> manageSuccessAlerts(BuildContext context) {
    final container = LnAlertContainer.of(context);
    return _manageSuccessAlerts(container);
  }

  Future<T> manageErrorAlerts(BuildContext context) {
    final container = LnAlertContainer.of(context);
    return _manageErrorAlerts(container);
  }

  Future<T> _manageSuccessAlerts(LnAlertContainerState host) {
    return this
      ..then((value) {
        host.show(LnAlert.successAutoDetect(value));
        return value;
      });
  }

  Future<T> _manageErrorAlerts(LnAlertContainerState host) {
    return this
      ..catchError((error, stackTrace) {
        Log.e(error, stackTrace: stackTrace);
        host.show(LnAlert.errorAutoDetect(error));
        throw error;
      });
  }
}
