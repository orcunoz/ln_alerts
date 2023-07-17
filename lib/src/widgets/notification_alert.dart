import 'package:flutter/material.dart';
import 'package:ln_alerts/ln_alerts.dart';
import 'package:ln_core/ln_core.dart';

import 'alert_widget.dart';

class NotificationAlert extends LnAlertWidget {
  final BorderRadius? borderRadius;
  final Color scrimColor;

  const NotificationAlert({
    super.key,
    required super.alert,
    super.colorFilled,
    super.buttonText,
    super.onPressed,
    this.borderRadius,
    this.scrimColor = const Color(0x20FFFFFF),
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

    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: effectiveData.backgroundColor,
        border: Border.fromBorderSide(
          BorderSide(
            width: .5,
            color: effectiveData.backgroundColor
                .blend(effectiveData.foregroundColor, 50),
          ),
        ),
        borderRadius: borderRadius ?? BorderRadius.circular(8),
      ),
      child: SpacedRow(
        spacing: 8,
        children: [
          Icon(effectiveData.icon, color: effectiveData.foregroundColor),
          Expanded(child: child),
          if (buttonText != null)
            TextButton(
              onPressed: onPressed,
              style:
                  ButtonStyle(tapTargetSize: MaterialTapTargetSize.shrinkWrap),
              child: Text(
                buttonText!,
                style: textStyle,
              ),
            ),
        ],
      ),
    );
  }
}
