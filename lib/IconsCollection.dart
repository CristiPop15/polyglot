import 'package:first_project/IconsMap.dart';
import 'package:flutter/cupertino.dart';

class IconsCollection {
  int id;
  String name;
  Map<String, IconData?> collections = {};

  IconsCollection(this.id, this.name);

  IconsCollection add(MapEntry<String, IconData?> value) {
    collections[value.key] = value.value;
    return this;
  }

  IconsCollection addFromKey(String key) {
    collections[key] = new IconsMap().allIcons[key];
    return this;
  }

  IconsCollection addAll(Map<String, IconData?> map) {
    collections = Map.of(map);
    return this;
  }

  Map<String, IconData?> getIcons() {
    return collections;
  }
}