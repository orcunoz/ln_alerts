import 'package:ln_alerts/ln_alerts.dart';
import "package:stack_trace/stack_trace.dart";
import 'package:flutter/material.dart';
import 'package:ln_core/ln_core.dart';

import '../alert.dart';
import '../container.dart';
import '../models/display_type.dart';

extension LnAlertFutureExtensions<T> on Future<T> {
  /*Future<T> manageAlerts(
    BuildContext context, {
    Duration? duration,
    AlertDisplayType? displayType,
  }) {
    final unique = Trace.current().frames[1].toString();
    final container = LnAlerts.of(context);
    return _manageSuccessAlerts(
      container,
      duration: duration,
      displayType: displayType,
      unique: unique,
    )._manageErrorAlerts(
      container,
      duration: duration,
      displayType: displayType,
      unique: unique,
    );
  }

  Future<T> manageSuccessAlerts(
    BuildContext context, {
    Duration? duration,
    AlertDisplayType? displayType,
  }) {
    final unique = Trace.current().frames[1].toString();
    final container = LnAlerts.of(context);
    return _manageSuccessAlerts(
      container,
      duration: duration,
      displayType: displayType,
      unique: unique,
    );
  }

  Future<T> manageErrorAlerts(
    BuildContext context, {
    Duration? duration,
    AlertDisplayType? displayType,
  }) {
    final unique = Trace.current().frames[1].toString();
    final container = LnAlerts.of(context);
    return _manageErrorAlerts(
      container,
      duration: duration,
      displayType: displayType,
      unique: unique,
    );
  }

  Future<T> manageProgressIndicator(BuildContext context) {
    return _manageProgressIndicator(
      LnAlerts.of(context),
      unique: Trace.current().frames[1].toString(),
    );
  }*/

  Future<T> _manageProgressIndicator(
    LnAlertsController controller, {
    required Object unique,
  }) {
    controller.notifyProgressing(true, unique);
    return whenComplete(() {
      controller.notifyProgressing(false, unique);
    });
  }

  Future<T> _manageSuccessAlerts(
    LnAlertsController controller, {
    Duration? duration = const Duration(seconds: 10),
    AlertDisplayType? displayType,
    Object? unique,
  }) {
    if (unique != null) controller.removeAlert(unique);

    return then((value) {
      controller.show(
        LnAlert.successAutoDetect(value),
        duration: duration,
        displayType: displayType,
        unique: unique,
      );
      return value;
    });
  }

  Future<T> _manageErrorAlerts(
    LnAlertsController controller, {
    Duration? duration = const Duration(seconds: 10),
    AlertDisplayType? displayType,
    List<LnAlertActionButton> buttons = const [LnAlertActionButton.remove()],
    Object? unique,
  }) {
    if (unique != null) controller.removeAlert(unique);

    return catchError((error, stackTrace) {
      Log.e(error, stackTrace: stackTrace);
      controller.show(
        LnAlert.errorAutoDetect(error),
        duration: duration,
        displayType: displayType,
        buttons: buttons,
        unique: unique,
      );
      throw error;
    });
  }

  Future<T> manageFetchOperation(
    BuildContext context, {
    bool error = true,
    bool success = false,
    bool progress = true,
    void Function()? retry,
    Duration? errorDuration,
    AlertDisplayType? errorDisplayType = AlertDisplayType.popup,
    Duration? successDuration,
    AlertDisplayType? successDisplayType,
  }) =>
      setManager(
        LnAlerts.of(context),
        error: error,
        success: success,
        progress: progress,
        errorDuration: errorDuration,
        errorDisplayType: errorDisplayType,
        errorAlertButtons: [
          if (retry != null)
            LnAlertActionButton(
              icon: Icons.refresh,
              text: LnLocalizations.current.refresh,
              onPressed: retry,
            ),
        ],
        successDuration: successDuration,
        successDisplayType: successDisplayType,
      );

  Future<T> manageSubmitOperation(
    BuildContext context, {
    bool error = true,
    bool success = true,
    bool progress = true,
    Duration? errorDuration,
    AlertDisplayType? errorDisplayType = AlertDisplayType.flat,
    Duration? successDuration,
    AlertDisplayType? successDisplayType = AlertDisplayType.flat,
  }) =>
      setManager(
        LnAlerts.of(context),
        error: error,
        success: success,
        progress: progress,
        errorDuration: errorDuration,
        errorDisplayType: errorDisplayType,
        successDuration: successDuration,
        successDisplayType: successDisplayType,
      );

  Future<T> setManager(
    LnAlertsController controller, {
    bool error = false,
    bool success = false,
    bool progress = false,
    Duration? errorDuration,
    AlertDisplayType? errorDisplayType,
    List<LnAlertActionButton> errorAlertButtons = const [
      LnAlertActionButton.remove()
    ],
    Duration? successDuration,
    AlertDisplayType? successDisplayType,
  }) {
    final unique = Trace.current().frames[1].toString();
    Future<T> future = this;

    if (error) {
      future = future._manageErrorAlerts(
        controller,
        duration: errorDuration,
        displayType: errorDisplayType,
        unique: unique,
        buttons: errorAlertButtons,
      );
    }

    if (success) {
      future = future._manageSuccessAlerts(
        controller,
        duration: successDuration,
        displayType: successDisplayType,
        unique: unique,
      );
    }

    if (progress) {
      future = future._manageProgressIndicator(
        controller,
        unique: unique,
      );
    }

    return future;
  }
}
