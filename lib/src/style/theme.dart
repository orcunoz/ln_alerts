// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:ln_core/ln_core.dart';

import '../models/alert_type.dart';
import '../models/display_type.dart';
import 'widget_decoration.dart';

part 'type_colors.dart';

class NotificationAlertsContainerSettings {
  const NotificationAlertsContainerSettings({
    this.width = 400,
    this.insets = const EdgeInsets.only(left: 36, right: 8, top: 8, bottom: 8),
    this.spacing = 4,
    this.alignment = Alignment.topRight,
  });

  final double width;
  final EdgeInsets insets;
  final double spacing;
  final Alignment alignment;
}

enum FlatAlertPosition {
  top,
  bottom,
}

class FlatAlertsContainerSettings {
  const FlatAlertsContainerSettings({
    this.position = FlatAlertPosition.bottom,
    this.borderSide = BorderSide.none,
    this.borderRadius = BorderRadius.zero,
    this.insertingUnderContent = 0,
    this.horizontalMargin = 0,
    this.dividerWidth = .5,
  }) : assert(insertingUnderContent >= .0);

  final FlatAlertPosition position;
  final BorderSide borderSide;
  final BorderRadiusGeometry borderRadius;
  final double insertingUnderContent;
  final double? horizontalMargin;
  final double? dividerWidth;

  FlatAlertsContainerSettings copyWith({
    FlatAlertPosition? position,
    BorderSide? borderSide,
    BorderRadiusGeometry? borderRadius,
    double? insertingUnderContent,
    double? horizontalMargin,
    double? dividerWidth,
  }) {
    return FlatAlertsContainerSettings(
      position: position ?? this.position,
      borderSide: borderSide ?? this.borderSide,
      borderRadius: borderRadius ?? this.borderRadius,
      insertingUnderContent:
          insertingUnderContent ?? this.insertingUnderContent,
      horizontalMargin: horizontalMargin ?? this.horizontalMargin,
      dividerWidth: dividerWidth ?? this.dividerWidth,
    );
  }
}

extension AlertsThemeDataExtensions on ThemeData {
  LnAlertsTheme get alertsTheme =>
      extension<LnAlertsTheme>() ??
      (isDark ? LnAlertsTheme._defaultDark : LnAlertsTheme._defaultLight);
}

class LnAlertsTheme extends ThemeExtension<LnAlertsTheme> {
  const LnAlertsTheme._({
    required this.infoIcon,
    required this.infoColors,
    required this.successIcon,
    required this.successColors,
    required this.warningIcon,
    required this.warningColors,
    required this.errorIcon,
    required this.errorColors,
    required this.flatAlertDecoration,
    required this.flatAlertsContainerSettings,
    required this.notificationAlertDecoration,
    required this.notificationAlertContainerSettings,
    required this.popupAlertDecoration,
    required this.scrimColor,
  });

  factory LnAlertsTheme({
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
    FlatAlertsContainerSettings? flatAlertsContainerSettings,
    NotificationAlertDecoration? notificationAlertTheme,
    NotificationAlertsContainerSettings? notificationAlertContainerSettings,
    PopupAlertDecoration? popupAlertTheme,
    Color? scrimColor,
    AlertDisplayType? defaultDisplayType,
  }) =>
      (brightness.isDark ? _defaultDark : _defaultLight).copyWith(
        infoIcon: infoIcon,
        infoColors: infoColors,
        successIcon: successIcon,
        successColors: successColors,
        warningIcon: warningIcon,
        warningColors: warningColors,
        errorIcon: errorIcon,
        errorColors: errorColors,
        flatAlertDecoration: flatAlertTheme,
        flatAlertsContainerSettings: flatAlertsContainerSettings,
        notificationAlertDecoration: notificationAlertTheme,
        notificationAlertContainerSettings: notificationAlertContainerSettings,
        popupAlertDecoration: popupAlertTheme,
        scrimColor: scrimColor,
      );

