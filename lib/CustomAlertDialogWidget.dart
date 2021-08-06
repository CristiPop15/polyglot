import 'package:first_project/IconsMap.dart';
import 'package:first_project/PersistenceService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:swipe_to/swipe_to.dart';

import 'Constants.dart';
import 'TranslationService.dart';
import 'main.dart';

class CustomAlertDialogFavoriteWidget extends StatefulWidget {

  final MapEntry<Translation, IconData?> selectedIconEntry;
  final Function onRefresh;

  const CustomAlertDialogFavoriteWidget({required this.selectedIconEntry, required this.onRefresh}) : super();

  @override
  CustomAlertDialogFavoriteWidgetState createState() => CustomAlertDialogFavoriteWidgetState();
}

class CustomAlertDialogFavoriteWidgetState extends State<CustomAlertDialogFavoriteWidget> {

  late IconData favouriteIcon;
  late bool isLoading = false;

  @override
  void initState() {
    super.initState();

    favouriteIcon = favorites.containsKey(widget.selectedIconEntry.key)
        ? Icons.favorite
        : Icons.favorite_outline;
  }

  void handleTap(MapEntry<Translation, IconData?> iconEntry) async {
    showDialog(context: context, builder: (BuildContext context) =>
        Center(child: CircularProgressIndicator())
    );

    String key = iconEntry.key.key;
    IconData favoriteState;

    if (iconEntry.key.key.endsWith(")")) {
      key = iconEntry.key.key.substring(1, iconEntry.key.key.length - 1);
    }

    if (favorites.containsKey(Translation(key))) {
      await PersistenceService.instance.deleteFavorites(key);
      favoriteState = Icons.favorite_outline;
    } else {
      await PersistenceService.instance.insertFavorites(key);
      favoriteState = Icons.favorite;
    }

    await widget.onRefresh();
    
    setState(() {
      isLoading = false;
      favouriteIcon = favoriteState;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30)),
        ),
        backgroundColor: ColorsScheme.backgroundColor,
        title: new Column(children: <Widget>[
          new Text(widget.selectedIconEntry.key.translation),
          new Container(
              child: IconButton(
                icon: new Icon(favouriteIcon,
                    size: 40.0, color: ColorsScheme.textColor),
                onPressed: () {
                  handleTap(widget.selectedIconEntry);
                },
              ))
        ]),
        content: new Icon(widget.selectedIconEntry.value,
            size: 200, color: ColorsScheme.iconColor));
  }
}

class CustomAlertDialogCollectionWidget extends StatefulWidget {

  final MapEntry<Translation, IconData?> selectedIconEntry;
  final Map<Translation, IconData?> collectionIcons;

  const CustomAlertDialogCollectionWidget({required this.selectedIconEntry, required this.collectionIcons}) : super();

  @override
  CustomAlertDialogCollectionWidgetState createState() => CustomAlertDialogCollectionWidgetState();
}

class CustomAlertDialogCollectionWidgetState extends State<CustomAlertDialogCollectionWidget> {

  late MapEntry<Translation, IconData?> selection;
  late int size;
  late int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    selection = widget.selectedIconEntry;
    size = widget.collectionIcons.length;
    for(int i = 0; i < size; i++) {
      if (widget.collectionIcons.entries.elementAt(i).key == selection.key) {
        currentIndex = i;
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return new AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30)),
        ),
        backgroundColor: ColorsScheme.backgroundColor,
        title: SwipeTo(
          child: new Column(children: <Widget>[
            new Text(selection.key.translation),
            new Icon(selection.value,
                size: 200, color: ColorsScheme.iconColor)
          ]),
          iconOnLeftSwipe: Icons.arrow_forward,
          iconOnRightSwipe: Icons.arrow_back,
          onLeftSwipe: () {
            setState(() {
              if (currentIndex < size-1) {
                ++currentIndex;
                selection = widget.collectionIcons.entries.elementAt(currentIndex);
              }

            });
          },
          onRightSwipe: () {
            setState(() {
              if (currentIndex > 0) {
                --currentIndex;
                selection = widget.collectionIcons.entries.elementAt(currentIndex);
              }
            });
            },
        )
        );
  }
}