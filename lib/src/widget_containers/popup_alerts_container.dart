part of '../container.dart';

class PopupAlertsContainer extends _AlertsContainer<PopupAlertDecoration> {
  const PopupAlertsContainer._({
    required super.alertDecoration,
    required super.scopeController,
    required super.primary,
    required super.root,
  }) : super(displayType: AlertDisplayType.popup);

  @override
  Widget buildContainer(
    ThemeData theme,
    PopupAlertDecoration alertDecoration,
    List<AlertRegistry> alertRegistries,
  ) {
    final children = [
      for (var registry in alertRegistries)
        Positioned.fill(
          child: Center(
            child: PopupAlert(
              alert: registry.alert,
              decoration: alertDecoration,
              buttons: registry.buttons,
            ),
          ),
        ),
    ];

    if (children.isNotEmpty) {
      children.insert(
        children.length - 1,
        Positioned.fill(
          child: ColoredBox(
            color: theme.alertsTheme
                .colorsOf(alertRegistries.last.alert.type)
                .background
                .withOpacity(.2),
            /* theme.alertsTheme.scrimColor ??
                theme.colorScheme.scrim.withOpacity(.1) */
          ),
        ),
      );
    }

    return Stack(children: children);
  }
}
