import 'package:flutter/material.dart';

import 'host.dart';
import 'models/alert_type.dart';
import 'models/alert_widget.dart';
import 'models/user_friendly_alert.dart';

class LnAlert {
  final AlertType? type;
  final String? title;
  final String? message;
  final IconData? icon;

  const LnAlert({
    this.type,
    this.title,
    this.message,
    this.icon,
  }) : assert(type != null || message != null);

  const LnAlert.info(
    String? message, {
    String? title,
    IconData? icon,
  }) : this(
          type: AlertType.info,
          title: title,
          message: message,
          icon: icon,
        );

  const LnAlert.success(
    String? message, {
    String? title,
    IconData? icon,
  }) : this(
          type: AlertType.success,
          title: title,
          message: message,
          icon: icon,
        );

  const LnAlert.warning(
    String? message, {
    String? title,
    IconData? icon,
  }) : this(
          type: AlertType.warning,
          title: title,
          message: message,
          icon: icon,
        );

  const LnAlert.error(
    String? message, {
    String? title,
    IconData? icon,
  }) : this(
          type: AlertType.error,
          title: title,
          message: message,
          icon: icon,
        );

  LnAlert.userFriendly(UserFriendlyAlert data)
      : this.userFriendlyData(data.alertData);

  LnAlert.userFriendlyData(UserFriendlyAlertData data)
      : this(
          type: data.type,
          title: data.title,
          message: data.message,
        );

  factory LnAlert.successAutoDetect(dynamic data) =>
      data != null && data is UserFriendlyAlert
          ? LnAlert.userFriendly(data)
          : data != null && data is UserFriendlyAlertData
              ? LnAlert.userFriendlyData(data)
              : LnAlert(type: AlertType.success);

  factory LnAlert.errorAutoDetect(dynamic data) =>
      data != null && data is UserFriendlyAlert
          ? LnAlert.userFriendly(data)
          : data != null && data is UserFriendlyAlertData
              ? LnAlert.userFriendlyData(data)
              : LnAlert(type: AlertType.error);

  void showAt(
    BuildContext context, {
    AlertWidget? widgetType,
    Duration? duration,
    Object? unique,
  }) =>
      LnAlertHost.of(context).show(
        this,
        duration: duration,
        widgetType: widgetType,
        unique: unique,
      );
}
