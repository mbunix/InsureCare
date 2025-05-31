import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData getAppTheme() {
    return ThemeData(
      fontFamily: GoogleFonts.quicksand().fontFamily,
      primaryColor: AppColors.themeColors.primaryColor,
      primaryColorDark: AppColors.themeColors.primaryDarkColor,
      textSelectionTheme: TextSelectionThemeData(
        selectionColor: AppColors.themeColors.textSelectionColor,
      ),
      textTheme: textTheme, colorScheme: ColorScheme.light(
        primary: AppColors.themeColors.primaryColor,
        secondary: AppColors.themeColors.accentColor,
      ).copyWith(background: AppColors.themeColors.primaryColor),
    );
  }
}

class AppColors {
  static ThemeColors themeColors = ThemeColors(
    pureWhiteColor,
    greenColor,
    orangeColor,
    blueColor,
    lightBlueHighlightColor,
  );
  static const Color blueColor = Color(0xFF2D0BFB);
  static const Color orangeColor = Color(0xFFEE7608);
  static const Color greenColor = Color(0xFF028627);
  static const Color pureWhiteColor = Color(0xFFF3F1F1);
  static const Color lightBlueHighlightColor = Color(0xFF0C1FC8);
  static const Color backgroundColor = Color(0xFFD9D9D9);
  static const Color blackTextColor = Color(0xFF444444);
  static const Color blackColor = Color(0xFF000000);
  static const Color greyTextColor = Color(0xFF666666);
  static const Color hintTextColor = Color.fromARGB(255, 153, 153, 153);
  static const Color whiteColor = Color(0xFFFFFFFF);
  
}

class ThemeColors {
  final Color primaryColor;
  final Color primaryDarkColor;
  final Color accentColor;
  final Color backgroundColor;
  final Color textSelectionColor;

  ThemeColors(
    this.primaryColor,
    this.primaryDarkColor,
    this.accentColor,
    this.backgroundColor,
    this.textSelectionColor,
  );
}

final TextTheme textTheme = TextTheme(
  displayLarge: GoogleFonts.inter(
    fontSize: 97,
    fontWeight: FontWeight.w300,
    //letterspacing
    color: AppColors.blackTextColor,
  ),
  displayMedium: GoogleFonts.inter(
    fontSize: 61,
    fontWeight: FontWeight.w300,
    //letterspacing
    color: AppColors.blackTextColor,
  ),
  displaySmall: GoogleFonts.inter(
    fontSize: 48,
    fontWeight: FontWeight.w400,
    color: AppColors.blackTextColor,
  ),
  headlineMedium: GoogleFonts.inter(
    fontSize: 34,
    fontWeight: FontWeight.w400,
    color: AppColors.blackTextColor,
  ),
  headlineSmall: GoogleFonts.inter(
      fontSize: 24,
      fontWeight: FontWeight.w400,
      color: AppColors.blackTextColor,),
  titleLarge: GoogleFonts.inter(
      fontSize: 20,
      fontWeight: FontWeight.w400,
      color: AppColors.blackTextColor,),
  titleMedium: GoogleFonts.inter(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      //letter spacing 0.15
      color: AppColors.blackTextColor,),
  titleSmall: GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    //letter spacing 0.1
    color: AppColors.blackTextColor,
  ),
  bodyLarge: GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    //letter spacing 0.5
    color: AppColors.blackTextColor,
  ),
  bodyMedium: GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
//letter spacing 0.25
    color: AppColors.blackTextColor,
  ),
  labelLarge: GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    // letterSpacing: 1.25,
    color: AppColors.blackTextColor,
  ),
  bodySmall: GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    // letterSpacing: 0.4,
    color: AppColors.blackTextColor,
  ),
  labelSmall: GoogleFonts.inter(
    fontSize: 10,
    fontWeight: FontWeight.w400,
    letterSpacing: 1.5,
    color: AppColors.blackTextColor,
  ),
);
