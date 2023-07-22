import 'package:flutter/material.dart';
import 'package:ln_core/ln_core.dart';

import 'locale_en.dart';
import 'locale_tr.dart';

abstract class LnAlertsLocalizations extends LnLocalizations {
  const LnAlertsLocalizations(super.languageCode);

  String get information;
  String get successful;
  String get warning;
  String get somethingWentWrong;
  String get ok;
  String get noResultsFound;

  static const delegate = LnLocalizationsDelegate<LnAlertsLocalizations>(
    [LocaleEn(), LocaleTr()],
    _setInstance,
  );

  static _setInstance(LnAlertsLocalizations loc) => _instance = loc;
  static LnAlertsLocalizations? _instance;
  static LnAlertsLocalizations get current {
    assert(
        _instance != null, "No AlertsLocalizations instance created before!");
    return _instance!;
  }

  static LnAlertsLocalizations of(BuildContext context) =>
      Localizations.of<LnAlertsLocalizations>(context, LnAlertsLocalizations)!;
}
