import 'alert_type.dart';

abstract class UserFriendlyAlertOwner {
  UserFriendlyAlert get userFriendlyAlert;

  @override
  String toString() => "UserFriendlyAlert: $userFriendlyAlert";
}

class UserFriendlyAlert {
  const UserFriendlyAlert({
    this.title,
    required this.message,
    required this.type,
  });

  final String? title;
  final String message;
  final AlertType type;

  static String autoDetectMessage(Object? data, String ifNot) =>
      data is UserFriendlyAlert
          ? data.message
          : data is UserFriendlyAlertOwner
              ? data.userFriendlyAlert.message
              : ifNot;

  @override
  String toString() => "($type) ${title == null ? "" : "$title: "}$message";
}
