part of 'alert_widget.dart';

class NotificationAlert extends LnAlertWidget<NotificationAlertDecoration> {
  const NotificationAlert({
    super.key,
    required super.alert,
    super.decoration,
    super.onTap,
    super.buttons = const [],
  }) : super(widgetType: AlertWidgets.notification);

  NotificationAlert.custom({
    super.key,
    required String message,
    String? title,
    IconData? icon,
    void Function()? onTap,
    List<LnAlertActionButton> buttons = const [],
    super.decoration,
  }) : super(
          alert: LnAlert(
            message: message,
            title: title,
            icon: icon,
          ),
          widgetType: AlertWidgets.notification,
          onTap: onTap,
          buttons: buttons,
        );

  NotificationAlert.byType({
    super.key,
    required AlertType type,
    required String message,
    String? title,
    IconData? icon,
    void Function()? onTap,
    List<LnAlertActionButton> buttons = const [],
    super.decoration,
  }) : super(
          alert: LnAlert.byType(
            type: type,
            message: message,
            title: title,
            icon: icon,
          ),
          widgetType: AlertWidgets.notification,
          onTap: onTap,
          buttons: buttons,
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

    child = SpacedRow(
      spacing: 8,
      children: [
        Icon(decoration.icon, color: decoration.gaugesColor),
        Expanded(child: child),
        ...getEffectiveButtons(decoration.gaugesColor),
      ],
    );

    return _buildContainer(decoration, child);
  }
}
