import 'package:flutter/material.dart';
import 'package:ln_alerts/src/style/alert_decoration.dart';

import 'container.dart';
import 'models/alert_types.dart';
import 'models/user_friendly_alert.dart';
import 'models/widget_types.dart';
import 'widgets/action_button.dart';

class LnAlert {
  final AlertTypes type;
  final String? title;
  final String? message;
  final IconData? icon;
  final List<LnAlertActionButton> buttons;
  final LnAlertDecoration? decoration;

  const LnAlert._({
    required this.type,
    this.title,
    this.message,
    this.icon,
    this.buttons = const [],
    this.decoration,
  });

  const LnAlert({
    this.title,
    required String this.message,
    this.icon,
    this.buttons = const [],
    this.decoration,
  }) : type = AlertTypes.custom;

  const LnAlert.byType({
    required AlertTypes type,
    String? title,
    required String message,
    IconData? icon,
    List<LnAlertActionButton> buttons = const [],
  }) : this._(
          type: type,
          title: title,
          message: message,
          icon: icon,
          buttons: buttons,
        );

  const LnAlert.info(
    String message, {
    String? title,
    IconData? icon,
    List<LnAlertActionButton> buttons = const [],
  }) : this._(
          type: AlertTypes.info,
          title: title,
          message: message,
          icon: icon,
          buttons: buttons,
        );

  const LnAlert.success(
    String message, {
    String? title,
    IconData? icon,
    List<LnAlertActionButton> buttons = const [],
  }) : this._(
          type: AlertTypes.success,
          title: title,
          message: message,
          icon: icon,
          buttons: buttons,
        );

  const LnAlert.warning(
    String message, {
    String? title,
    IconData? icon,
    List<LnAlertActionButton> buttons = const [],
  }) : this._(
          type: AlertTypes.warning,
          title: title,
          message: message,
          icon: icon,
          buttons: buttons,
        );

  const LnAlert.error(
    String message, {
    String? title,
    IconData? icon,
    List<LnAlertActionButton> buttons = const [],
  }) : this._(
          type: AlertTypes.error,
          title: title,
          message: message,
          icon: icon,
          buttons: buttons,
        );

  LnAlert.userFriendly(
    UserFriendlyAlert data, {
    List<LnAlertActionButton> buttons = const [],
  }) : this.byType(
          type: data.alertData.type,
          title: data.alertData.title,
          message: data.alertData.message,
          buttons: buttons,
        );

  factory LnAlert.successAutoDetect(
    dynamic data, {
    List<LnAlertActionButton> buttons = const [],
  }) =>
      data != null && data is UserFriendlyAlert
          ? LnAlert.userFriendly(
              data,
              buttons: buttons,
            )
          : LnAlert._(
              type: AlertTypes.success,
              buttons: buttons,
            );

  factory LnAlert.errorAutoDetect(
    dynamic data, {
    List<LnAlertActionButton> buttons = const [],
  }) =>
      data != null && data is UserFriendlyAlert
          ? LnAlert.userFriendly(
              data,
              buttons: buttons,
            )
          : LnAlert._(
              type: AlertTypes.error,
              buttons: buttons,
            );

  void showAt(
    BuildContext context, {
    WidgetTypes? widgetType,
    Duration? duration,
    Object? alertUnique,
  }) =>
      LnAlertContainer.of(context).show(
        this,
        duration: duration,
        widgetType: widgetType,
        alertUnique: alertUnique,
      );
}
