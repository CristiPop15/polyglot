import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'CustomAlertDialogWidget.dart';
import 'Constants.dart';
import 'main.dart';


// ignore: must_be_immutable
class FavouritesViewWidget extends StatefulWidget {

  final Function favoritesChange;

  FavouritesViewWidget(this.favoritesChange);

  @override
  FavouritesViewState createState() => FavouritesViewState();
}

class FavouritesViewState extends State<FavouritesViewWidget> {

  late Map<String, IconData?> favoriteIcons;

  @override
  void initState() {
    super.initState();
    favoriteIcons = favorites;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            child: ImagesGridView(
              icons: favoriteIcons,
              onFavouriteChange: widget.favoritesChange,
            )));
  }
}

class ImagesGridView extends StatelessWidget {
  ImagesGridView({Key? key, required this.icons, required this.onFavouriteChange})
      : super(key: key);

  final Map<String, IconData?> icons;
  final Function onFavouriteChange;

  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            color: ColorsScheme.backgroundColor,
            child: Column(children: [
              Expanded(
                child: GridView.count(
                  crossAxisCount: 4,
                  childAspectRatio: 2,
                  children: icons.entries.map((value) {
                    return Container(
                      alignment: Alignment.center,
                      child: IconButton(
                          iconSize: 40,
                          color: ColorsScheme.iconColor,
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  CustomAlertDialogWidget(selectedIconEntry: value, onRefresh: onFavouriteChange),
                            );
                          },
                          icon: Icon(value.value)),
                    );
                  }).toList(),
                ),
              )
            ])));
  }
}