import 'package:ln_alerts/src/locales/ln_alerts_locale.dart';

class LocaleTr implements AlertsLocale {
  const LocaleTr();

  @override
  String get languageCode => 'tr';

  @override
  String get somethingWentWrong => 'Bir şeyler ters gitti!';

  @override
  String get successful => 'Başarılı!';

  @override
  String get ok => "Tamam";

  @override
  String get noResultsFound => "Hiçbir sonuç bulunamadı!";
}
