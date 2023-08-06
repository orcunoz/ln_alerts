import 'package:flutter/material.dart';

import 'host.dart';
import 'models/alert_widgets.dart';
import 'models/user_friendly_alert.dart';
import 'models/widget_types.dart';

class LnAlert {
  final AlertType? type;
  final String? title;
  final String? message;
  final IconData? icon;

  const LnAlert._({
    required this.type,
    this.title,
    this.message,
    this.icon,
  });

  const LnAlert({
    this.title,
    required String this.message,
    this.icon,
  }) : type = null;

  const LnAlert.byType({
    required AlertType type,
    String? title,
    required String message,
    IconData? icon,
  }) : this._(
          type: type,
          title: title,
          message: message,
          icon: icon,
        );

  const LnAlert.info(
    String? message, {
    String? title,
    IconData? icon,
  }) : this._(
          type: AlertType.info,
          title: title,
          message: message,
          icon: icon,
        );

  const LnAlert.success(
    String? message, {
    String? title,
    IconData? icon,
  }) : this._(
          type: AlertType.success,
          title: title,
          message: message,
          icon: icon,
        );

  const LnAlert.warning(
    String? message, {
    String? title,
    IconData? icon,
  }) : this._(
          type: AlertType.warning,
          title: title,
          message: message,
          icon: icon,
        );

  const LnAlert.error(
    String? message, {
    String? title,
    IconData? icon,
  }) : this._(
          type: AlertType.error,
          title: title,
          message: message,
          icon: icon,
        );

  LnAlert.userFriendly(UserFriendlyAlert data)
      : this.userFriendlyData(data.alertData);

  LnAlert.userFriendlyData(UserFriendlyAlertData data)
      : this.byType(
          type: data.type,
          title: data.title,
          message: data.message,
        );

  factory LnAlert.successAutoDetect(dynamic data) =>
      data != null && data is UserFriendlyAlert
          ? LnAlert.userFriendly(data)
          : data != null && data is UserFriendlyAlertData
              ? LnAlert.userFriendlyData(data)
              : LnAlert._(type: AlertType.success);

  factory LnAlert.errorAutoDetect(dynamic data) =>
      data != null && data is UserFriendlyAlert
          ? LnAlert.userFriendly(data)
          : data != null && data is UserFriendlyAlertData
              ? LnAlert.userFriendlyData(data)
              : LnAlert._(type: AlertType.error);

  void showAt(
    BuildContext context, {
    AlertWidgets? widgetType,
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
