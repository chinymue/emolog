import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

/// === CONSTANTS ===
/// except color

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
const double kFormWidth = 500.0;

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

/// ------------------------------------------------
/// Responsive font size utility
/// - Increases font by [increment] when screen width >= [breakpoint]
/// Usage:
///   double size = responsiveFontSize(context, kFontSize);
/// ------------------------------------------------
double responsiveFontSize(
  BuildContext context,
  double baseSize, {
  double breakpoint = 600.0,
  double increment = 2.0,
}) {
  final width = MediaQuery.of(context).size.width;
  return (width >= breakpoint) ? (baseSize + increment) : baseSize;
}

/// === THIS APP ONLY CONSTANTS ===

/// Pages ---------------------------------------------

const List<Map<String, dynamic>> pages = [
  {'route': '/', 'label': 'Home', 'icon': Icons.home},
  {'route': '/logs', 'label': 'History', 'icon': Icons.history},
  {'route': '/settings', 'label': 'Setting', 'icon': Icons.settings},
];

/// Moods ---------------------------------------------

const Map<String, IconData> moods = {
  'terrible': Icons.sentiment_very_dissatisfied,
  'not good': Icons.sentiment_dissatisfied,
  'chill': Icons.sentiment_neutral,
  'good': Icons.sentiment_satisfied,
  'awesome': Icons.sentiment_very_satisfied,
};

/// Other constants ------------------------------------

const kPrefsKey = 'favorite_note_ids';

/// === THEME ===

ThemeData buildAppTheme(Color seedColor) {
  return ThemeData(
    fontFamily: GoogleFonts.inter().fontFamily,
    colorScheme: ColorScheme.fromSeed(seedColor: seedColor),
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
          horizontal: kPadding,
          vertical: kPaddingSmall,
        ),
        minimumSize: const Size(kButtonMinWidth, kButtonHeight),
        fixedSize: const Size(kButtonWidth, kButtonHeight),
        maximumSize: const Size(double.infinity, kButtonHeight),
      ),
    ),
  );
}

/// === COLOR UTILS ===

/// Một số màu tiện dùng
const Color follyRed = Color(0xFFFF0A54);
const Color tickleMePink = Color(0xFFFF85A1);
const Color brightPink = Color(0xFFFF5C8A);
const Color salmonPink = Color(0xFFFF99AC);
const Color cherryBlossom = Color(0xFFFBB1BD);
const Color mistyRose = Color(0xFFFAE0E4);
const Color lavenderBlush = Color(0xFFFFF0F3);
const Color chocolateCosmos = Color(0xFF590D22);
const Color claret = Color(0xFF800F2F);
const Color roseRed = Color(0xFFC9184A);
const Color amaranthPurple = Color(0xFFA4133C);

Color adjustLightness(Color color, double amount, {double maxLightness = 0.9}) {
  final hsl = HSLColor.fromColor(color);
  final newLightness = (hsl.lightness + amount).clamp(0.0, maxLightness);
  return hsl.withLightness(newLightness).toColor();
}

/// === DATE UTILS ===

String formatDate(DateTime date) => DateFormat('yyyy-MM-dd').format(date);

String formatTime(DateTime date) => DateFormat('HH:mm:ss').format(date);

String formatFullDateTime(DateTime date) =>
    DateFormat('EEEE yyyy-MM-dd HH:mm:ss').format(date);

String formatFullDateTimeShortDay(DateTime date) =>
    DateFormat('EEE yyyy-MM-dd HH:mm:ss').format(date);

String formatDateTime(DateTime date) =>
    DateFormat('yyyy-MM-dd HH:mm:ss').format(date);

String formatShortDateTime(DateTime date) =>
    DateFormat('yyyy-MM-dd HH:mm').format(date);

String formatShortWeekday(DateTime date, {String locale = 'vi_VN'}) {
  Intl.defaultLocale = locale;
  return DateFormat('EEE').format(date); // T7
}

String formatFullWeekday(DateTime date, {String locale = 'vi_VN'}) {
  Intl.defaultLocale = locale;
  return DateFormat('EEEE').format(date); // Thứ Bảy
}

/// === Default Widgets ===

// Scaffold with bottom navigation bar

class MainScaffold extends StatelessWidget {
  final int currentIndex;
  final Widget child;

  const MainScaffold({
    required this.currentIndex,
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext c) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          pages[currentIndex]['label'] ?? 'Not found name',
          style: Theme.of(c).textTheme.headlineLarge?.copyWith(
            color: Theme.of(c).colorScheme.primary,
          ),
        ),
      ),
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (i) => Navigator.pushReplacementNamed(c, pages[i]['route']),
        items: [
          for (var i in pages)
            BottomNavigationBarItem(icon: Icon(i['icon']), label: i['label']),
        ],
      ),
    );
  }
}
