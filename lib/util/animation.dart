import 'package:flutter/material.dart';

class UtilAnimation {

  static setRotate(Widget widget){
    return (BuildContext context, Animation<double> animation, Animation secondaryAnimation) {
      return RotationTransition(
        turns: animation,
        child: widget,
      );
    };
  }

  static setSize(Widget widget){
    return (BuildContext context, Animation<double> animation, Animation secondaryAnimation) {
      return SizeTransition(
        sizeFactor: animation,
        child: widget,
      );
    };
  }

  static setScale(Widget widget){
    return (BuildContext context, Animation<double> animation, Animation secondaryAnimation) {
      return ScaleTransition(
        scale: animation,
        child: widget,
      );
    };
  }

  static setFade(Widget widget){
    return (BuildContext context, Animation<double> animation, Animation secondaryAnimation) {
      return FadeTransition(
        opacity: animation,
        child: widget,
      );
    };
  }

}