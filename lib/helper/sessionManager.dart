import 'package:egrocer/helper/utils/generalImports.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SessionManager extends ChangeNotifier {
  static String isUserLogin = "isUserLogin";
  static String introSlider = "introSlider";
  static String isDarkTheme = "isDarkTheme";
  static String appThemeName = "appThemeName";
  static String keySelectedLanguageId = "selectedLanguageId";
  static String keySelectedLanguageCode = "selectedLanguageCode";
  static String keyRecentAddressSearch = "recentAddress";
  static String keySkipLogin = "keySkipLogin";
  static String keyAuthUid = "keyAuthUid";
  static String keyUserName = "username";
  static String keyUserImage = "image";
  static String keyPhone = "phone";
  static String keyEmail = "email";
  static String keyCountryCode = "countryCode";
  static String keyReferralCode = "referral_code";
  static String keyUserStatus = "userStatus";
  static String keyToken = "keyToken";
  static String keyFCMToken = "keyFCMToken";
  static String keyIsGrid = "isGrid";
  static String keyLatitude = "keyLatitude";
  static String keyLongitude = "keyLongitude";
  static String keyAddress = "keyAddress";
  static String keyWalletBalance = "keyWalletBalance";
  static String keyGuestCartItems = "keyGuestCartItems";
  static String keyLoginType = "keyLoginType";

  static String keyPermissionGalleryHidePromptPermanently =
      "keyPermissionGalleryHidePromptPermanently";
  static String keyPermissionNotificationHidePromptPermanently =
      "keyPermissionNotificationHidePromptPermanently";
  static String keyPermissionLocationHidePromptPermanently =
      "keyPermissionLocationHidePromptPermanently";
  static String keyPermissionCameraHidePromptPermanently =
      "keyPermissionCameraHidePromptPermanently";
  static String keyPermissionMicrophoneHidePromptPermanently =
      "keyPermissionMicrophoneHidePromptPermanently";

  late SharedPreferences prefs;

  SessionManager({required this.prefs});

  String getData(String id) {
    return prefs.getString(id) ?? "";
  }

  void setData(String id, String val, bool isRefresh) {
    prefs.setString(id, val);
    if (isRefresh) {
      notifyListeners();
    }
  }

  List<CartList> getGuestCartItems() {
    if (getData(keyGuestCartItems).isNotEmpty) {
      return CartList.JsonToCartItems(getData(keyGuestCartItems));
    } else {
      return [];
    }
  }

  void addItemIntoList(String id, String item) {
    if (!Constant.searchedItemsHistoryList.contains(item)) {
      Constant.searchedItemsHistoryList.add(item);
      prefs.setStringList(id, Constant.searchedItemsHistoryList);
    }
  }

  void clearItemList(String id) {
    Constant.searchedItemsHistoryList = [];
    prefs.setStringList(id, []);
  }

  Future setUserData({
    required BuildContext context,
    required String firebaseUid,
    required String name,
    required String email,
    required String profile,
    required String countryCode,
    required String mobile,
    required String referralCode,
    required int status,
    required String token,
    required String balance,
    required String type,
  }) async {
    prefs.setString(keyToken, token);

    prefs.setString(keyAuthUid, firebaseUid);
    setData(keyUserName, name, true);
    setData(keyUserImage, profile, true);
    setData(keyEmail, email, true);
    prefs.setString(keyCountryCode, countryCode);
    prefs.setString(keyPhone, mobile);
    prefs.setString(keyReferralCode, referralCode);
    prefs.setInt(keyUserStatus, status);
    setBoolData(isUserLogin, true, true);
    prefs.setString(keyWalletBalance, balance.toString());
    prefs.setString(keyLoginType, type.toString());

    notifyListeners();
  }

  void setDoubleData(String key, double value) {
    prefs.setDouble(key, value);
    notifyListeners();
  }

  double getDoubleData(String key) {
    return prefs.getDouble(key) ?? 0.0;
  }

  bool getBoolData(String key) {
    return prefs.getBool(key) ?? false;
  }

  void setBoolData(String key, bool value, bool isRefresh) {
    prefs.setBool(key, value);
    if (isRefresh) notifyListeners();
  }

  int getIntData(String key) {
    return prefs.getInt(key) ?? 0;
  }

  void setIntData(String key, int value) {
    prefs.setInt(key, value);
    notifyListeners();
  }

  bool isUserLoggedIn() {
    return getBoolData(isUserLogin);
  }

  void logoutUser(BuildContext buildContext) {
    AuthProviders authProvider;
    if (getData(keyLoginType) == "phone") {
      authProvider = AuthProviders.phone;
    } else if (getData(keyLoginType) == "google") {
      authProvider = AuthProviders.google;
    } else {
      authProvider = AuthProviders.apple;
    }

    showDialog<String>(
      context: buildContext,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: Theme.of(buildContext).cardColor,
        surfaceTintColor: Colors.transparent,
        title: CustomTextLabel(
          jsonKey: "logout_title",
          softWrap: true,
        ),
        content: CustomTextLabel(
          jsonKey: "logout_message",
          softWrap: true,
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: CustomTextLabel(
              jsonKey: "cancel",
              softWrap: true,
              style: TextStyle(color: ColorsRes.subTitleMainTextColor),
            ),
          ),
          TextButton(
            onPressed: () {
              logoutApi(context: context, fcmToken: getData(keyFCMToken));
              String themeName = getData(appThemeName);
              String languageId = getData(keySelectedLanguageId);
              String latitude = getData(keyLatitude);
              String longitude = getData(keyLongitude);
              String address = getData(keyAddress);

              bool isDark = false;
              if (themeName == Constant.themeList[2]) {
                isDark = true;
              } else if (themeName == Constant.themeList[1]) {
                isDark = false;
              } else if (themeName == "" ||
                  themeName == Constant.themeList[0]) {
                var brightness = PlatformDispatcher.instance.platformBrightness;
                isDark = brightness == Brightness.dark;

                if (themeName == "") {
                  setData(appThemeName, Constant.themeList[0], false);
                }
              }
              signOut(
                authProvider: authProvider,
                firebaseAuth: FirebaseAuth.instance,
                googleSignIn: GoogleSignIn(),
              );
              prefs.clear();
              setBoolData(introSlider, true, false);
              setBoolData(isUserLogin, false, false);
              setData(appThemeName, themeName, false);
              setData(keySelectedLanguageId, languageId, false);
              setData(keyLatitude, latitude, false);
              setData(keyLongitude, longitude, false);
              setData(keyAddress, address, false);
              setBoolData(isDarkTheme, isDark, false);
              setBoolData(introSlider, true, false);
              context.read<CartListProvider>().cartList.clear();
              Navigator.of(buildContext).pushNamedAndRemoveUntil(
                  loginScreen, (Route<dynamic> route) => false);
            },
            child: CustomTextLabel(
              jsonKey: "ok",
              softWrap: true,
              style: TextStyle(color: ColorsRes.appColor),
            ),
          ),
        ],
      ),
    );
  }

  void deleteUserAccount(BuildContext buildContext) {
    AuthProviders authProvider;
    if (getData(keyLoginType) == "phone") {
      authProvider = AuthProviders.phone;
    } else if (getData(keyLoginType) == "google") {
      authProvider = AuthProviders.google;
    } else {
      authProvider = AuthProviders.apple;
    }
    showDialog<String>(
      context: buildContext,
      builder: (BuildContext context) => AlertDialog(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Theme.of(buildContext).cardColor,
        title: CustomTextLabel(
          jsonKey: "delete_user_title",
          softWrap: true,
        ),
        content: CustomTextLabel(
          jsonKey: "delete_user_message",
          softWrap: true,
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: CustomTextLabel(
              jsonKey: "cancel",
              softWrap: true,
              style: TextStyle(color: ColorsRes.subTitleMainTextColor),
            ),
          ),
          TextButton(
            onPressed: () async {
              await getDeleteAccountApi(context: context)
                  .then((response) async {
                String themeName = getData(appThemeName);
                String languageId = getData(keySelectedLanguageId);
                String latitude = getData(keyLatitude);
                String longitude = getData(keyLongitude);
                String address = getData(keyAddress);

                bool isDark = false;
                if (themeName == Constant.themeList[2]) {
                  isDark = true;
                } else if (themeName == Constant.themeList[1]) {
                  isDark = false;
                } else if (themeName == "" ||
                    themeName == Constant.themeList[0]) {
                  var brightness =
                      PlatformDispatcher.instance.platformBrightness;
                  isDark = brightness == Brightness.dark;

                  if (themeName == "") {
                    setData(appThemeName, Constant.themeList[0], false);
                  }
                }
                signOut(
                  authProvider: authProvider,
                  firebaseAuth: FirebaseAuth.instance,
                  googleSignIn: GoogleSignIn(),
                );
                prefs.clear();
                setBoolData(introSlider, true, false);
                setBoolData(isUserLogin, false, false);
                setData(appThemeName, themeName, false);
                setData(keyLatitude, latitude, false);
                setData(keyLongitude, longitude, false);
                setData(keyAddress, address, false);
                setBoolData(isDarkTheme, isDark, false);
                setBoolData(introSlider, true, false);
                setData(keySelectedLanguageId, languageId, false);
                context.read<CartListProvider>().cartList.clear();
                Navigator.of(buildContext).pushNamedAndRemoveUntil(
                    loginScreen, (Route<dynamic> route) => false);
              });
            },
            child: CustomTextLabel(
              jsonKey: "ok",
              softWrap: true,
              style: TextStyle(color: ColorsRes.appColor),
            ),
          ),
        ],
      ),
    );
  }
}
