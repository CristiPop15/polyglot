import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';

class Translation {
  String translation = '';
  String key= '';

  Translation(String key) {
    this.key = key;
    String? nullableValue = TranslationService.translationByKey[key];
    if (nullableValue != null) {
      this.translation = nullableValue;
    }
  }

  String getKey() {
    return key;
  }

  String getTranslation() {
    return translation;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Translation &&
          runtimeType == other.runtimeType &&
          translation == other.translation &&
          key == other.key;

  @override
  int get hashCode => translation.hashCode ^ key.hashCode;
}

class TranslationService {

  static Map<String, String> translationByKey = {};
  static String lastCountryCode = "";

  static init() async {
    // init translationByKey

    print("init translation service");

    String countryCode = Platform.localeName.substring(0,2);
    if (countryCode == lastCountryCode && translationByKey.isNotEmpty) {
      return;
    }

    print(countryCode);
    String translationJson = '';

    try {
      translationJson = await rootBundle.loadString('translation/'+ countryCode +'.json');

    } catch(Exception) {
      //default english
      print("using default english");
      translationJson = await rootBundle.loadString('translation/en.json');
    }

    Map<String, dynamic> translationMap = JsonDecoder().convert(translationJson);

    translationMap.entries.forEach((element) {
      translationByKey[element.key] = element.value.toString();
    });
  }
}