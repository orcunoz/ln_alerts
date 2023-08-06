part of 'alert_widget.dart';

class FlatAlert extends LnAlertWidget<FlatAlertDecoration> {
  const FlatAlert({
    super.key,
    required super.alert,
    super.decoration,
    super.onTap,
    super.buttons = const [],
  }) : super(widgetType: AlertWidgets.flat);

  @override
  Widget build(BuildContext context) {
    final decoration = _prepareDecoration(context);

    Widget child = decoration.textWidget;
    if (decoration.titleWidget != null) {
      child = SpacedColumn(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        spacing: 2,
        children: [
          decoration.titleWidget!,
          child,
        ],
      );
    }

    child = SpacedRow(
      spacing: 12,
      children: [
        Icon(
          decoration.icon,
          color: decoration.gaugesColor,
          size: 28,
        ),
        Expanded(child: child),
        ...getEffectiveButtons(decoration.gaugesColor),
      ],
    );

    return _buildContainer(decoration, child);
  }
}
