import 'package:flutter/cupertino.dart';
import 'package:ui_challenge_day_two/constants/projectColors.dart';

/**
 * @description : CartModel to abstract the draw from it
 */

class ViewCard {
  Color? _backgrounColor;
  Color? _fontColor;
  ViewCard() {
    _backgrounColor = Constants.KBlackColor;
    _fontColor = Constants.KWhiteColor;
  }

  getBackGroundColor() {
    return _backgrounColor;
  }

  get_FontColor() {
    return _fontColor;
  }

  setBackGroundColor(Color color) {
    _backgrounColor = color;
  }

  set_FontColor(Color color) {
    _fontColor = color;
  }
}

class GreenViewCard extends ViewCard {
  @override
  getBackGroundColor() {
    return Constants.KGreenColor;
  }

  @override
  get_FontColor() {
    return Constants.KBlackColor;
  }
}

class YellowViewCard extends ViewCard {
  @override
  getBackGroundColor() {
    return Constants.KYellowColor;
  }

  @override
  get_FontColor() {
    return Constants.KBlackColor;
  }
}

class PinkViewCard extends ViewCard {
  @override
  getBackGroundColor() {
    return Constants.KPinkColor;
  }

  @override
  get_FontColor() {
    return Constants.KBlackColor;
  }
}
