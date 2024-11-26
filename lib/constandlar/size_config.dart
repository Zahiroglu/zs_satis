import 'package:flutter/cupertino.dart';

class SizeConfig {
  static MediaQueryData? _mediaQueryData;
  static double? widgethundurluk06;
  static double? widgethundurluk04;
  static double? widgethundurluk02;
  static double? widgethundurluk01;
  static double? screenWidth;
  static double? screenHeight;
  static double? safeAreaHorizontal;
  static double? safeAreaVertical;
  static double? safeBlockHorizontal;
  static double? safeBlockVertical;
  static double? topPadding;
  static double? textsizeBasliq;
  static double? textsize30SP;
  static double? textsize24SP;
  static double? textsize20SP;
  static double? textsize18SP;
  static double? textsize16SP;
  static double? textsize14SP;
  static double? textsize12SP;
  static double? textsize10SP;
  static String? screenSize;

  void init(BuildContext context){
    _mediaQueryData = MediaQuery.of(context);
    textsizeBasliq = _mediaQueryData!.size.width*0.12;
    if(_mediaQueryData!.size.height>_mediaQueryData!.size.width){
      textsize30SP = _mediaQueryData!.size.height*0.05;
      textsize18SP = _mediaQueryData!.size.height*0.03;
      textsize14SP = _mediaQueryData!.size.height*0.02;
      widgethundurluk06 = _mediaQueryData!.size.height*0.7;
      widgethundurluk04 = _mediaQueryData!.size.height*0.4;
      widgethundurluk02 = _mediaQueryData!.size.height*0.25;
      widgethundurluk01 = _mediaQueryData!.size.height*0.06;
    }else{
      textsize30SP = _mediaQueryData!.size.width*0.08;
      textsize18SP = _mediaQueryData!.size.width*0.05;
      textsize14SP = _mediaQueryData!.size.width*0.04;
      widgethundurluk06 = _mediaQueryData!.size.width*0.7;
      widgethundurluk04 = _mediaQueryData!.size.width*0.4;
      widgethundurluk02= _mediaQueryData!.size.width*0.25;
      widgethundurluk01 = _mediaQueryData!.size.width*0.06;
    }
    textsize24SP = _mediaQueryData!.size.width*0.07;
    textsize20SP = _mediaQueryData!.size.width*0.06;
    textsize16SP = _mediaQueryData!.size.width*0.045;
    textsize12SP = _mediaQueryData!.size.width*0.03;
    textsize10SP = _mediaQueryData!.size.width*0.02;
    screenWidth = _mediaQueryData!.size.width;
    screenHeight = _mediaQueryData!.size.height;
    topPadding = _mediaQueryData!.padding.top;
    safeAreaHorizontal = _mediaQueryData!.padding.left + _mediaQueryData!.padding.right;
    safeAreaVertical = _mediaQueryData!.padding.top + _mediaQueryData!.padding.bottom;
    safeBlockHorizontal = (screenWidth! - safeAreaHorizontal!) / 100;
    safeBlockVertical = (screenHeight! - safeAreaVertical!) / 100;
    if(screenWidth! >= 600){
      screenSize = 'tablet';
    }
    else if(screenWidth! >= 400){
      screenSize = 'largeMobile';
    }
    else{
      screenSize = 'smallMobile';
    }

  }

}
