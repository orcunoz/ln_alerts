import 'package:flutter/material.dart';

import 'container.dart';
import 'models/alert_type.dart';
import 'models/display_type.dart';
import 'models/user_friendly_alert.dart';
import 'widgets/action_button.dart';

class LnAlert {
  const LnAlert({
    required this.type,
    this.title,
    this.message,
    this.icon,
    this.buttons = const [LnAlertActionButton.remove()],
  }); // : assert(type != null || message != null);

  final AlertType type;
  final String? title;
  final String? message;
  final IconData? icon;
  final List<LnAlertActionButton> buttons;

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
      : this(
          type: data.type,
          title: data.title,
          message: data.message,
        );

  factory LnAlert.successAutoDetect(dynamic data) {
    UserFriendlyAlert? userFriendly;

    if (data is UserFriendlyAlertOwner) {
      userFriendly = data.userFriendlyAlert;
    } else if (data is UserFriendlyAlert) {
      userFriendly = data;
    }

    return LnAlert.success(userFriendly?.message, title: userFriendly?.title);
  }

  factory LnAlert.errorAutoDetect(dynamic data) {
    UserFriendlyAlert? userFriendly = data is UserFriendlyAlertOwner
        ? data.userFriendlyAlert
        : data is UserFriendlyAlert
            ? data
            : null;

    return LnAlert.error(userFriendly?.message, title: userFriendly?.title);
  }

  void showAt(
    BuildContext context, {
    AlertDisplayType? displayType,
    Duration? duration = const Duration(seconds: 10),
    Object? unique,
  }) =>
      LnAlerts.of(context).show(
        this,
        duration: duration,
        displayType: displayType,
        unique: unique,
      );
}
