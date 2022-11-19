import 'package:copter/view/constant/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

var defaultPadding = const EdgeInsets.symmetric(
  horizontal: 15,
  vertical: 20,
);

var iconBg = BoxDecoration(
  color: kLightGreyColor,
  borderRadius: BorderRadius.circular(10),
);

var customDivider = Container(
  height: 1,
  width: Get.width,
  color: kPurpleColor,
);

class RadiusHandler {
  static var radius9 = BorderRadius.circular(9);
  static var radius10 = BorderRadius.circular(10);
  static var radius12 = BorderRadius.circular(12);
  static var radius14 = BorderRadius.circular(14);
  static var radius16 = BorderRadius.circular(16);
  static var radius18 = BorderRadius.circular(18);
  static var radius20 = BorderRadius.circular(20);
  static var radius100 = BorderRadius.circular(100);

  // Rounded Rectangle
  static var roundedRadius9 = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(9),
  );
  static var roundedRadius10 = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(10),
  );
  static var roundedRadius12 = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12),
  );
  static var roundedRadius14 = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(14),
  );
  static var roundedRadius16 = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(16),
  );
  static var roundedRadius18 = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(18),
  );
  static var roundedRadius20 = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(20),
  );
  static var roundedRadius100 = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(100),
  );
}

class TextFieldStyling {
  static const textStyle = TextStyle(
    fontSize: 14,
    color: kBlackColor,
  );
  static const textStyle2 = TextStyle(
    fontSize: 14,
    color: kDarkPurpleColor,
  );
  static const labelStyle = TextStyle(
    fontSize: 14,
    color: kBlackColor2,
  );
  static const labelStyle2 = TextStyle(
    fontSize: 14,
    color: kBlackColor,
  );
  static const hintStyle = TextStyle(
    fontSize: 14,
    color: kTertiaryColor,
  );
  static const hintStyle2 = TextStyle(
    fontSize: 14,
    color: kLightPurpleColor2,
  );
  static const enableBorder = UnderlineInputBorder(
    borderSide: BorderSide(
      color: kBorderColor,
      width: 1.0,
    ),
  );
  static const focusBorder = UnderlineInputBorder(
    borderSide: BorderSide(
      color: kBorderColor,
      width: 1.0,
    ),
  );
  static var roundedBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: const BorderSide(
      color: kBorderColor,
      width: 1.0,
    ),
  );
  static const noBorder = InputBorder.none;
}
