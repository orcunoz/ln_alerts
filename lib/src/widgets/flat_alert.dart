import 'package:flutter/material.dart';
import 'package:ln_core/ln_core.dart';

import 'alert_widget.dart';

class FlatAlert extends LnAlertWidget {
  final bool hasTopBorder;
  final bool hasBottomBorder;
  final EdgeInsets? additionalPadding;
  const FlatAlert({
    super.key,
    required super.alert,
    this.hasTopBorder = false,
    this.hasBottomBorder = false,
    this.additionalPadding,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveData = this.effectiveData(context);
    final borderSide = BorderSide(
      width: .5,
      color: effectiveData.foregroundColor.withOpacity(.5),
    );
    final textStyle = TextStyle(
      color: effectiveData.foregroundColor,
    );

    Widget child = Text(
      effectiveMessage,
      style: textStyle,
    );

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

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12) +
          (additionalPadding == null ? EdgeInsets.zero : additionalPadding!),
      decoration: BoxDecoration(
        color: effectiveData.backgroundColor,
        border: Border(
          top: hasTopBorder ? borderSide : BorderSide.none,
          bottom: hasBottomBorder ? borderSide : BorderSide.none,
        ),
      ),
      child: SpacedRow(
        spacing: 12,
        children: [
          Icon(
            effectiveData.icon,
            color: effectiveData.foregroundColor,
            size: 28,
          ),
          Expanded(child: child),
          for (var button in alert.buttons) button,
        ],
      ),
    );
  }
}
