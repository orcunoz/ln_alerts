import 'package:flutter/material.dart';
import 'package:ln_core/ln_core.dart';

import 'alert_widget.dart';

class NotificationAlert extends LnAlertWidget {
  final BorderRadius? borderRadius;
  final double? maxWidth;
  final bool frameless;

  const NotificationAlert({
    super.key,
    required super.alert,
    this.borderRadius,
    this.maxWidth,
    this.frameless = false,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveData = this.effectiveData(context);
    final textStyle = TextStyle(color: effectiveData.foregroundColor);

    Widget child = Text(effectiveMessage, style: textStyle);

    if (alert.title != null) {
      child = SpacedColumn(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 2,
        children: [
          Text(
            alert.title!,
            style: textStyle.copyWith(fontWeight: FontWeight.bold),
          ),
          child,
        ],
      );
    }

    child = SpacedRow(
      spacing: 8,
      children: [
        Icon(effectiveData.icon, color: effectiveData.foregroundColor),
        Expanded(child: child),
        for (var button in alert.buttons) button,
      ],
    );

    final decoration = frameless
        ? null
        : BoxDecoration(
            color: effectiveData.backgroundColor,
            border: Border.fromBorderSide(
              BorderSide(
                width: .5,
                color: effectiveData.backgroundColor
                    .blend(effectiveData.foregroundColor, 50),
              ),
            ),
            borderRadius: borderRadius ?? BorderRadius.circular(8),
          );

    final constraints =
        maxWidth == null ? null : BoxConstraints(maxWidth: maxWidth!);

    if (decoration != null || constraints != null) {
      child = Container(
        padding: EdgeInsets.all(12),
        constraints: constraints,
        decoration: decoration,
        child: child,
      );
    }

    return child;
  }
}
