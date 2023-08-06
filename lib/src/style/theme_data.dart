import 'package:flutter/material.dart';

import '../models/alert_widgets.dart';
import '../models/widget_types.dart';
import 'widget_decoration.dart';

part 'type_colors.dart';

class NotificationAlertContainerSettings {
  final double width;
  final EdgeInsets insets;
  final double spacing;
  final Alignment alignment;

  const NotificationAlertContainerSettings({
    this.width = 400,
    this.insets = const EdgeInsets.all(8),
    this.spacing = 4,
    this.alignment = Alignment.topRight,
  });
}

class LnAlertsThemeData {
  final IconData infoIcon;
  final LnAlertColors infoColors;
  final IconData successIcon;
  final LnAlertColors successColors;
  final IconData warningIcon;
  final LnAlertColors warningColors;
  final IconData errorIcon;
  final LnAlertColors errorColors;

  final FlatAlertDecoration flatAlertDecoration;
  final NotificationAlertDecoration notificationAlertDecoration;
  final NotificationAlertContainerSettings notificationAlertContainerSettings;
  final PopupAlertDecoration popupAlertDecoration;

  final Color? scrimColor;

  const LnAlertsThemeData._({
    required this.infoIcon,
    required this.infoColors,
    required this.successIcon,
    required this.successColors,
    required this.warningIcon,
    required this.warningColors,
    required this.errorIcon,
    required this.errorColors,
    required this.flatAlertDecoration,
    required this.notificationAlertDecoration,
    required this.notificationAlertContainerSettings,
    required this.popupAlertDecoration,
    required this.scrimColor,
  });

  factory LnAlertsThemeData({
    required Brightness brightness,
    IconData? infoIcon,
    LnAlertColors? infoColors,
    IconData? successIcon,
    LnAlertColors? successColors,
    IconData? warningIcon,
    LnAlertColors? warningColors,
    IconData? errorIcon,
    LnAlertColors? errorColors,
    FlatAlertDecoration? flatAlertTheme,
    NotificationAlertDecoration? notificationAlertTheme,
    NotificationAlertContainerSettings? notificationAlertContainerSettings,
    PopupAlertDecoration? popupAlertTheme,
    Color? scrimColor,
    AlertWidgets? defaultWidget,
  }) =>
      (brightness == Brightness.dark
              ? LnAlertsThemeData.dark()
              : LnAlertsThemeData.light())
          .copyWith(
        infoIcon: infoIcon,
        infoColors: infoColors,
        successIcon: successIcon,
        successColors: successColors,
        warningIcon: warningIcon,
        warningColors: warningColors,
        errorIcon: errorIcon,
        errorColors: errorColors,
        flatAlertDecoration: flatAlertTheme,
        notificationAlertDecoration: notificationAlertTheme,
        notificationAlertContainerSettings: notificationAlertContainerSettings,
        popupAlertDecoration: popupAlertTheme,
        scrimColor: scrimColor,
      );

  const LnAlertsThemeData.light({
    this.infoIcon = Icons.info_outline_rounded,
    this.infoColors = const LnAlertColors.infoLight(),
    this.successIcon = Icons.check_circle_outline_rounded,
    this.successColors = const LnAlertColors.successLight(),
    this.warningIcon = Icons.error_outline_rounded,
    this.warningColors = const LnAlertColors.warningLight(),
    this.errorIcon = Icons.error_outline_rounded,
    this.errorColors = const LnAlertColors.errorLight(),
    this.flatAlertDecoration = const FlatAlertDecoration(),
    this.notificationAlertDecoration = const NotificationAlertDecoration(),
    this.notificationAlertContainerSettings =
        const NotificationAlertContainerSettings(),
    this.popupAlertDecoration = const PopupAlertDecoration(),
    this.scrimColor,
  });

  const LnAlertsThemeData.dark({
    this.infoIcon = Icons.info_outline_rounded,
    this.infoColors = const LnAlertColors.infoDark(),
    this.successIcon = Icons.check_circle_outline_rounded,
    this.successColors = const LnAlertColors.successDark(),
    this.warningIcon = Icons.error_outline_rounded,
    this.warningColors = const LnAlertColors.warningDark(),
    this.errorIcon = Icons.error_outline_rounded,
    this.errorColors = const LnAlertColors.errorDark(),
    this.flatAlertDecoration = const FlatAlertDecoration(),
    this.notificationAlertDecoration = const NotificationAlertDecoration(),
    this.notificationAlertContainerSettings =
        const NotificationAlertContainerSettings(),
    this.popupAlertDecoration = const PopupAlertDecoration(),
    this.scrimColor,
  });

  IconData iconOf(AlertType type) => switch (type) {
        AlertType.info => Icons.info_outline_rounded,
        AlertType.success => Icons.check_circle_outline_rounded,
        AlertType.warning => Icons.error_outline_rounded,
        AlertType.error => Icons.error_outline_rounded,
      };

  LnAlertColors colorsOf(AlertType type) => switch (type) {
        AlertType.info => infoColors,
        AlertType.success => successColors,
        AlertType.warning => warningColors,
        AlertType.error => errorColors,
      };

  WidgetDecoration decorationOf(AlertWidgets alertWidget) =>
      switch (alertWidget) {
        AlertWidgets.flat => flatAlertDecoration,
        AlertWidgets.notification => notificationAlertDecoration,
        AlertWidgets.popup => popupAlertDecoration,
      };

  LnAlertsThemeData copyWith({
    IconData? infoIcon,
    LnAlertColors? infoColors,
    IconData? successIcon,
    LnAlertColors? successColors,
    IconData? warningIcon,
    LnAlertColors? warningColors,
    IconData? errorIcon,
    LnAlertColors? errorColors,
    FlatAlertDecoration? flatAlertDecoration,
    NotificationAlertDecoration? notificationAlertDecoration,
    NotificationAlertContainerSettings? notificationAlertContainerSettings,
    PopupAlertDecoration? popupAlertDecoration,
    Color? scrimColor,
  }) {
    return LnAlertsThemeData._(
      infoIcon: infoIcon ?? this.infoIcon,
      infoColors: infoColors ?? this.infoColors,
      successIcon: successIcon ?? this.successIcon,
      successColors: successColors ?? this.successColors,
      warningIcon: warningIcon ?? this.warningIcon,
      warningColors: warningColors ?? this.warningColors,
      errorIcon: errorIcon ?? this.errorIcon,
      errorColors: errorColors ?? this.errorColors,
      flatAlertDecoration: flatAlertDecoration ?? this.flatAlertDecoration,
      notificationAlertDecoration:
          notificationAlertDecoration ?? this.notificationAlertDecoration,
      notificationAlertContainerSettings: notificationAlertContainerSettings ??
          this.notificationAlertContainerSettings,
      popupAlertDecoration: popupAlertDecoration ?? this.popupAlertDecoration,
      scrimColor: scrimColor ?? this.scrimColor,
    );
  }
}
