part of 'theme.dart';

const Map<(Brightness, AlertType), LnAlertColors> _defaultTypeColors = {
  (Brightness.light, AlertType.info): LnAlertColors.infoLight(),
  (Brightness.dark, AlertType.info): LnAlertColors.infoDark(),
  (Brightness.light, AlertType.success): LnAlertColors.successLight(),
  (Brightness.dark, AlertType.success): LnAlertColors.successDark(),
  (Brightness.light, AlertType.warning): LnAlertColors.warningLight(),
  (Brightness.dark, AlertType.warning): LnAlertColors.warningDark(),
  (Brightness.light, AlertType.error): LnAlertColors.errorLight(),
  (Brightness.dark, AlertType.error): LnAlertColors.errorDark(),
};

class LnAlertColors {
  final Color background;
  final Color foreground;

  const LnAlertColors({
    required this.background,
    required this.foreground,
  });

  const LnAlertColors.infoLight({
    this.background = const Color(0xFFf3f3f3),
    this.foreground = const Color(0xFF585858),
  });

  const LnAlertColors.infoDark({
    this.background = const Color(0xFF282828),
    this.foreground = const Color(0xFFEBEBEB),
  });

  const LnAlertColors.successLight({
    this.background = const Color(0xFFA8F1C6),
    this.foreground = const Color(0xFF198343),
  });

  const LnAlertColors.successDark({
    this.background = const Color(0xFF198343),
    this.foreground = const Color(0xFFD2F8E2),
  });

  const LnAlertColors.warningLight({
    this.background = const Color(0xFFFFD38A),
    this.foreground = const Color(0xFF8B5502),
  });

  const LnAlertColors.warningDark({
    this.background = const Color(0xFFDE8519),
    this.foreground = Colors.white,
  });

  const LnAlertColors.errorLight({
    this.background = const Color(0xFFF9DEDC),
    this.foreground = const Color(0xFFB3261E),
  });

  const LnAlertColors.errorDark({
    this.background = const Color(0xffb1384e),
    this.foreground = const Color(0xFFF9DEDC),
  });

  factory LnAlertColors.forType(Brightness brightness, AlertType type) =>
      _defaultTypeColors[(brightness, type)]!;

  LnAlertColors copyWith({
    Color? background,
    Color? foreground,
  }) {
    return LnAlertColors(
      background: background ?? this.background,
      foreground: foreground ?? this.foreground,
    );
  }
}
