part of '../container.dart';

class FlatAlertsContainer extends _AlertsContainer<FlatAlertDecoration> {
  const FlatAlertsContainer._({
    required super.alertDecoration,
    required super.scopeController,
    required super.primary,
    required this.settings,
    required super.root,
    this.safePadding,
  }) : super(displayType: AlertDisplayType.flat);

  final FlatAlertsContainerSettings settings;
  final EdgeInsets? safePadding;

  @override
  Widget buildContainer(ThemeData theme, FlatAlertDecoration alertDecoration,
      List<AlertRegistry> alertRegistries) {
    final alertWidgets = [
      for (final (index, registry) in alertRegistries.indexed)
        FlatAlert(
          alert: registry.alert,
          decoration: alertDecoration,
          buttons: registry.buttons,
          position: settings.position,
        ).copyWith(
          bottomPadding: (index == alertRegistries.length - 1)
              ? safePadding?.bottom ?? .0
              : .0,
        ),
    ];

    final divider = settings.dividerWidth != null && settings.dividerWidth != 0
        ? PrecisionDivider(
            color: settings.borderSide.color,
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

    if (settings.horizontalMargin != null) {
      child = Padding(
        padding: (safePadding ?? EdgeInsets.zero).copyWith(bottom: 0) +
            EdgeInsets.symmetric(horizontal: settings.horizontalMargin!),
        child: child,
      );
    }

    return child;
  }
}
