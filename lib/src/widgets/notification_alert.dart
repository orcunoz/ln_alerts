part of 'alert_widget.dart';

class NotificationAlert extends LnAlertWidget<NotificationAlertDecoration> {
  const NotificationAlert({
    super.key,
    required super.alert,
    super.decoration,
    super.onTap,
    super.buttons = const [],
  }) : super(displayType: AlertDisplayType.notification);

  NotificationAlert.custom({
    super.key,
    required String message,
    String? title,
    IconData? icon,
    super.onTap,
    super.buttons = const [],
    super.decoration,
  }) : super(
          alert: LnAlert(
            type: AlertType.info,
            message: message,
            title: title,
            icon: icon,
          ),
          displayType: AlertDisplayType.notification,
        );

  NotificationAlert.byType({
    super.key,
    required AlertType type,
    required String? message,
    String? title,
    IconData? icon,
    super.onTap,
    super.buttons = const [],
    super.decoration,
  }) : super(
          alert: LnAlert(
            type: type,
            message: message,
            title: title,
            icon: icon,
          ),
          displayType: AlertDisplayType.notification,
        );

  @override
  Widget build(BuildContext context) {
    final decoration = _prepareDecoration(context);

    Widget child = decoration.textWidget;
    if (decoration.titleWidget != null) {
      child = SpacedColumn(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 2,
        children: [
          decoration.titleWidget!,
          child,
        ],
      );
    }

    child = ButtonTheme(
      minWidth: kMinInteractiveDimension,
      child: Row(
        children: [
          Icon(decoration.icon, color: decoration.gaugesColor),
          SizedBox(width: 10),
          Expanded(child: child),
          SizedBox(width: math.max(8, decoration.padding.right)),
          ...getEffectiveButtons(decoration.gaugesColor),
        ],
      ),
    );

    if (decoration.padding != EdgeInsets.zero) {
      child = Padding(
        padding: decoration.padding.copyWith(right: 0),
        child: child,
      );
    }

    return _buildContainer(context, decoration, child);
  }
}
