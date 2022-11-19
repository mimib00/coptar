import 'package:copter/view/constant/colors.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class MyButton extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  var text, weight, textColor, btnBgColor, radius;
  double? textSize, height, elevation;
  VoidCallback? onPressed;
  bool? haveRoundedEdges, haveCustomElevation;

  MyButton({
    Key? key,
    this.text,
    this.textSize = 16,
    this.haveRoundedEdges = false,
    this.haveCustomElevation = false,
    this.textColor = kPrimaryColor,
    this.btnBgColor = kSecondaryColor,
    this.height = 50,
    this.elevation = 0,
    this.radius = 10.0,
    this.weight = FontWeight.w500,
    this.onPressed,
  }) : super(key: key);

  @override
  MyButtonState createState() => MyButtonState();
}

class MyButtonState extends State<MyButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: widget.haveCustomElevation!
          ? BoxDecoration(
              borderRadius: widget.haveRoundedEdges! ? BorderRadius.circular(50) : BorderRadius.circular(widget.radius),
              boxShadow: [
                BoxShadow(
                  color: widget.btnBgColor.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(2, 2),
                ),
              ],
            )
          : const BoxDecoration(),
      child: MaterialButton(
        disabledColor: kPurpleColor,
        elevation: widget.elevation,
        highlightElevation: widget.elevation,
        onPressed: widget.onPressed,
        color: widget.btnBgColor,
        height: widget.height,
        shape: widget.haveRoundedEdges == true
            ? const StadiumBorder()
            : RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(widget.radius),
              ),
        child: Text(
          '${widget.text}',
          style: TextStyle(
            fontSize: widget.textSize,
            color: widget.textColor,
            fontWeight: widget.weight,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
