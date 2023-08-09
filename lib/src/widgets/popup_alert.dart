part of 'alert_widget.dart';

class PopupAlert extends LnAlertWidget<PopupAlertDecoration> {
  const PopupAlert({
    super.key,
    required super.alert,
    super.decoration = const PopupAlertDecoration(),
    super.onTap,
    super.buttons = const [],
  }) : super(widgetType: AlertWidget.popup);

  @override
  Widget build(BuildContext context) {
    final decoration = _prepareDecoration(context);
    final buttons = getEffectiveButtons(decoration.gaugesColor);

    Widget child = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          decoration.icon,
          size: 64,
          color: decoration.gaugesColor,
        ),
        SizedBox(height: 8),
        if (decoration.titleWidget != null) decoration.titleWidget!,
        decoration.textWidget,
        for (var button in buttons)
          if (button != buttons.last) button
      ],
    );

    child = _buildContainer(context, decoration, child);

    /*if (decoration.showRemoveButton && onTapRemove != null) {
      child = Stack(
        alignment: Alignment.topRight,
        children: [child, buttons.last],
      );
    }*/

    return child;
  }

  PopupAlert.noResultsFound({
    PopupAlertDecoration decoration = const PopupAlertDecoration(),
    List<LnAlertActionButton> buttons = const [],
  }) : this(
          decoration: decoration,
          alert: LnAlert.info(
            LnLocalizations.current.noResultsFound,
            icon: Icons.web_asset_off_rounded,
          ),
          buttons: buttons,
        );
}
