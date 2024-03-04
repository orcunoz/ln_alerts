// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'alert_widget.dart';

//typedef OnSizeChanged = void Function(Size size);

class FlatAlert extends LnAlertWidget<FlatAlertDecoration> {
  const FlatAlert({
    super.key,
    required super.alert,
    super.decoration,
    super.onTap,
    required this.position,
    super.buttons = const [],
  })  : bottomPadding = null,
        super(displayType: AlertDisplayType.flat);

  const FlatAlert._({
    super.key,
    required super.alert,
    super.decoration,
    super.onTap,
    required this.position,
    super.buttons = const [],
    this.bottomPadding,
  }) : super(displayType: AlertDisplayType.flat);

  final FlatAlertPosition? position;
  final double? bottomPadding;

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

    final padding =
        decoration.padding + EdgeInsets.only(bottom: bottomPadding ?? .0);

    child = Row(
      children: [
        Flexible(
          child: Padding(
            padding: padding.copyWith(right: 0),
            child: Row(
              children: [
                Icon(
                  decoration.icon,
                  color: decoration.gaugesColor,
                  size: 28,
                ),
                SizedBox(width: 12),
                Expanded(child: child),
                SizedBox(width: math.max(12, decoration.padding.right)),
              ],
            ),
          ),
        ),
        ...getEffectiveButtons(decoration.gaugesColor),
      ],
    );

    return _buildContainer(context, decoration, child);
  }

  FlatAlert copyWith({
    FlatAlertPosition? position,
    LnAlert? alert,
    FlatAlertDecoration? decoration,
    AlertOnTap? onTap,
    List<LnAlertActionButton>? buttons,
    double? bottomPadding,
  }) {
    return FlatAlert._(
      key: key,
      position: position ?? this.position,
      alert: alert ?? this.alert,
      decoration: decoration ?? _decoration,
      onTap: onTap ?? this.onTap,
      buttons: buttons ?? this.buttons,
      bottomPadding: bottomPadding ?? this.bottomPadding,
    );
  }
}
