import 'package:ln_alerts/src/locales/ln_alerts_locale.dart';

class LocaleEn implements AlertsLocale {
  const LocaleEn();

  @override
  String get languageCode => 'en';

  @override
  String get somethingWentWrong => 'Something went wrong!';

  @override
  String get successful => 'Successful!';

  @override
  String get ok => "OK";

  @override
  String get noResultsFound => "No results found!";
}
