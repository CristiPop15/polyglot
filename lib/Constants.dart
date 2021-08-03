import 'dart:ui';

import 'package:flutter/material.dart';

class ColorsScheme {
  static const Color backgroundColor = Color.fromARGB(255, 191, 249, 255);
  static const Color backgroundAppBarColor = Color.fromARGB(255, 0, 166, 203);
  static const Color iconColor = Color.fromARGB(255, 0, 129, 142);
  static const Color tileColor = Color.fromARGB(255, 21, 180, 217);
  static const Color borderFocused = Color.fromARGB(128, 21, 180, 217);
  static const Color textColor = Colors.amberAccent;
  static const Color hintTextColor = Color.fromARGB(139, 116, 116, 116);
  static const Color removeButtonColor = Color.fromARGB(218, 255, 82, 82);
}

class TextConstants {
  static const String title = "P o l y g l o t";
  static const String name = "Polyglot";
  static const String collectionCreation = "Create your collection";
  static const String collectionHint = "Collection name";
  static const String collectionNameError = "Please enter collection name";
  static const String collectionNameLimitError = "Please limit to 25 characters";
  static const String collectionUnsupportedCharacterError = "Use only alphanumerical, underscore(_) and dash(-) characters";
}

class FontsConstants {
  static const TextStyle mainStyle = TextStyle(
      color: ColorsScheme.textColor,
      fontWeight: FontWeight.bold,
      fontFamily: "Finger",
      fontSize: 24);

  static const TextStyle errorStyle = TextStyle(
      color: ColorsScheme.removeButtonColor,
      fontWeight: FontWeight.bold,
      fontFamily: "Finger",
      fontSize: 10);

  static const TextStyle collectionTileStyle = TextStyle(
      color: ColorsScheme.textColor,
      fontWeight: FontWeight.bold,
      fontFamily: "Finger",
      fontSize: 14);

  static const TextStyle collectionActionStyle = TextStyle(
      color: ColorsScheme.backgroundAppBarColor,
      fontWeight: FontWeight.bold,
      fontFamily: "Finger",
      fontSize: 16);

  static const TextStyle hintStyle = TextStyle(
      fontFamily: "Finger",
      color: ColorsScheme.hintTextColor,
      fontSize: 13);

  static const TextStyle formStyle = TextStyle(
      color: ColorsScheme.backgroundAppBarColor,
      fontWeight: FontWeight.bold,
      fontFamily: "Finger",
      fontSize: 13);
}
