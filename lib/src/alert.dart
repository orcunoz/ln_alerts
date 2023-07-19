// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'host.dart';
import 'models/action_button.dart';
import 'models/alert_position.dart';
import 'models/alert_type.dart';
import 'models/user_friendly_alert.dart';

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
    bool? colorFilled,
    List<LnAlertActionButton> buttons = const [],
  }) : this._(
          type: type,
          title: title,
          message: message,
          colorFilled: colorFilled,
          buttons: buttons,
        );

  const LnAlert.info(
    String message, {
    String? title,
    bool? colorFilled,
    List<LnAlertActionButton> buttons = const [],
  }) : this._(
          type: AlertType.info,
          title: title,
          message: message,
          colorFilled: colorFilled,
          buttons: buttons,
        );

  const LnAlert.success(
    String message, {
    String? title,
    bool? colorFilled,
    List<LnAlertActionButton> buttons = const [],
  }) : this._(
          type: AlertType.success,
          title: title,
          message: message,
          colorFilled: colorFilled,
          buttons: buttons,
        );

  const LnAlert.warning(
    String message, {
    String? title,
    bool? colorFilled,
    List<LnAlertActionButton> buttons = const [],
  }) : this._(
          type: AlertType.warning,
          title: title,
          message: message,
          colorFilled: colorFilled,
          buttons: buttons,
        );

  const LnAlert.error(
    String message, {
    String? title,
    bool? colorFilled,
    List<LnAlertActionButton> buttons = const [],
  }) : this._(
          type: AlertType.error,
          title: title,
          message: message,
          colorFilled: colorFilled,
          buttons: buttons,
        );

  LnAlert.userFriendly(
    UserFriendlyAlert data, {
    bool? colorFilled,
    List<LnAlertActionButton> buttons = const [],
  }) : this.byType(
          type: data.alertData.type,
          title: data.alertData.title,
          message: data.alertData.message,
          colorFilled: colorFilled,
          buttons: buttons,
        );

  factory LnAlert.successAutoDetect(
    dynamic data, {
    bool? colorFilled,
    List<LnAlertActionButton> buttons = const [],
  }) =>
      data != null && data is UserFriendlyAlert
          ? LnAlert.userFriendly(
              data,
              colorFilled: colorFilled,
              buttons: buttons,
            )
          : LnAlert._(
              type: AlertType.success,
              colorFilled: colorFilled,
              buttons: buttons,
            );

  factory LnAlert.errorAutoDetect(
    dynamic data, {
    bool? colorFilled,
    List<LnAlertActionButton> buttons = const [],
  }) =>
      data != null && data is UserFriendlyAlert
          ? LnAlert.userFriendly(
              data,
              colorFilled: colorFilled,
              buttons: buttons,
            )
          : LnAlert._(
              type: AlertType.error,
              colorFilled: colorFilled,
              buttons: buttons,
            );

  void showAt(
    BuildContext context, {
    Duration? duration,
    AlertPosition? position,
  }) =>
      LnAlertManager.of(context)
          .show(this, duration: duration, position: position);

  LnAlert copyWith({
    AlertType? type,
    String? title,
    String? message,
    IconData? icon,
    Color? lightAccentColor,
    Color? darkAccentColor,
    Color? lightSecondaryColor,
    Color? darkSecondaryColor,
    bool? colorFilled,
    List<LnAlertActionButton>? buttons,
  }) {
    return LnAlert._(
      type: type ?? this.type,
      title: title ?? this.title,
      message: message ?? this.message,
      icon: icon ?? this.icon,
      lightAccentColor: lightAccentColor ?? this.lightAccentColor,
      darkAccentColor: darkAccentColor ?? this.darkAccentColor,
      lightSecondaryColor: lightSecondaryColor ?? this.lightSecondaryColor,
      darkSecondaryColor: darkSecondaryColor ?? this.darkSecondaryColor,
      colorFilled: colorFilled ?? this.colorFilled,
      buttons: buttons ?? this.buttons,
    );
  }
}
