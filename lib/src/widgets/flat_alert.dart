part of 'alert_widget.dart';

//typedef OnSizeChanged = void Function(Size size);

class FlatAlert extends LnAlertWidget<FlatAlertDecoration> {
  const FlatAlert({
    super.key,
    required super.alert,
    super.decoration,
    super.onTap,
    super.buttons = const [],
  }) : super(widgetType: AlertWidget.flat);

  /*const FlatAlert.measureable({
    Key? key,
    required LnAlert alert,
    FlatAlertDecoration? decoration,
    void Function()? onTap,
    List<LnAlertActionButton> buttons = const [],
    required OnSizeChanged onSizeChanged,
  }) : this(
    key: key,
    alert: alert,
    decoration: decoration,
    onTap: onTap,
    buttons: buttons,
    onSizeChanged: onSizeChanged,
  );*/

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

    return _buildContainer(context, decoration, child);
  }
}
