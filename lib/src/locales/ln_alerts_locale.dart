import 'package:ln_core/ln_core.dart';

import 'locale_en.dart';
import 'locale_tr.dart';

final alertsLocalizationScope = LnLocalizationScope<AlertsLocale>([
  LocaleEn(),
  LocaleTr(),
]);

abstract class AlertsLocale extends LnLocale {
  const AlertsLocale(super.languageCode);

  String get successful;
  String get somethingWentWrong;
  String get ok;
  String get noResultsFound;
}
