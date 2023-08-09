import 'package:flutter/material.dart';

abstract class WidgetDecoration {
  final bool? showRemoveButton;
  final Radius? borderRadius;
  final double? borderWidth;
  final EdgeInsets? padding;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final IconData? icon;

  const WidgetDecoration({
    required this.showRemoveButton,
    required this.borderRadius,
    required this.borderWidth,
    required this.padding,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.icon,
  });
}

class FlatAlertDecoration extends WidgetDecoration {
  const FlatAlertDecoration({
    super.borderWidth = .5,
    super.showRemoveButton = true,
    super.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    super.backgroundColor,
    super.foregroundColor,
    super.icon,
  }) : super(borderRadius: Radius.zero);
}

class NotificationAlertDecoration extends WidgetDecoration {
  const NotificationAlertDecoration({
    super.borderRadius = const Radius.circular(8),
    super.borderWidth = .5,
    super.showRemoveButton = true,
    super.padding = const EdgeInsets.all(12),
    super.backgroundColor,
    super.foregroundColor,
    super.icon,
  });
}

class PopupAlertDecoration extends WidgetDecoration {
  final double? minWidth;
  final bool colorFilled;

  const PopupAlertDecoration({
    this.minWidth = 180,
    super.borderRadius = const Radius.circular(8),
    super.borderWidth = .5,
    super.showRemoveButton = true,
    super.padding =
        const EdgeInsets.symmetric(horizontal: 24.0, vertical: 18.0),
    super.backgroundColor,
    super.foregroundColor,
    super.icon,
  }) : colorFilled = true;

  const PopupAlertDecoration.frameless({
    this.minWidth = 180,
    super.showRemoveButton = true,
    super.padding =
        const EdgeInsets.symmetric(horizontal: 24.0, vertical: 18.0),
    super.backgroundColor,
    super.foregroundColor,
    super.icon,
  })  : colorFilled = false,
        super(
          borderRadius: Radius.zero,
          borderWidth: 0,
        );
}
