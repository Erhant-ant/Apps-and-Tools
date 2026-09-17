import 'package:flutter/foundation.dart';

enum AppLanguage { english, turkish }

final appLanguageController = ValueNotifier(AppLanguage.english);

String localized(String english, String turkish) {
  return appLanguageController.value == AppLanguage.english ? english : turkish;
}
