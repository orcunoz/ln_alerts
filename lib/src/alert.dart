import 'package:flutter/material.dart';
import 'package:ln_alerts/ln_alerts.dart';

class LnAlertActionButton {
  final String text;
  final void Function()? onPressed;
  const LnAlertActionButton(this.text, {this.onPressed});
}

class LnAlert {
  final AlertType type;
  final String? title;
  final String? message;
  final IconData? icon;
  final Color? lightAccentColor;
  final Color? darkAccentColor;
  final Color? lightSecondaryColor;
  final Color? darkSecondaryColor;
  final bool? colorFilled;
  final List<LnAlertActionButton> buttons;

  const LnAlert._({
    required this.type,
    this.title,
    this.message,
    this.icon,
    this.lightAccentColor,
    this.darkAccentColor,
    this.lightSecondaryColor,
    this.darkSecondaryColor,
    this.colorFilled,
    this.buttons = const [],
  });

  const LnAlert({
    this.title,
    required String this.message,
    required IconData this.icon,
    required Color this.lightAccentColor,
    required Color this.darkAccentColor,
    required Color this.lightSecondaryColor,
    required Color this.darkSecondaryColor,
    this.colorFilled,
    this.buttons = const [],
  }) : type = AlertType.custom;

  const LnAlert.byType({
    required AlertType type,
    String? title,
    required String message,
  }) : this._(type: type, title: title, message: message);

  const LnAlert.info(String message, {String? title})
      : this._(type: AlertType.info, title: title, message: message);

  const LnAlert.success(String message, {String? title})
      : this._(type: AlertType.success, title: title, message: message);

  const LnAlert.warning(String message, {String? title})
      : this._(type: AlertType.warning, title: title, message: message);

  const LnAlert.error(String message, {String? title})
      : this._(type: AlertType.error, title: title, message: message);

  LnAlert.userFriendly(UserFriendlyAlert data)
      : this.byType(
          type: data.alertData.type,
          title: data.alertData.title,
          message: data.alertData.message,
        );

  factory LnAlert.successAutoDetect(dynamic data) =>
      data != null && data is UserFriendlyAlert
          ? LnAlert.userFriendly(data)
          : LnAlert._(type: AlertType.success);

  factory LnAlert.errorAutoDetect(dynamic data) =>
      data != null && data is UserFriendlyAlert
          ? LnAlert.userFriendly(data)
          : LnAlert._(type: AlertType.error);

  void showAt(
    BuildContext context, {
    Duration? duration,
    AlertPosition? position,
  }) =>
      LnAlertManager.of(context)
          .show(this, duration: duration, position: position);
}
