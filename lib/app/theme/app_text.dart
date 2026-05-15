import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:monisa/app/theme/app_colors.dart';

class AppText {
  static TextStyle Heading1 = GoogleFonts.calSans(
    fontSize: 26,
    fontWeight: FontWeight.w400,
    color: AppColors.black,
  );

  static TextStyle Heading2 = GoogleFonts.calSans(
    fontSize: 20,
    fontWeight: FontWeight.w400,
    color: AppColors.black,
  );

  static TextStyle SubHeading = GoogleFonts.manrope(
    fontSize: 17,
    fontWeight: FontWeight.w600,
    color: AppColors.black,
  );

  static TextStyle Body_Bold = GoogleFonts.manrope(
    fontSize: 17,
    fontWeight: FontWeight.w600,
    color: AppColors.black,
  );

  static TextStyle Body1_SemiBold = GoogleFonts.manrope(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: AppColors.black,
  );

  static TextStyle Body = GoogleFonts.manrope(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.black,
  );
}