import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_color.dart';

class AppStyles {
  static TextStyle normal = GoogleFonts.poppins(
    color: const Color(0xff1D1617),
    fontSize: 18,
  );

  static TextStyle small = GoogleFonts.poppins(
    color: const Color(0xff1D1617),
    fontSize: 14,
  );

  static TextStyle small1 = GoogleFonts.poppins(
    color: AppColor.kPrimaryColor,
    fontSize: 18,
  );
  static TextStyle header = GoogleFonts.poppins(
    color: const Color(0xff1D1617),
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );

  static TextStyle underLine = GoogleFonts.poppins(
    color: const Color(0xffADA4A5),
    decoration: TextDecoration.underline,
    fontSize: 14,
  );

  static TextStyle boldFont = GoogleFonts.poppins(
    color: AppColor.kBlackColor,
    fontSize: 60,
    fontWeight: FontWeight.bold,
  );

  static TextStyle name = GoogleFonts.poppins(
    fontWeight: FontWeight.bold,
    fontSize: 24,
    color: AppColor.kPrimaryColor,
  );

  static TextStyle details = GoogleFonts.poppins(
    fontWeight: FontWeight.bold,
    fontSize: 24,
    color: AppColor.kSecondaryColor,
  );

  static TextStyle input = GoogleFonts.poppins(
    color: AppColor.kGreyColor,
    // fontWeight: FontWeight.bold,
    fontSize: 24,
  );
  static TextStyle appBar = GoogleFonts.poppins(
    color: AppColor.kBackGroundColor,
    fontWeight: FontWeight.bold,
    fontSize: 24,
  );
}
