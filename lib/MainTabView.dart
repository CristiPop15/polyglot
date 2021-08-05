import 'package:first_project/CollectionsView.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'AllIconsView.dart';
import 'CustomAlertDialogWidget.dart';
import 'FavoritesView.dart';
import 'IconsCollection.dart';
import 'IconsList.dart';
import 'Constants.dart';
import 'main.dart';
import 'PersistenceService.dart';

// ignore: must_be_immutable
class MainTabView extends StatefulWidget {

  @override
  MainTabViewState createState() => MainTabViewState();
}

class MainTabViewState extends State<MainTabView> {

  late List<IconsCollection> collections;

  @override
  void initState() {
    super.initState();
    collections = allCollections;
  }

  void handleCollectionRemoval(int id) async {
    await PersistenceService.instance.deleteCollection(id);
    await refreshCollections();

    setState(() {
      Navigator.of(context, rootNavigator: true).pop();
    });
  }

  void handleNewCollectionAdded(IconsCollection collection) async {
    await PersistenceService.instance.insertCollection(collection);
    await refreshCollections();

    setState(() {
      Navigator.of(context, rootNavigator: true).pop();
      Navigator.pop(context);
    });
  }

  void handleCollectionUpdate(IconsCollection collection) async {
    await PersistenceService.instance.updateCollection(collection);
    await refreshCollections();

    setState(() {
      Navigator.of(context, rootNavigator: true).pop();
      Navigator.pop(context);
    });
  }

  void handleFavouriteChange() async {
    await refreshFavorites();

    setState(() {
      Navigator.of(context, rootNavigator: true).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      // The Builder widget is used to have a different BuildContext to access
      // closest DefaultTabController.
      child: Builder(builder: (BuildContext context) {
        final TabController tabController = DefaultTabController.of(context)!;
        tabController.addListener(() {
          if (!tabController.indexIsChanging) {
            // Your code goes here.
            // To get index of current tab use tabController.index
          }
        });
        return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(TextConstants.title,
                  style: FontsConstants.mainStyle),
              backgroundColor: ColorsScheme.backgroundAppBarColor,
              bottom: TabBar(
                indicatorColor: ColorsScheme.textColor,
                tabs: tabs,
              ),
            ),
            body: TabBarView(children: [
              //favourites
              favorites.isEmpty
                  ? Container(
                      color: ColorsScheme.backgroundColor,
                      child: Icon(Icons.favorite,
                          color: ColorsScheme.textColor, size: 50.0))
                  : FavouritesViewWidget(handleFavouriteChange),

              // list
              collections.isEmpty
                  ? Container(
                      child: Scaffold(
                          backgroundColor: ColorsScheme.backgroundColor,
                          body: Container(
                            color: ColorsScheme.backgroundColor,
                            alignment: Alignment.center,
                            child: Icon(Icons.collections,
                                color: ColorsScheme.textColor,
                                size: 50.0),
                          ),
                          floatingActionButton: FloatingActionButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        EditCollectionViewWidget(
                                            handleNewCollectionAdded, null)),
                              );
                            },
                            child: const Icon(
                              Icons.add,
                              color: ColorsScheme.textColor,
                            ),
                            backgroundColor:
                                ColorsScheme.backgroundAppBarColor,
                          )),
                    )
                  : CollectionsViewWidget(handleNewCollectionAdded,
                      handleCollectionRemoval, handleCollectionUpdate),

              //All view
              IconsList().allIcons.isEmpty
                  ? Container(
                      color: ColorsScheme.backgroundColor,
                      child: Icon(Icons.all_inclusive_rounded,
                          color: ColorsScheme.textColor, size: 50.0))
                  : AllIconsViewWidget((MapEntry<String, IconData> entry) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) =>
                            CustomAlertDialogFavoriteWidget(
                                selectedIconEntry: entry,
                                onRefresh: handleFavouriteChange),
                      );
                    }),
            ]));
      }),
    );
  }
}
