part of '../container.dart';

abstract class _AlertsContainer<D extends WidgetDecoration>
    extends StatefulWidget {
  const _AlertsContainer({
    super.key,
    required this.alertDecoration,
    required this.displayType,
    required this.scopeController,
    required this.primary,
    required this.root,
  });

  final D? alertDecoration;
  final AlertDisplayType displayType;
  final bool primary;
  final LnAlertsController scopeController;
  final bool root;

  Widget buildContainer(
    ThemeData theme,
    D alertDecoration,
    List<AlertRegistry> alertRegistries,
  );

  @override
  State<_AlertsContainer> createState() => _AlertsContainerState();
}

class _AlertsContainerState extends LnState<_AlertsContainer> {
  bool enabled = true;

  @override
  void initState() {
    super.initState();

    widget.scopeController._register(this);
  }

  @override
  void didUpdateWidget(covariant _AlertsContainer<WidgetDecoration> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.scopeController != oldWidget.scopeController) {
      oldWidget.scopeController._unregister(this);
      widget.scopeController._register(this);
    }
  }

  @override
  void dispose() {
    super.dispose();

    widget.scopeController._unregister(this);
  }

  @override
  Widget build(BuildContext context) {
    return enabled
        ? ListenableBuilder(
            listenable: widget.scopeController,
            builder: (context, child) => widget.buildContainer(
              theme,
              widget.alertDecoration ??
                  theme.alertsTheme.decorationOf(widget.displayType),
              widget.scopeController._alertsOf(this),
            ),
          )
        : SizedBox.shrink();
  }
}
