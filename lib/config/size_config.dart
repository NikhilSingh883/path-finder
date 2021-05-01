import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class SizeConfig {
  static double _screenWidth;
  static double _screenHeight;
  static double _blockWidth = 0;
  static double _blockHeight = 0;

  static double textMultiplier;
  static double imageSizeMultiplier;
  static double heightMultiplier;
  static double widthMultiplier;
  // static bool isPortrait = true;
  // static bool isMobilePortrait = false;

  void init(BoxConstraints constraints) {
    _screenWidth = constraints.maxWidth;
    _screenHeight = constraints.maxHeight;

    _blockWidth = _screenWidth / 100;
    _blockHeight = _screenHeight / 100;

    heightMultiplier = _blockHeight;
    widthMultiplier = _blockWidth;
    textMultiplier = widthMultiplier;

    print(_screenHeight);
    print(_screenWidth);
  }
}
