import 'package:ln_alerts/src/localizations/alerts_localizations.dart';

class LocaleEn implements LnAlertsLocalizations {
  const LocaleEn();

  @override
  String get languageCode => 'en';

  @override
  String get information => "Information";

  @override
  String get successful => 'Successful!';

  @override
  String get warning => "Warning!";

  @override
  String get somethingWentWrong => 'Something went wrong!';

  @override
  String get ok => "OK";

  @override
  String get noResultsFound => "No results found!";
}
