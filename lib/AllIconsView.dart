import 'package:first_project/TranslationService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'IconsMap.dart';
import 'Constants.dart';

// ignore: must_be_immutable
class AllIconsViewWidget extends StatefulWidget {

  late Function(MapEntry<Translation, IconData>) onEventCallback;

  AllIconsViewWidget(this.onEventCallback);

  @override
  AllIconsViewWidgetState createState() => AllIconsViewWidgetState();
}

class AllIconsViewWidgetState extends State<AllIconsViewWidget> {

  Map<Translation, IconData> iconsByName = Map.from(new IconsMap().allIcons);

  void handleQueryChanged(Map<Translation, IconData> values) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            child: ImagesGridView(
                icons: iconsByName,
                onQuerySearchItems: handleQueryChanged,
                onEventCallback: widget.onEventCallback
                )
        )
    );
  }
}

// ignore: must_be_immutable
class ImagesGridView extends StatelessWidget {
  ImagesGridView(
      {Key? key,
      required this.icons,
      required this.onQuerySearchItems,
      required this.onEventCallback})
      : super(key: key);

  final Map<Translation, IconData> icons;
  final ValueChanged<Map<Translation, IconData>> onQuerySearchItems;
  late Function(MapEntry<Translation, IconData>) onEventCallback;

  void handleQuery(String query) {
    if (query.isEmpty) {
      icons.clear();
      icons.addAll(IconsMap().allIcons);
      onQuerySearchItems(icons);
    } else {
      icons.clear();
      icons.addAll(IconsMap().allIcons);
      icons.removeWhere((key, value) => !key.getTranslation().toLowerCase().contains(query.toLowerCase()));
      onQuerySearchItems(icons);
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            color: ColorsScheme.backgroundColor,
            child: Column(children: [
              Container(
                  padding: EdgeInsets.all(16),
                  child: CupertinoSearchTextField(onChanged: (query) {
                    handleQuery(query);
                  })),
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
                          onPressed: () => onEventCallback(value),
                          icon: Icon(value.value)),
                    );
                  }).toList(),
                ),
              )
            ])
        )
    );
  }
}
