import 'alert_type.dart';

mixin UserFriendlyAlert {
  UserFriendlyAlertData get alertData;
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
}
