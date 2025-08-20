import 'package:flutter/material.dart';

/// === SIZE CONSTANTS ===
/// Icon ----------------------------------------------

const double iconMinSize = 20.0;
const double iconSize = 30.0;
const double iconSizeLarge = 40.0;
const double iconMaxSize = 50.0;

/// Padding -------------------------------------------
const double kPaddingSmall = 8.0;
const double kPadding = 16.0;
const double kPaddingLarge = 20.0;

/// Height & Width ------------------------------------
const double kButtonMinHeight = 20.0;
const double kButtonHeight = 35.0;
const double kButtonMinWidth = 50.0;
const double kButtonWidth = 120.0;
const double kFormMaxWidth = 600.0;
const double kFormMaxHeight = 300.0;
const double kSingleRowScrollMaxHeight = 100;

/// Font Size -----------------------------------------
/// ExtraSmall: caption, ghi chú
/// Small: label nhỏ, button nhỏ
/// Default: body text
/// Medium: subtitle, list item
/// SemiLarge: section label, button text
/// Large: title dài
/// ExtraLarge: page title
/// XXLarge: hero title
/// XXXLarge: landing heading
const double kFontSizeExtraSmall = 10.0;
const double kFontSizeSmall = 12.0;
const double kFontSize = 14.0;
const double kFontSizeMedium = 16.0;
const double kFontSizeSemiLarge = 18.0;
const double kFontSizeLarge = 20.0;
const double kFontSizeExtraLarge = 24.0;
const double kFontSizeXXLarge = 28.0;
const double kFontSizeXXXLarge = 32.0;

/// Font Weight ---------------------------------------
const FontWeight kFontWeightLight = FontWeight.w300;
const FontWeight kFontWeightRegular = FontWeight.w400;
const FontWeight kFontWeightMedium = FontWeight.w500;
const FontWeight kFontWeightSemiBold = FontWeight.w600;
const FontWeight kFontWeightBold = FontWeight.w700;

/// Border Radius -------------------------------------
const double kBorderRadiusSmall = 8.0;
const double kBorderRadius = 12.0;
const double kBorderRadiusLarge = 20.0;
const double kSplashRadiusSmall = 10.0;
const double kSplashRadius = 20.0;

/// Duration ------------------------------------------
const Duration kAnimationDurationShort = Duration(milliseconds: 200);
const Duration kAnimationDuration = Duration(milliseconds: 400);
const Duration kAnimationDurationLong = Duration(milliseconds: 600);

/// === THIS APP ONLY CONSTRANTS ===

// Pages ----------------------------------------------------------

const List<Map<String, dynamic>> pages = [
  {'route': '/', 'label': 'Home', 'icon': Icons.home},
  {'route': '/logs', 'label': 'History', 'icon': Icons.history},
  {'route': '/settings', 'label': 'Setting', 'icon': Icons.settings},
];

/// Moods default data ---------------------------------------------

const Map<String, IconData> moods = {
  'terrible': Icons.sentiment_very_dissatisfied,
  'not good': Icons.sentiment_dissatisfied,
  'chill': Icons.sentiment_neutral,
  'good': Icons.sentiment_satisfied,
  'awesome': Icons.sentiment_very_satisfied,
};

const String initialMood = 'chill';
const double minMoodPoint = 0.0;
const double maxMoodPoint = 1.0;
