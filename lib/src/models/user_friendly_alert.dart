import 'alert_widgets.dart';

mixin UserFriendlyAlert {
  UserFriendlyAlertData get alertData;

  @override
  String toString() => "UserFriendlyAlert: $alertData";
}

final class UserFriendlyAlertData {
  final String? title;
  final String message;
  final AlertType type;

  const UserFriendlyAlertData({
    this.title,
    required this.message,
    required this.type,
  });

  @override
  String toString() => "($type) ${title == null ? "" : "$title: "}$message";
}
