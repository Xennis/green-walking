enum Language { de, en }

extension LanguageExtension on Language {
  String get code {
    switch (this) {
      case Language.de:
        return 'de';
      case Language.en:
      default:
        return 'en';
    }
  }
}

Language languageFromString(String code) {
  switch (code) {
    case 'de':
      return Language.de;
    case 'en':
    default:
      return Language.en;
  }
}
