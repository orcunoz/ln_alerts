import 'package:flutter/material.dart';
import 'package:ln_core/ln_core.dart';

import '../alert.dart';
import '../models/alert_type.dart';
import '../models/display_type.dart';
import '../style/theme.dart';
import '../style/widget_decoration.dart';
import 'action_button.dart';

import 'dart:math' as math;

part 'flat_alert.dart';
part 'notification_alert.dart';
part 'popup_alert.dart';

typedef AlertOnTap = void Function();

class _ComputedDecoration {
  const _ComputedDecoration({
    required this.backgroundColor,
    required this.titleWidget,
    required this.textWidget,
    required this.gaugesColor,
    required this.borderSide,
    required this.borderRadius,
    required this.padding,
    required this.icon,
    required this.minWidth,
    required this.minHeight,
  });

  final Color backgroundColor;
  final Text? titleWidget;
  final Text textWidget;
  final Color gaugesColor;
  final BorderSide? borderSide;
  final BorderRadiusGeometry borderRadius;
  final EdgeInsets padding;
  final IconData? icon;
  final double? minWidth;
  final double? minHeight;
}

abstract class LnAlertWidget<T extends WidgetDecoration>
    extends StatelessWidget {
  const LnAlertWidget({
    required super.key,
    required this.alert,
    required T? decoration,
    required this.displayType,
    required this.onTap,
    required this.buttons,
  }) : _decoration = decoration;

  final LnAlert alert;
  final T? _decoration;
  final AlertOnTap? onTap;
  final List<LnAlertActionButton> buttons;
  final AlertDisplayType displayType;

  String get _effectiveMessage =>
      alert.message ??
      switch (alert.type) {
        AlertType.info => LnLocalizations.current.information,
        AlertType.success => LnLocalizations.current.successful,
        AlertType.warning => LnLocalizations.current.warning,
        AlertType.error => LnLocalizations.current.somethingWentWrong,
      };

  List<LnAlertActionButton> getEffectiveButtons(Color color) {
    final buttonStyle = ButtonStyle(
      overlayColor: color.withOpacity(.2).material,
      foregroundColor: color.material,
      iconColor: color.material,
      surfaceTintColor: color.withOpacity(.1).material,
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity(
        horizontal: VisualDensity.minimumDensity,
        vertical: VisualDensity.minimumDensity,
      ),
      minimumSize: MaterialStatePropertyAll(
        Size.square(kMinInteractiveDimension),
      ),
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
    final theme = Theme.of(context);
    final decoration =
        _decoration ?? theme.alertsTheme.decorationOf(displayType);
    final typeColors = theme.alertsTheme.colorsOf(alert.type);

    final backgroundColor = decoration.backgroundColor ?? typeColors.background;
    var foregroundColor = decoration.foregroundColor ??
        (backgroundColor == Colors.transparent
            ? typeColors.background
            : typeColors.foreground);

    if (foregroundColor == Colors.transparent) {
      foregroundColor = theme.colorScheme.onSurface;
    }

    final BorderSide? borderSide = decoration.borderWidth == 0
        ? null
        : BorderSide(
            color: theme.borderColor(backgroundColor, sharpness: 3),
            width: decoration.borderWidth ?? .5,
          );
    final BorderRadiusGeometry borderRadius =
        displayType == AlertDisplayType.flat || decoration.borderRadius == null
            ? BorderRadius.zero
            : decoration.borderRadius!;

    final textStyle = TextStyle(color: foregroundColor);

    final minWidth = displayType == AlertDisplayType.popup
        ? (decoration as PopupAlertDecoration?)?.minWidth
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
      icon: decoration.icon ?? theme.alertsTheme.iconOf(alert.type),
      padding: decoration.padding ?? EdgeInsets.zero,
      borderRadius: borderRadius,
      borderSide: borderSide,
      minWidth: minWidth,
      minHeight: decoration.minHeight,
    );
  }

  Widget _buildContainer(BuildContext context,
      _ComputedDecoration computedDecoration, Widget child) {
    final constraints = computedDecoration.minWidth == null &&
            computedDecoration.minHeight == null
        ? null
        : BoxConstraints(
            minWidth: computedDecoration.minWidth ?? 0,
            minHeight: computedDecoration.minHeight ?? 0,
          );

    if (constraints != null) {
      child = ConstrainedBox(
        constraints: constraints,
        child: child,
      );
    }

    if (onTap != null) {
      child = InkWell(
        splashColor: computedDecoration.gaugesColor.withOpacity(.3),
        overlayColor: computedDecoration.gaugesColor.withOpacity(.1).material,
        onTap: onTap,
        child: child,
      );
    }

    final FlatAlertPosition? position;
    if (displayType == AlertDisplayType.flat) {
      final flatAlert = (this as FlatAlert);
      position = flatAlert.position;

      if (flatAlert.applySafeBottomPadding) {
        child = Padding(
          padding: MediaQuery.of(context).safeBottomPadding,
          child: child,
        );
      }
    } else {
      position = null;
    }
    final borderSide = computedDecoration.borderSide ?? BorderSide.none;

    return Material(
      color: computedDecoration.backgroundColor,
      clipBehavior: Clip.antiAlias,
      shape: switch (position) {
        FlatAlertPosition.top => Border(bottom: borderSide),
        FlatAlertPosition.bottom => Border(top: borderSide),
        _ => RoundedRectangleBorder(
            side: borderSide,
            borderRadius: computedDecoration.borderRadius,
          ),
      },
      surfaceTintColor: Colors.transparent,
      child: child,
    );
  }
}
