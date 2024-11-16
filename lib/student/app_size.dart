import 'package:flutter/cupertino.dart';

class AppSize {
  static late MediaQueryData mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;
  static late double blockSizeHorizontal;
  static late double blockSizeVertical;

  void initSizes(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    screenWidth = mediaQueryData.size.width;
    screenHeight = mediaQueryData.size.height;
    blockSizeHorizontal = screenWidth / 100;
    blockSizeVertical = screenWidth / 100;
  }
}