  const LnAlertsTheme.light({
    this.infoIcon = Icons.info_outline_rounded,
    this.infoColors = const LnAlertColors.infoLight(),
    this.successIcon = Icons.check_circle_outline_rounded,
    this.successColors = const LnAlertColors.successLight(),
    this.warningIcon = Icons.error_outline_rounded,
    this.warningColors = const LnAlertColors.warningLight(),
    this.errorIcon = Icons.error_outline_rounded,
    this.errorColors = const LnAlertColors.errorLight(),
    this.flatAlertDecoration = const FlatAlertDecoration(),
    this.flatAlertsContainerSettings = const FlatAlertsContainerSettings(),
    this.notificationAlertDecoration = const NotificationAlertDecoration(),
    this.notificationAlertContainerSettings =
        const NotificationAlertsContainerSettings(),
    this.popupAlertDecoration = const PopupAlertDecoration(),
    this.scrimColor,
  });

  const LnAlertsTheme.dark({
    this.infoIcon = Icons.info_outline_rounded,
    this.infoColors = const LnAlertColors.infoDark(),
    this.successIcon = Icons.check_circle_outline_rounded,
    this.successColors = const LnAlertColors.successDark(),
    this.warningIcon = Icons.error_outline_rounded,
    this.warningColors = const LnAlertColors.warningDark(),
    this.errorIcon = Icons.error_outline_rounded,
    this.errorColors = const LnAlertColors.errorDark(),
    this.flatAlertDecoration = const FlatAlertDecoration(),
    this.flatAlertsContainerSettings = const FlatAlertsContainerSettings(),
    this.notificationAlertDecoration = const NotificationAlertDecoration(),
    this.notificationAlertContainerSettings =
        const NotificationAlertsContainerSettings(),
    this.popupAlertDecoration = const PopupAlertDecoration(),
    this.scrimColor,
  });

  final IconData infoIcon;
  final LnAlertColors infoColors;
  final IconData successIcon;
  final LnAlertColors successColors;
  final IconData warningIcon;
  final LnAlertColors warningColors;
  final IconData errorIcon;
  final LnAlertColors errorColors;

  final FlatAlertDecoration flatAlertDecoration;
  final FlatAlertsContainerSettings flatAlertsContainerSettings;
  final NotificationAlertDecoration notificationAlertDecoration;
  final NotificationAlertsContainerSettings notificationAlertContainerSettings;
  final PopupAlertDecoration popupAlertDecoration;

  final Color? scrimColor;

  static const _defaultLight = LnAlertsTheme.light();
  static const _defaultDark = LnAlertsTheme.dark();

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

  WidgetDecoration decorationOf(AlertDisplayType alertWidget) =>
      switch (alertWidget) {
        AlertDisplayType.flat => flatAlertDecoration,
        AlertDisplayType.notification => notificationAlertDecoration,
        AlertDisplayType.popup => popupAlertDecoration,
      };

  @override
  LnAlertsTheme copyWith({
    IconData? infoIcon,
    LnAlertColors? infoColors,
    IconData? successIcon,
    LnAlertColors? successColors,
    IconData? warningIcon,
    LnAlertColors? warningColors,
    IconData? errorIcon,
    LnAlertColors? errorColors,
    FlatAlertDecoration? flatAlertDecoration,
    FlatAlertsContainerSettings? flatAlertsContainerSettings,
    NotificationAlertDecoration? notificationAlertDecoration,
    NotificationAlertsContainerSettings? notificationAlertContainerSettings,
    PopupAlertDecoration? popupAlertDecoration,
    Color? scrimColor,
  }) {
    return LnAlertsTheme._(
      infoIcon: infoIcon ?? this.infoIcon,
      infoColors: infoColors ?? this.infoColors,
      successIcon: successIcon ?? this.successIcon,
      successColors: successColors ?? this.successColors,
      warningIcon: warningIcon ?? this.warningIcon,
      warningColors: warningColors ?? this.warningColors,
      errorIcon: errorIcon ?? this.errorIcon,
      errorColors: errorColors ?? this.errorColors,
      flatAlertDecoration: flatAlertDecoration ?? this.flatAlertDecoration,
      flatAlertsContainerSettings:
          flatAlertsContainerSettings ?? this.flatAlertsContainerSettings,
      notificationAlertDecoration:
          notificationAlertDecoration ?? this.notificationAlertDecoration,
      notificationAlertContainerSettings: notificationAlertContainerSettings ??
          this.notificationAlertContainerSettings,
      popupAlertDecoration: popupAlertDecoration ?? this.popupAlertDecoration,
      scrimColor: scrimColor ?? this.scrimColor,
    );
  }

  @override
  ThemeExtension<LnAlertsTheme> lerp(
      covariant ThemeExtension<LnAlertsTheme>? other, double t) {
    return other ?? this;
  }
}
