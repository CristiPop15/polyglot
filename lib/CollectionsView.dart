import 'package:first_project/AllIconsView.dart';
import 'package:first_project/PolyglotColorScheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'IconsCollection.dart';
import 'main.dart';

// ignore: must_be_immutable
class CollectionsViewWidget extends StatefulWidget {

  final ValueChanged<IconsCollection> onCollectionChange;
  final ValueChanged<IconsCollection> onCollectionUpdate;
  final ValueChanged<int> onCollectionRemoval;

  CollectionsViewWidget(this.onCollectionChange, this.onCollectionRemoval, this.onCollectionUpdate);

  @override
  CollectionsViewWidgetState createState() => CollectionsViewWidgetState();
}

class CollectionsViewWidgetState extends State<CollectionsViewWidget> {

  late List<IconsCollection> collections;

  @override
  void initState() {
    super.initState();
    collections = allCollections;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PolyglotColorScheme.backgroundColor,
      body: ListView.separated(
          padding: const EdgeInsets.all(8),
          itemCount: collections.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
                onLongPress: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EditCollectionViewWidget(widget.onCollectionUpdate, collections[index])),
                  );
                },
                tileColor: PolyglotColorScheme.tileColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(300)),
                ),
                trailing: new IconButton(
                  icon: new Icon(Icons.delete_outline, color: PolyglotColorScheme.removeButtonColor,),
                  onPressed: () {
                    showDialog(context: context, builder: (BuildContext context) =>
                        Center(child: CircularProgressIndicator())
                    );
                    widget.onCollectionRemoval(collections[index].id);
                    },),

                leading: new Icon(
                  collections[index].collections.values.isNotEmpty
                      ?
                  collections[index].collections.values.first
                      :
                  Icons.collections,
                  color: PolyglotColorScheme.iconColor,
                  size: 30,
                ),
                title: Text(
                  '${collections[index].name}',
                  style: TextStyle(
                      color: PolyglotColorScheme.textColor,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Finger",
                      fontSize: 14),
                ));
          },
          separatorBuilder: (BuildContext context, int index) =>
              const Divider()),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => EditCollectionViewWidget(widget.onCollectionChange, null)),
          );
        },
        child: const Icon(
          Icons.add,
          color: PolyglotColorScheme.textColor,
        ),
        backgroundColor: PolyglotColorScheme.backgroundAppBarColor,
      ),
    );
  }
}

// ignore: must_be_immutable
class EditCollectionViewWidget extends StatefulWidget {

  IconsCollection? editIconsCollection;
  Map<String, IconData?> newCollection = {};
  ValueChanged<IconsCollection> onCollectionChange;

  EditCollectionViewWidget(this.onCollectionChange, this.editIconsCollection);

  @override
  EditCollectionViewWidgetState createState() =>
      EditCollectionViewWidgetState();
}

class EditCollectionViewWidgetState extends State<EditCollectionViewWidget> {

  TextEditingController collectionNameController = TextEditingController();
  ScrollController scrollController = ScrollController();
  bool needsScroll = true;
  final collectionNameKey = GlobalKey<FormState>();
  bool updateCollection = false;

  @override
  // ignore: must_call_super
  void initState() {
    super.initState();

    if(widget.editIconsCollection != null) {
      collectionNameController.text = widget.editIconsCollection!.name;
      widget.newCollection.addAll(widget.editIconsCollection!.getIcons());
      updateCollection = true;
    }
  }

  scrollToBottom() {
    scrollController.jumpTo(scrollController.position.maxScrollExtent);
    needsScroll = true;
  }

