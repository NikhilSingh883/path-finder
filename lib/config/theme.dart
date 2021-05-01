import 'package:flutter/material.dart';

import '../config/size_config.dart';

class AppTheme {
  AppTheme._();
  static const Color etherRed = Color.fromRGBO(249, 45, 72, 1);
  static const Color etherDarkGrey = Color.fromRGBO(22, 22, 22, 1);
  static const Color etherGrey = Color.fromRGBO(28, 28, 28, 1);
  static const Color etherLightGrey = Color.fromRGBO(88, 88, 88, 1);
  static const Color greyHeading = Color.fromRGBO(172, 172, 172, 1);
  static const Color borderGrey = Color.fromRGBO(93, 93, 93, 1);
  static const Color grey2 = Color.fromRGBO(187, 187, 187, 1);
  static const Color grey3 = Color.fromRGBO(70, 70, 70, 1);
  static const Color grey4 = Color.fromRGBO(45, 45, 45, 1);
  static const Color grey5 = Color.fromRGBO(61, 61, 61, 1);
  static const Color grey6 = Color.fromRGBO(152, 152, 152, 1);

  static const Color notWhite = Color.fromRGBO(255, 255, 255, 1);
  static const Color nearlyWhite = Color.fromRGBO(141, 141, 141, 1);
  static const Color white = Color(0xFFFFFFFF);
  static const Color nearlyBlack = Color(0xFF213333);
  static const Color grey = Color(0xFF3A5160);
  static const Color dark_grey = Color(0xFF313A44);
  static const Color darkText = Color(0xFF253840);
  static const Color darkerText = Color(0xFF17262A);
  static const Color lightText = Color(0xFF4A6572);
  static const Color deactivatedText = Color(0xFF767676);
  static const Color dismissibleBackground = Color(0xFF364A54);
  static const Color chipBackground = Color(0xFFEEF1F3);
  static const Color spacer = Color(0xFFF2F2F2);
  static const Color registerButton = Color(0xFFD81B60);
  static const Color connectButton = Color(0xFF40C4FF);
  static const Color onLongPressColor = Color(0xFFE040FB);
  static const String fontName = 'WorkSans';
  static const Color chapterD = Color(0xFFF8BBD0);
  static const Color recentD = Color(0xFF4DB6AC);

  static final TextTheme textTheme = TextTheme(
    headline4: display1,
    headline5: headline,
    headline6: title,
    subtitle2: subtitle,
    bodyText2: body2,
    bodyText1: body1,
    caption: caption,
  );

  static final TextStyle display1 = TextStyle(
    // h4 -> display1
    fontWeight: FontWeight.w400,
    fontSize: SizeConfig.heightMultiplier * 3,
    letterSpacing: SizeConfig.widthMultiplier / 10,
    height: SizeConfig.heightMultiplier / 10,
    color: Colors.grey,
  );

  static final TextStyle headline = TextStyle(
    // h5 -> headline
    fontWeight: FontWeight.w600,
    fontSize: SizeConfig.heightMultiplier * 3.1,
    letterSpacing: SizeConfig.widthMultiplier / 10,
    color: Colors.redAccent,
  );

  static final TextStyle title = TextStyle(
    // h6 -> title
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: SizeConfig.heightMultiplier * 3,
    // letterSpacing: SizeConfig.widthMultiplier * 1,
    color: white,
  );

  static final TextStyle subtitle = TextStyle(
    // subtitle2 -> subtitle
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: SizeConfig.heightMultiplier * 1.2,
    letterSpacing: -0.04,
    color: Colors.green,
  );

  static final TextStyle body1 = TextStyle(
    // body2 -> body1
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 16,
    letterSpacing: -0.05,
    color: darkText,
  );

  static final TextStyle caption = TextStyle(
    // Caption -> caption
    fontWeight: FontWeight.w300,
    fontSize: SizeConfig.heightMultiplier * 2.8,
    letterSpacing: SizeConfig.widthMultiplier / 10,
    color: Colors.white, // was lightText
  );
  static final TextStyle selectedN = TextStyle(
    // Caption -> caption
    fontWeight: FontWeight.w300,
    fontSize: SizeConfig.heightMultiplier * 2,
    letterSpacing: SizeConfig.widthMultiplier / 10,
    color: Colors.white, // was lightText
  );
  static final TextStyle unseletedN = TextStyle(
    // Caption -> caption
    fontWeight: FontWeight.w300,
    fontSize: SizeConfig.heightMultiplier,
    letterSpacing: SizeConfig.widthMultiplier / 10,
    color: Colors.white, // was lightText
  );

  static final TextStyle hintStyle = TextStyle(
      fontWeight: FontWeight.w600,
      color: Colors.grey,
      fontSize: SizeConfig.heightMultiplier * 2);

  static final TextStyle inputStyle = TextStyle(
      fontWeight: FontWeight.w400,
      color: Colors.grey,
      fontSize: SizeConfig.heightMultiplier * 2);

// final text styles
  static final TextStyle body2 = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.w600,
    fontSize: SizeConfig.heightMultiplier * 1.85,
    color: white,
  );

  static final TextStyle body3 = TextStyle(
    fontSize: SizeConfig.heightMultiplier * 2.3,
    color: Colors.white,
    letterSpacing: SizeConfig.widthMultiplier / 3,
    fontWeight: FontWeight.w900,
  );
  static final TextStyle heading1 = TextStyle(
    fontSize: SizeConfig.heightMultiplier * 2.8,
    fontWeight: FontWeight.w900,
    letterSpacing: SizeConfig.widthMultiplier / 3,
    color: Colors.white,
  );

  static final TextStyle heading2 = TextStyle(
    fontSize: SizeConfig.heightMultiplier * 2.05,
    fontWeight: FontWeight.w700,
    // letterSpacing: SizeConfig.widthMultiplier / 3,
    color: Colors.white,
  );

  static final TextStyle title1 = TextStyle(
    fontSize: SizeConfig.heightMultiplier * 2.46,
    fontWeight: FontWeight.w700,
    letterSpacing: SizeConfig.widthMultiplier * 1.6,
    color: greyHeading,
  );
}
