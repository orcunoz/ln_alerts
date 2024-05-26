part of '../container.dart';

class FlatAlertsContainer extends _AlertsContainer<FlatAlertDecoration> {
  const FlatAlertsContainer._({
    required super.alertDecoration,
    required super.scopeController,
    required super.primary,
    required this.settings,
    required super.root,
  }) : super(displayType: AlertDisplayType.flat);

  final FlatAlertsContainerSettings settings;

  @override
  Widget buildContainer(ThemeData theme, FlatAlertDecoration alertDecoration,
      List<AlertRegistry> alertRegistries) {
    final alertWidgets = [
      for (final registry in alertRegistries)
        FlatAlert(
          alert: registry.alert,
          decoration: alertDecoration,
          buttons: registry.buttons,
          position: settings.position,
        ),
    ];

    final divider = settings.dividerWidth != null && settings.dividerWidth != 0
        ? PrecisionDivider(
            color: settings.borderSide == BorderSide.none
                ? Colors.transparent
                : settings.borderSide.color,
            height: settings.dividerWidth,
          )
        : null;

    Widget child = divider != null
        ? SeparatedColumn(
            separator: divider,
            children: alertWidgets,
          )
        : Column(
            children: alertWidgets,
          );

    child = ClipRRect(
      borderRadius: settings.borderRadius,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: settings.borderRadius,
          border: Border.fromBorderSide(settings.borderSide),
        ),
        child: child,
      ),
    );

    if (alertRegistries.isNotEmpty && settings.margin != null) {
      child = Padding(
        padding: settings.margin!,
        child: child,
      );
    }

    return child;
  }
}
