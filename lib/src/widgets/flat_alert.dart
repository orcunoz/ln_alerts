import 'package:flutter/material.dart';
import 'package:ln_core/ln_core.dart';

import '../defaults.dart';
import '../style/alert_decoration.dart';
import 'alert_widget.dart';

enum FlatAlertPosition {
  top,
  bottom,
}

class FlatAlertConfig extends AlertConfig {
  final FlatAlertPosition position;

  const FlatAlertConfig({
    this.position = FlatAlertPosition.bottom,
    super.duration = const Duration(seconds: 5),
  });
}

class FlatAlert extends LnAlertWidget {
  final FlatAlertConfig? config;

  const FlatAlert({
    super.key,
    required super.alert,
    super.decoration,
    this.config,
  });

  @override
  Widget build(BuildContext context) {
    final decoration = super.decoration ??
        LnAlertDecoration.generate(context: context, alertType: alert.type);
    final effectiveConfig = config ??
        LnAlerts.maybeOf(context)?.flatAlertDefaults ??
        FlatAlertConfig();

    final borderSide = BorderSide(
      width: .5,
      color: decoration.foregroundColor.withOpacity(.5),
    );

    final textStyle = TextStyle(color: decoration.foregroundColor);

    Widget child = Text(
      effectiveMessage,
      style: textStyle,
    );

    if (alert.title != null) {
      child = SpacedColumn(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
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
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: decoration.backgroundColor,
        border: effectiveConfig.position == FlatAlertPosition.top
            ? Border(bottom: borderSide)
            : Border(top: borderSide),
      ),
      child: SpacedRow(
        spacing: 12,
        children: [
          Icon(
            decoration.icon,
            color: decoration.foregroundColor,
            size: 28,
          ),
          Expanded(child: child),
          for (var button in alert.buttons) button,
        ],
      ),
    );
  }
}
