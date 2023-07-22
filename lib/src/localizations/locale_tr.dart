import 'package:ln_alerts/src/localizations/alerts_localizations.dart';

class LocaleTr implements LnAlertsLocalizations {
  const LocaleTr();

  @override
  String get languageCode => 'tr';

  @override
  String get information => "Bilgilendirme";

  @override
  String get successful => 'Başarılı!';

  @override
  String get warning => "Uyarı!";

  @override
  String get somethingWentWrong => 'Bir şeyler ters gitti!';

  @override
  String get ok => "Tamam";

  @override
  String get noResultsFound => "Hiçbir sonuç bulunamadı!";
}
