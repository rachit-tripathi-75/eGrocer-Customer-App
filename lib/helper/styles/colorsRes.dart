import 'package:egrocer/helper/utils/generalImports.dart';

class ColorsRes {
  static MaterialColor appColor = const MaterialColor(
    0xff55AE7B,
    <int, Color>{
      50: Color(0xff55AE7B),
      100: Color(0xff55AE7B),
      200: Color(0xff55AE7B),
      300: Color(0xff55AE7B),
      400: Color(0xff55AE7B),
      500: Color(0xff55AE7B),
      600: Color(0xff55AE7B),
      700: Color(0xff55AE7B),
      800: Color(0xff55AE7B),
      900: Color(0xff55AE7B),
    },
  );

  static Color appColorLight = const Color(0xffe1ffeb);
  static Color appColorLightHalfTransparent = const Color(0x2655AE7B);
  static Color appColorDark = const Color(0xff3d8c68);

  static Color gradient1 = const Color(0xff78c797);
  static Color gradient2 = const Color(0xff55AE7B);

  static Color defaultPageInnerCircle = const Color(0x1A999999);
  static Color defaultPageOuterCircle = const Color(0x0d999999);

  static Color mainTextColor = const Color(0xde000000);
  static Color subTitleMainTextColor = const Color(0x94000000);

  static Color lightThemeTextColor = const Color(0xff121418);
  static Color darkThemeTextColor = const Color(0xfffefefe);

  static Color subTitleTextColorLight = const Color(0xffAEAEAE);
  static Color subTitleTextColorDark = const Color(0xff7F878E);

  static Color mainIconColor = Colors.white;

  static Color bgColorLight = const Color(0xffF7F7F7);
  static Color bgColorDark = const Color(0xff141A1F);

  static Color cardColorLight = const Color(0xffFEFEFE);
  static Color cardColorDark = const Color(0xff202934);

  static Color grey = Colors.grey;
  static Color lightGrey = const Color(0xffb8babb);
  static Color appColorWhite = Colors.white;
  static Color appColorBlack = Colors.black;
  static Color appColorRed = Color(0xffF52C45);
  static Color appColorGreen = Colors.green;

  static Color greyBox = const Color(0x0a000000);
  static Color lightGreyBox = const Color.fromARGB(9, 213, 212, 212);

  //It will be same for both theme
  static Color shimmerBaseColor = Colors.white;
  static Color shimmerHighlightColor = Colors.white;
  static Color shimmerContentColor = Colors.white;

  //Dark theme shimmer color
  static Color shimmerBaseColorDark = Colors.grey.withOpacity(0.05);
  static Color shimmerHighlightColorDark = Colors.grey.withOpacity(0.005);
  static Color shimmerContentColorDark = Colors.black;

  //Light theme shimmer color
  static Color shimmerBaseColorLight = Colors.black.withOpacity(0.05);
  static Color shimmerHighlightColorLight = Colors.black.withOpacity(0.005);
  static Color shimmerContentColorLight = Colors.white;

  static Color activeRatingColor = Color(0xffF4CD32);
  static Color deActiveRatingColor = Color(0xffAEAEAE);

  static ThemeData lightTheme = ThemeData(
    primaryColor: appColor,
    brightness: Brightness.light,
    scaffoldBackgroundColor: bgColorLight,
    cardColor: cardColorLight,
    iconTheme: IconThemeData(
      color: grey,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: grey,
      iconTheme: IconThemeData(
        color: grey,
      ),
    ),
    colorScheme:
        ColorScheme.fromSwatch(primarySwatch: ColorsRes.appColor).copyWith(
      surface: bgColorLight,
      brightness: Brightness.light,
    ),
    cardTheme: CardTheme(
      color: mainTextColor,
      surfaceTintColor: mainTextColor,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    primaryColor: appColor,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: bgColorDark,
    cardColor: cardColorDark,
    iconTheme: IconThemeData(
      color: grey,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: grey,
      iconTheme: IconThemeData(
        color: grey,
      ),
    ),
    colorScheme:
        ColorScheme.fromSwatch(primarySwatch: ColorsRes.appColor).copyWith(
      surface: bgColorDark,
      brightness: Brightness.dark,
    ),
    cardTheme: CardTheme(
      color: mainTextColor,
      surfaceTintColor: mainTextColor,
    ),
  );

  static ThemeData setAppTheme() {
    String theme = Constant.session.getData(SessionManager.appThemeName);
    bool isDarkTheme = Constant.session.getBoolData(SessionManager.isDarkTheme);

    bool isDark = false;
    if (theme == Constant.themeList[2]) {
      isDark = true;
    } else if (theme == Constant.themeList[1]) {
      isDark = false;
    } else if (theme == "" || theme == Constant.themeList[0]) {
      var brightness = PlatformDispatcher.instance.platformBrightness;
      isDark = brightness == Brightness.dark;

      if (theme == "") {
        Constant.session
            .setData(SessionManager.appThemeName, Constant.themeList[0], false);
      }
    }

    if (isDark) {
      if (!isDarkTheme) {
        Constant.session.setBoolData(SessionManager.isDarkTheme, false, false);
      }
      mainTextColor = darkThemeTextColor;
      subTitleMainTextColor = subTitleTextColorDark;

      shimmerBaseColor = shimmerBaseColorDark;
      shimmerHighlightColor = shimmerHighlightColorDark;
      shimmerContentColor = shimmerContentColorDark;
      return darkTheme;
    } else {
      if (isDarkTheme) {
        Constant.session.setBoolData(SessionManager.isDarkTheme, true, false);
      }
      mainTextColor = lightThemeTextColor;
      subTitleMainTextColor = subTitleTextColorLight;

      shimmerBaseColor = shimmerBaseColorLight;
      shimmerHighlightColor = shimmerHighlightColorLight;
      shimmerContentColor = shimmerContentColorLight;
      return lightTheme;
    }
  }
}
