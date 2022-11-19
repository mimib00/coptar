import 'package:copter/view/constant/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class MyText extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  var text, color, weight, align, decoration, fontFamily;
  double? size,lineHeight;
  double? paddingTop, paddingLeft, paddingRight, paddingBottom;
  // ignore: prefer_typing_uninitialized_variables
  var maxLines, overFlow;

  MyText({
    Key? key,
    @required this.text,
    this.size,
    this.maxLines = 100,
    this.lineHeight,
    this.decoration = TextDecoration.none,
    this.color = kBlackColor,
    this.weight = FontWeight.w400,
    this.align,
    this.overFlow,
    this.fontFamily = 'Poppins',
    this.paddingTop = 0,
    this.paddingRight = 0,
    this.paddingLeft = 0,
    this.paddingBottom = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: paddingTop!,
        left: paddingLeft!,
        right: paddingRight!,
        bottom: paddingBottom!,
      ),
      child: Text(
        "$text",
        style: TextStyle(
          fontSize: size,
          color: color,
          fontWeight: weight,
          decoration: decoration,
          fontFamily: '$fontFamily',
          height: lineHeight,
        ),
        textAlign: align,
        maxLines: maxLines,
        overflow: overFlow,
      ),
    );
  }
}
