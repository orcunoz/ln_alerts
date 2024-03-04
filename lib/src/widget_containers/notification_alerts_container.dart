part of '../container.dart';

class NotificationAlertsContainer
    extends _AlertsContainer<NotificationAlertDecoration> {
  const NotificationAlertsContainer._({
    required this.settings,
    required super.alertDecoration,
    required super.scopeController,
    required super.primary,
    required super.root,
  }) : super(displayType: AlertDisplayType.notification);

  final NotificationAlertsContainerSettings settings;

  @override
  Widget buildContainer(
    ThemeData theme,
    NotificationAlertDecoration alertDecoration,
    List<AlertRegistry> alertRegistries,
  ) {
    return Align(
      alignment: settings.alignment,
      child: Container(
        padding: settings.insets,
        alignment: settings.alignment,
        constraints: BoxConstraints(
          maxWidth: settings.width,
        ),
        child: SpacedColumn(
          mainAxisSize: MainAxisSize.min,
          spacing: settings.spacing,
          children: [
            for (var registry in alertRegistries)
              NotificationAlert(
                alert: registry.alert,
                decoration: alertDecoration,
                buttons: registry.buttons,
              ),
          ],
        ),
      ),
    );
  }
}
