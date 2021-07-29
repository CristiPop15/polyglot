import 'package:first_project/PersistenceService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'PolyglotColorScheme.dart';
import 'main.dart';

class CustomAlertDialogWidget extends StatefulWidget {

  final MapEntry<String, IconData?> selectedIconEntry;
  final Function onRefresh;

  const CustomAlertDialogWidget({required this.selectedIconEntry, required this.onRefresh}) : super();

  @override
  CustomAlertDialogWidgetState createState() => CustomAlertDialogWidgetState();
}

class CustomAlertDialogWidgetState extends State<CustomAlertDialogWidget> {

  late IconData favouriteIcon;
  late bool isLoading = false;

  @override
  void initState() {
    super.initState();

    favouriteIcon = favorites.containsKey(widget.selectedIconEntry.key)
        ? Icons.favorite
        : Icons.favorite_outline;
  }

  void handleTap(MapEntry<String, IconData?> iconEntry) async {
    showDialog(context: context, builder: (BuildContext context) =>
        Center(child: CircularProgressIndicator())
    );

    String key = iconEntry.key;
    IconData favoriteState;

    if (iconEntry.key.endsWith(")")) {
      key = iconEntry.key.substring(1, iconEntry.key.length - 1);
    }

    if (favorites.containsKey(key)) {
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
        backgroundColor: PolyglotColorScheme.backgroundColor,
        title: new Column(children: <Widget>[
          new Text(widget.selectedIconEntry.key),
          new Container(
              child: IconButton(
                icon: new Icon(favouriteIcon,
                    size: 40.0, color: PolyglotColorScheme.textColor),
                onPressed: () {
                  handleTap(widget.selectedIconEntry);
                },
              ))
        ]),
        content: new Icon(widget.selectedIconEntry.value,
            size: 170, color: PolyglotColorScheme.iconColor));
  }
}