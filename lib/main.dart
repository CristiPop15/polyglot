import 'dart:io';

import 'package:first_project/IconsCollection.dart';
import 'package:first_project/MainTabView.dart';
import 'package:flutter/material.dart';

import 'Constants.dart';
import 'IconsList.dart';
import 'PersistenceService.dart';

late Map<String, IconData?> favorites = {};
late List<IconsCollection> allCollections = [];

Future refreshFavorites() async {
  favorites.clear();
  Map<String, IconData> allIcons = new IconsList().allIcons;

  List<String> favs = await PersistenceService.instance.readAllFavorites();

  favs.forEach((element) {
    String modifiedKey = element.substring(1, element.length - 1);

    if (allIcons[modifiedKey] != null) {
      favorites.addAll(Map.of({modifiedKey: allIcons[modifiedKey]}));
    }
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

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: TextConstants.name,
      home: MyStatelessWidget(),
    );
  }
}

const List<Tab> tabs = <Tab>[
  Tab(icon: Icon(Icons.favorite,
      color: ColorsScheme.textColor,
      size: 30.0)),
  Tab(icon: Icon(Icons.collections,
      color: ColorsScheme.textColor,
      size: 30.0)),
  Tab(icon: Icon(Icons.all_inclusive_rounded,
      color: ColorsScheme.textColor,
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

