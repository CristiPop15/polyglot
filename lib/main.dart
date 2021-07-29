import 'dart:io';

import 'package:first_project/IconsCollection.dart';
import 'package:first_project/MainTabView.dart';
import 'package:first_project/PolyglotColorScheme.dart';
import 'package:flutter/material.dart';

import 'IconsList.dart';
import 'PersistenceService.dart';

late Map<String, IconData?> favorites = {};
late List<IconsCollection> allCollections = [];

Future refreshFavorites() async {
  favorites.clear();
  Map<String, IconData> allIcons = new IconsList().allIcons;

  await PersistenceService.instance.readAllFavorites().then((value) {
    value.forEach((element) {

      String modifiedKey = element.substring(1, element.length-1);

      if (allIcons[modifiedKey] != null) {
        favorites.addAll(Map.of({modifiedKey: allIcons[modifiedKey]}));
      }
    });
  });
}

Future refreshCollections() async {
  allCollections.clear();

  await PersistenceService.instance.readAllCollections().then((value) {
    allCollections.addAll(value);
  });
}

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await refreshFavorites();
  await refreshCollections();

  // PersistenceService.instance.clearAll();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String _title = 'Polyglot';

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: _title,
      home: MyStatelessWidget(),
    );
  }
}

const List<Tab> tabs = <Tab>[
  Tab(icon: Icon(Icons.favorite,
    color: PolyglotColorScheme.textColor,
    size: 30.0)),
  Tab(icon: Icon(Icons.collections,
      color: PolyglotColorScheme.textColor,
      size: 30.0)),
  Tab(icon: Icon(Icons.all_inclusive_rounded,
      color: PolyglotColorScheme.textColor,
      size: 30.0)),
];

/// This is the stateless widget that the main application instantiates.
class MyStatelessWidget extends StatelessWidget {
  const MyStatelessWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return MainTabView();
  }
}

