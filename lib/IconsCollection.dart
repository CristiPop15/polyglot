import 'package:first_project/IconsMap.dart';
import 'package:flutter/cupertino.dart';

import 'TranslationService.dart';

class IconsCollection {
  int id;
  String name;
  Map<Translation, IconData?> collections = {};

  IconsCollection(this.id, this.name);

  IconsCollection add(MapEntry<Translation, IconData?> value) {
    collections[value.key] = value.value;
    return this;
  }

  IconsCollection addFromKey(String key) {
    collections[Translation(key)] = new IconsMap().allIcons[Translation(key)];
    return this;
  }

  IconsCollection addAll(Map<Translation, IconData?> map) {
    collections = Map.of(map);
    return this;
  }

  Map<Translation, IconData?> getIcons() {
    return collections;
  }
}