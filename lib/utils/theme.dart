import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'constant.dart';

/// === THEME ===

ThemeData buildAppTheme(Color seedColor, {bool isLight = true}) {
  return ThemeData(
    fontFamily: GoogleFonts.inter().fontFamily,
    colorScheme: ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: isLight ? Brightness.light : Brightness.dark,
    ),
    textTheme: TextTheme(
      displayLarge: TextStyle(
        fontFamily: GoogleFonts.merriweather().fontFamily,
        fontWeight: kFontWeightSemiBold,
        fontSize: kFontSizeXXXLarge,
      ),
      displayMedium: TextStyle(
        fontFamily: GoogleFonts.merriweather().fontFamily,
        fontWeight: kFontWeightSemiBold,
        fontSize: kFontSizeXXLarge,
      ),
      displaySmall: TextStyle(
        fontFamily: GoogleFonts.merriweather().fontFamily,
        fontWeight: kFontWeightSemiBold,
        fontSize: kFontSizeExtraLarge,
      ),
      headlineLarge: const TextStyle(
        fontWeight: kFontWeightSemiBold,
        fontSize: kFontSizeLarge,
      ),
      headlineMedium: const TextStyle(
        fontWeight: kFontWeightSemiBold,
        fontSize: kFontSizeSemiLarge,
      ),
      headlineSmall: const TextStyle(
        fontWeight: kFontWeightSemiBold,
        fontSize: kFontSizeMedium,
      ),
      labelLarge: const TextStyle(
        fontSize: kFontSizeMedium,
        fontWeight: kFontWeightBold,
      ),
      labelMedium: const TextStyle(
        fontSize: kFontSizeSmall,
        fontWeight: kFontWeightBold,
      ),
      labelSmall: const TextStyle(
        fontSize: kFontSizeExtraSmall,
        fontWeight: kFontWeightBold,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        textStyle: TextStyle(
          fontSize: kFontSizeMedium,
          fontWeight: kFontWeightSemiBold,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: kPaddingLarge,
          vertical: kPadding,
        ),
      ),
    ),
  );
}
