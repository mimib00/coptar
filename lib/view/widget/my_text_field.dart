import 'package:copter/view/constant/colors.dart';
import 'package:copter/view/constant/other.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class MyTextField extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  var labelText, hintText;
  bool? obSecure;
  double? bottomPadding;
  TextEditingController? controller = TextEditingController();
  FormFieldValidator? validator;
  TextInputType? keyboardType;

  MyTextField({
    Key? key,
    this.labelText,
    this.hintText,
    this.bottomPadding = 25.0,
    this.controller,
    this.obSecure = false,
    required this.validator,
    this.keyboardType = TextInputType.text,
  }) : super(key: key);

  @override
  MyTextFieldState createState() => MyTextFieldState();
}

class MyTextFieldState extends State<MyTextField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: widget.bottomPadding!,
      ),
      child: TextFormField(
        keyboardType: widget.keyboardType,
        validator: widget.validator,
        controller: widget.controller,
        style: TextFieldStyling.textStyle,
        obscureText: widget.obSecure!,
        obscuringCharacter: "*",
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          prefixIcon: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${widget.labelText} : ',
                style: TextFieldStyling.labelStyle,
              ),
            ],
          ),
          hintText: '${widget.hintText}',
          hintStyle: TextFieldStyling.hintStyle,
          enabledBorder: TextFieldStyling.enableBorder,
          focusedBorder: TextFieldStyling.focusBorder,
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class CustomTextField extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  var labelText, hintText;
  bool? obSecure, haveSuffixIcon;
  TextEditingController? controller = TextEditingController();

  CustomTextField({
    Key? key,
    this.labelText,
    this.hintText,
    this.controller,
    this.obSecure = false,
    this.haveSuffixIcon = false,
    this.validator,
  }) : super(key: key);

  FormFieldValidator? validator;
  @override
  CustomTextFieldState createState() => CustomTextFieldState();
}

class CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            '${widget.labelText}',
            style: TextFieldStyling.labelStyle2,
          ),
          const SizedBox(
            height: 8,
          ),
          TextFormField(
            controller: widget.controller,
            style: TextFieldStyling.textStyle2,
            obscureText: widget.obSecure!,
            obscuringCharacter: "*",
            validator: widget.validator,
            textAlignVertical: TextAlignVertical.center,
            decoration: InputDecoration(
              suffixIcon: widget.haveSuffixIcon == true
                  ? GestureDetector(
                      onTap: () {
                        setState(() {
                          widget.obSecure = !widget.obSecure!;
                        });
                      },
                      child: Icon(
                        widget.obSecure! ? Icons.visibility_off : Icons.visibility,
                        color: kPurpleColor,
                      ),
                    )
                  : const SizedBox(
                      width: 1,
                      height: 1,
                    ),
              hintText: '${widget.hintText}',
              hintStyle: TextFieldStyling.hintStyle2,
              enabledBorder: TextFieldStyling.roundedBorder,
              focusedBorder: TextFieldStyling.roundedBorder,
            ),
          ),
        ],
      ),
    );
  }
}
