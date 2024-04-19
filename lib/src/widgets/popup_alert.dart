part of 'alert_widget.dart';

class PopupAlert extends LnAlertWidget<PopupAlertDecoration> {
  const PopupAlert({
    super.key,
    required super.alert,
    super.decoration = const PopupAlertDecoration(),
    super.onTap,
    this.fill = false,
    super.buttons = const [],
  }) : super(displayType: AlertDisplayType.popup);

  final bool fill;

  @override
  Widget build(BuildContext context) {
    final decoration = _prepareDecoration(context);
    final buttons = getEffectiveButtons(decoration.gaugesColor);
    final removeButton = buttons.where((b) => b.removeButton).firstOrNull;

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
        SizedBox(height: 4),
        for (var button in buttons.where((b) => !b.removeButton)) button
      ],
    );

    if (fill) {
      child = Center(
        child: child,
      );
    } else if (decoration.padding != EdgeInsets.zero) {
      child = Padding(
        padding: decoration.padding,
        child: child,
      );
    }

    if (removeButton != null) {
      child = Stack(
        alignment: Alignment.center,
        children: [
          child,
          Positioned(
            top: 0,
            right: 0,
            child: removeButton.copyWith(
              style: removeButton.style?.copyWith(
                fixedSize: MaterialStatePropertyAll(
                    Size.square(kMinInteractiveDimension)),
              ),
            ),
          ),
        ],
      );
    }

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
    required Color color,
    List<LnAlertActionButton> buttons = const [],
  }) : this(
          decoration: PopupAlertDecoration.frameless(foregroundColor: color),
          alert: LnAlert.info(
            LnLocalizations.current.noResultsFound,
            icon: Icons.web_asset_off_rounded,
          ),
          buttons: buttons,
        );
}
