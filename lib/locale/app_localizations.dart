import 'package:flutter/material.dart';
import 'package:granth_flutter/locale/language_af.dart';
import 'package:granth_flutter/locale/language_ar.dart';
import 'package:granth_flutter/locale/language_de.dart';
import 'package:granth_flutter/locale/language_en.dart';
import 'package:granth_flutter/locale/language_es.dart';
import 'package:granth_flutter/locale/language_fr.dart';
import 'package:granth_flutter/locale/language_hi.dart';
import 'package:granth_flutter/locale/language_id.dart';
import 'package:granth_flutter/locale/language_nl.dart';
import 'package:granth_flutter/locale/language_sq.dart';
import 'package:granth_flutter/locale/language_tr.dart';
import 'package:granth_flutter/locale/language_vi.dart';
import 'package:granth_flutter/locale/languages.dart';
import 'package:nb_utils/nb_utils.dart';

import 'language_gu.dart';
import 'language_pt.dart';

class AppLocalizations extends LocalizationsDelegate<BaseLanguage> {
  const AppLocalizations();

  @override
  Future<BaseLanguage> load(Locale locale) async {
    switch (locale.languageCode) {
      case 'en':
        return LanguageEn();
      case 'ar':
        return LanguageAr();
      case 'hi':
        return LanguageHi();
      case 'af':
        return LanguageAf();
      case 'de':
        return LanguageDe();
      case 'es':
        return LanguageEs();
      case 'fr':
        return LanguageFr();
      case 'gu':
        return LanguageGu();
      case 'id':
        return LanguageId();
      case 'nl':
        return LanguageNl();
      case 'pt':
        return LanguagePt();
      case 'sq':
        return LanguageSq();
      case 'tr':
        return LanguageTr();
      case 'vi':
        return LanguageVi();

      default:
        return LanguageEn();
    }
  }

  @override
  bool isSupported(Locale locale) => LanguageDataModel.languages().contains(locale.languageCode);

  @override
  bool shouldReload(LocalizationsDelegate<BaseLanguage> old) => false;
}
