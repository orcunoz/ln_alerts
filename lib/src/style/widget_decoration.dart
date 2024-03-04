// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

abstract class WidgetDecoration {
  const WidgetDecoration({
    required this.showRemoveButton,
    required this.borderRadius,
    required this.borderWidth,
    required this.padding,
    required this.minHeight,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.icon,
  });

  final bool? showRemoveButton;
  final BorderRadiusGeometry? borderRadius;
  final double? borderWidth;
  final EdgeInsets? padding;
  final double? minHeight;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final IconData? icon;
}

class FlatAlertDecoration extends WidgetDecoration {
  const FlatAlertDecoration({
    super.showRemoveButton = true,
    super.padding = const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
    super.backgroundColor,
    super.foregroundColor,
    super.icon,
    super.minHeight = kMinInteractiveDimension,
  }) : super(
          borderRadius: BorderRadius.zero,
          borderWidth: null,
        );

  FlatAlertDecoration copyWith({
    bool? showRemoveButton,
    EdgeInsets? padding,
    Color? backgroundColor,
    Color? foregroundColor,
    IconData? icon,
  }) {
    return FlatAlertDecoration(
      showRemoveButton: showRemoveButton ?? this.showRemoveButton,
      padding: padding ?? this.padding,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      foregroundColor: foregroundColor ?? this.foregroundColor,
      icon: icon ?? this.icon,
    );
  }
}

class NotificationAlertDecoration extends WidgetDecoration {
  const NotificationAlertDecoration({
    super.borderRadius = const BorderRadius.all(Radius.circular(8)),
    super.borderWidth = .5,
    super.showRemoveButton = true,
    super.padding = const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
    super.backgroundColor,
    super.foregroundColor,
    super.icon,
    super.minHeight = kMinInteractiveDimension,
  });

  NotificationAlertDecoration copyWith({
    bool? showRemoveButton,
    BorderRadiusGeometry? borderRadius,
    double? borderWidth,
    EdgeInsets? padding,
    Color? backgroundColor,
    Color? foregroundColor,
    IconData? icon,
  }) {
    return NotificationAlertDecoration(
      showRemoveButton: showRemoveButton ?? this.showRemoveButton,
      borderRadius: borderRadius ?? this.borderRadius,
      borderWidth: borderWidth ?? this.borderWidth,
      padding: padding ?? this.padding,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      foregroundColor: foregroundColor ?? this.foregroundColor,
      icon: icon ?? this.icon,
    );
  }
}

class PopupAlertDecoration extends WidgetDecoration {
  final double? minWidth;

  const PopupAlertDecoration({
    this.minWidth = 180,
    super.borderRadius = const BorderRadius.all(Radius.circular(8)),
    super.borderWidth = .5,
    super.showRemoveButton = true,
    super.padding =
        const EdgeInsets.symmetric(horizontal: 24.0, vertical: 18.0),
    super.backgroundColor,
    super.foregroundColor,
    super.icon,
  }) : super(minHeight: null);

  const PopupAlertDecoration.frameless({
    this.minWidth = 180,
    super.showRemoveButton = true,
    super.padding =
        const EdgeInsets.symmetric(horizontal: 24.0, vertical: 18.0),
    super.foregroundColor,
    super.icon,
  }) : super(
          borderRadius: BorderRadius.zero,
          borderWidth: 0,
          backgroundColor: Colors.transparent,
          minHeight: null,
        );

  PopupAlertDecoration frameless() {
    return copyWith(
      borderRadius: BorderRadius.zero,
      borderWidth: 0,
      backgroundColor: Colors.transparent,
      foregroundColor: backgroundColor,
    );
  }

  PopupAlertDecoration copyWith({
    double? minWidth,
    bool? showRemoveButton,
    BorderRadius? borderRadius,
    double? borderWidth,
    EdgeInsets? padding,
    Color? backgroundColor,
    Color? foregroundColor,
    IconData? icon,
  }) {
    return PopupAlertDecoration(
      minWidth: minWidth ?? this.minWidth,
      showRemoveButton: showRemoveButton ?? this.showRemoveButton,
      borderRadius: borderRadius ?? this.borderRadius,
      borderWidth: borderWidth ?? this.borderWidth,
      padding: padding ?? this.padding,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      foregroundColor: foregroundColor ?? this.foregroundColor,
      icon: icon ?? this.icon,
    );
  }
}
