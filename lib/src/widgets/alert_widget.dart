// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:ln_core/ln_core.dart';

import 'package:ln_alerts/src/style/theme.dart';

import '../alert.dart';
import '../models/alert_widgets.dart';
import '../models/widget_types.dart';
import '../style/widget_decoration.dart';
import 'action_button.dart';

part 'flat_alert.dart';
part 'notification_alert.dart';
part 'popup_alert.dart';

typedef AlertOnTap = void Function();

class _ComputedDecoration {
  final Color backgroundColor;
  final Text? titleWidget;
  final Text textWidget;
  final Color gaugesColor;
  final Border border;
  final BorderRadius? borderRadius;
  final EdgeInsets padding;
  final IconData? icon;
  final double? minWidth;

  const _ComputedDecoration({
    required this.backgroundColor,
    required this.titleWidget,
    required this.textWidget,
    required this.gaugesColor,
    required this.border,
    required this.borderRadius,
    required this.padding,
    required this.icon,
    required this.minWidth,
  });
}

abstract class LnAlertWidget<T extends WidgetDecoration>
    extends StatelessWidget {
  final LnAlert alert;
  final T? _decoration;
  final AlertOnTap? onTap;
  final List<LnAlertActionButton> buttons;
  final AlertWidgets widgetType;

  const LnAlertWidget({
    required super.key,
    required this.alert,
    required T? decoration,
    required this.widgetType,
    required this.onTap,
    required this.buttons,
  }) : _decoration = decoration;

  String get _effectiveMessage =>
      alert.message ??
      switch (alert.type) {
        AlertType.info => LnLocalizations.current.information,
        AlertType.success => LnLocalizations.current.successful,
        AlertType.warning => LnLocalizations.current.warning,
        AlertType.error => LnLocalizations.current.somethingWentWrong,
        _ => "-"
      };

  List<LnAlertActionButton> getEffectiveButtons(Color color) {
    final buttonStyle = ButtonStyle(
      overlayColor: color.withOpacity(.2).material,
      foregroundColor: color.material,
    );

    return [
      for (var button in buttons)
        button.copyWith(
          icon: button.icon,
          text: button.text,
          onPressed: button.onPressed,
          style: buttonStyle,
        ),
    ];
  }

  _ComputedDecoration _prepareDecoration(BuildContext context) {
    final alertsTheme = LnAlertsTheme.of(context);
    final typeColors =
        alert.type == null ? null : alertsTheme.colorsOf(alert.type!);
    final defaultColors = alertsTheme.colorsOf(AlertType.info);
    final themeDecoration = alertsTheme.decorationOf(widgetType);
    final backgroundColor = typeColors?.background ??
        _decoration?.backgroundColor ??
        themeDecoration.backgroundColor ??
        defaultColors.background;
    final foregroundColor = typeColors?.foreground ??
        _decoration?.foregroundColor ??
        themeDecoration.foregroundColor ??
        defaultColors.foreground;

    final position = widgetType == AlertWidgets.flat
        ? ((_decoration as FlatAlertDecoration?)?.position ??
            (themeDecoration as FlatAlertDecoration?)?.position)
        : null;
    final borderSide = BorderSide(
      color: backgroundColor.blend(foregroundColor, 40),
      width: _decoration?.borderWidth ?? themeDecoration.borderWidth ?? .5,
    );

    final textStyle = TextStyle(color: foregroundColor);

    final minWidth = widgetType == AlertWidgets.popup
        ? ((_decoration as PopupAlertDecoration?)?.minWidth ??
            (themeDecoration as PopupAlertDecoration?)?.minWidth)
        : null;

    return _ComputedDecoration(
      backgroundColor: backgroundColor,
      textWidget: Text(
        _effectiveMessage,
        style: textStyle,
      ),
      titleWidget: alert.title == null
          ? null
          : Text(
              alert.title!,
              style: textStyle.copyWith(fontWeight: FontWeight.bold),
            ),
      gaugesColor: foregroundColor.blend(backgroundColor, 10),
      icon: alert.type == null
          ? _decoration?.icon
          : alertsTheme.iconOf(alert.type!),
      padding:
          _decoration?.padding ?? themeDecoration.padding ?? EdgeInsets.zero,
      borderRadius: position == null
          ? BorderRadius.all(
              _decoration?.borderRadius ??
                  themeDecoration.borderRadius ??
                  Radius.zero,
            )
          : null,
      border: switch (position) {
        FlatAlertPosition.top => Border(bottom: borderSide),
        FlatAlertPosition.bottom => Border(top: borderSide),
        null => Border.fromBorderSide(borderSide),
      },
      minWidth: minWidth,
    );
  }

  Widget _buildContainer(_ComputedDecoration computedDecoration, Widget child) {
    child = Container(
      padding: computedDecoration.padding,
      constraints: computedDecoration.minWidth == null
          ? null
          : BoxConstraints(minWidth: computedDecoration.minWidth!),
      decoration: BoxDecoration(
        color: computedDecoration.backgroundColor,
        border: computedDecoration.border,
        borderRadius: computedDecoration.borderRadius,
      ),
      child: child,
    );

    if (onTap != null) {
      child = InkWell(
        onTap: onTap,
        child: child,
      );
    }

    return child;
  }
}