  void handleIconChange(MapEntry<String, IconData?> iconChanged) {
    setState(() {
      if (widget.newCollection.containsKey(iconChanged.key)) {
        widget.newCollection.remove(iconChanged.key);
      } else {
        widget.newCollection[iconChanged.key] = iconChanged.value;
      }
    });

    needsScroll = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: PolyglotColorScheme.backgroundColor,
        appBar: AppBar(
          centerTitle: true,
          title: Text("P o l y g l o t",
              style: TextStyle(
                  color: PolyglotColorScheme.textColor,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Finger",
                  fontSize: 24)),
          backgroundColor: PolyglotColorScheme.backgroundAppBarColor,
        ),
        body: Form(
          key: collectionNameKey,
          child: Column(
            children: [
              Container(
                  padding: const EdgeInsets.all(8),
                  child: Text("Create your collection",
                      style: TextStyle(
                          color: PolyglotColorScheme.backgroundAppBarColor,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Finger",
                          fontSize: 16))),
              Container(
                padding: const EdgeInsets.all(8),
                child: buildCustomTextFormField(),
              ),
              Container(
                  height: 70,
                  child: ListView.separated(
                    separatorBuilder: (BuildContext context, int index) =>
                        const Divider(),
                    controller: scrollController,
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.newCollection.length,
                    itemBuilder: (BuildContext context, int index) {
                      autoscroll();
                      return Container(
                          width: 70,
                          height: 70,
                          child: CustomIconWithRemovalButton(
                              widget.newCollection.entries.elementAt(index),
                              50,
                              handleIconChange));
                    },
                  )),
              Expanded(child: AllIconsViewWidget(handleIconChange)),
              IconButton(
                onPressed: () {
                  if (collectionNameKey.currentState!.validate()) {
                    showDialog(context: context, builder: (BuildContext context) =>
                        Center(child: CircularProgressIndicator())
                    );

                    IconsCollection iconCollection = new IconsCollection(0,
                        collectionNameController.value.text).addAll(widget.newCollection);

                    if (updateCollection) {
                      widget.editIconsCollection!.name = collectionNameController.value.text;
                      widget.editIconsCollection!.collections.clear();
                      widget.editIconsCollection!.collections.addAll(widget.newCollection);

                      iconCollection = new IconsCollection(widget.editIconsCollection!.id,
                          widget.editIconsCollection!.name).addAll(widget.editIconsCollection!.collections);
                    }

                    widget.onCollectionChange(iconCollection);
                  }
                },
                icon: new Icon(
                  Icons.save,
                  color: PolyglotColorScheme.backgroundAppBarColor,
                  size: 40,
                ),
                padding: const EdgeInsets.fromLTRB(0, 2, 0, 50),
              ),
            ],
          ),
        ));
  }

  void autoscroll() {
    if (needsScroll) {
      WidgetsBinding.instance!.addPostFrameCallback((_) => scrollToBottom());

      needsScroll = false;
    }
  }

  TextFormField buildCustomTextFormField() {
    return TextFormField(
      validator: collectionNameValidator,
      controller: collectionNameController,
      style: TextStyle(
          color: PolyglotColorScheme.backgroundAppBarColor,
          fontWeight: FontWeight.bold,
          fontFamily: "Finger",
          fontSize: 13),
      cursorColor: PolyglotColorScheme.tileColor,
      decoration: new InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(300)),
            borderSide: BorderSide(
                color: PolyglotColorScheme.borderFocused, width: 1.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(300)),
            borderSide:
                BorderSide(color: PolyglotColorScheme.tileColor, width: 1.5),
          ),
          hintText: 'Collection name',
          hintStyle: TextStyle(
              fontFamily: "Finger",
              color: PolyglotColorScheme.hintTextColor,
              fontSize: 13),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(300)),
            borderSide: BorderSide(
                color: PolyglotColorScheme.borderFocused, width: 1.5),
          ),
          errorStyle: TextStyle(
              color: PolyglotColorScheme.removeButtonColor,
              fontWeight: FontWeight.bold,
              fontFamily: "Finger",
              fontSize: 10),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(300)),
            borderSide: BorderSide(
                color: PolyglotColorScheme.borderFocused, width: 1.5),
          )
      ),
    );
  }

  String? collectionNameValidator(value) {
    if (value == null || value.isEmpty) {
      return "Please enter collection name";
    }
    if (value.length > 25) {
      return "Please limit to 25 characters";
    }

    RegExp regex = new RegExp('^[a-zA-Z0-9_ .-]*\$');
    if (!regex.hasMatch(value)) {
      return "Unsupported character(s). Please use only alphanumerical, _ and -";
    }
    return null;
  }
}

// ignore: must_be_immutable
class CustomIconWithRemovalButton extends StatelessWidget {
  late MapEntry<String, IconData?> icon;
  double iconSize;
  ValueChanged<MapEntry<String, IconData?>> onIconChange;

  CustomIconWithRemovalButton(this.icon, this.iconSize, this.onIconChange);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Container(
        padding: const EdgeInsets.all(10),
        color: PolyglotColorScheme.backgroundColor,
        child: Stack(
          alignment: Alignment.topCenter,
          clipBehavior: Clip.none,
          fit: StackFit.loose,
          children: [
            Icon(
              icon.value,
              size: iconSize,
              color: PolyglotColorScheme.iconColor,
            ),
            Positioned(
                top: -5,
                right: -5,
                child: GestureDetector(
                    onTap: () {
                      onIconChange(icon);
                    },
                    child: Icon(
                      Icons.delete_forever,
                      size: 20,
                      color: PolyglotColorScheme.removeButtonColor,
                    ))),
          ],
        ),
      ),
    ));
  }
}
