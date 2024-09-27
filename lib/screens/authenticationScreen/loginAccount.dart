import 'package:egrocer/helper/utils/generalImports.dart';
import 'package:egrocer/screens/authenticationScreen/widget/socialMediaLoginButtonWidget.dart';
import 'package:google_sign_in/google_sign_in.dart';

enum AuthProviders {
  phone,
  google,
  apple,
}

class LoginAccount extends StatefulWidget {
  final String? from;

  const LoginAccount({Key? key, this.from}) : super(key: key);

  @override
  State<LoginAccount> createState() => _LoginAccountState();
}

class _LoginAccountState extends State<LoginAccount> {
  CountryCode? selectedCountryCode;
  bool isLoading = false;

  // TODO REMOVE DEMO NUMBER FROM HERE
  TextEditingController edtPhoneNumber =
      TextEditingController();
  bool isDark = Constant.session.getBoolData(SessionManager.isDarkTheme);
  String otpVerificationId = "";
  String phoneNumber = "";
  int? forceResendingToken;

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  GoogleSignIn googleSignIn = GoogleSignIn();

  AuthProviders? authProvider;

  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) async {
      try {
        await LocalAwesomeNotification().init(context);

        await FirebaseMessaging.instance.getToken().then((token) {
          Constant.session.setData(SessionManager.keyFCMToken, token!, false);
        });
      } catch (ignore) {}
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PositionedDirectional(
            top: 40,
            end: 10,
            child: skipLoginText(),
          ),
          Center(
            child: ListView(
              shrinkWrap: true,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: Constant.size10, vertical: Constant.size20),
                  child: Container(
                    constraints: BoxConstraints(maxHeight: context.width * 0.4),
                    child: defaultImg(
                      image: "logo",
                      requiredRTL: false,
                    ),
                  ),
                ),
                loginWidgets(),
              ],
            ),
          ),
          if (isLoading && authProvider != AuthProviders.phone)
            PositionedDirectional(
              top: 0,
              end: 0,
              bottom: 0,
              start: 0,
              child: Container(
                color: Colors.black.withOpacity(0.3),
                child: Center(
                  child: CircularProgressIndicator(
                    color: ColorsRes.appColor,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  proceedBtn() {
    return (isLoading && authProvider == AuthProviders.phone)
        ? Container(
            height: 55,
            alignment: AlignmentDirectional.center,
            child: CircularProgressIndicator(),
          )
        : gradientBtnWidget(context, 10,
            title: getTranslatedValue(
              context,
              "login",
            ).toUpperCase(), callback: () {
            loginWithPhoneNumber();
          });
  }

  Widget skipLoginText() {
    return GestureDetector(
      onTap: () async {
        if (isLoading == false) {
          Constant.session
              .setBoolData(SessionManager.keySkipLogin, true, false);
          await getRedirection();
        }
      },
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).cardColor,
        ),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: CustomTextLabel(
          jsonKey: "skip_login",
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: isLoading == false ? ColorsRes.appColor : ColorsRes.grey,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  loginWidgets() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: CustomTextLabel(
              jsonKey: "welcome",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
                fontSize: 30,
                color: ColorsRes.mainTextColor,
              ),
            ),
            subtitle: (Constant.authTypePhoneLogin == "1")
                ? CustomTextLabel(
                    jsonKey: "login_enter_number_message",
                    style: TextStyle(color: ColorsRes.grey),
                  )
                : null,
          ),
          if (Constant.authTypePhoneLogin == "1") ...[
            getSizedBox(
              height: Constant.size40,
            ),
            Container(
              decoration: DesignConfig.boxDecoration(
                  Theme.of(context).scaffoldBackgroundColor, 10),
              child: mobileNoWidget(),
            ),
            getSizedBox(
              height: Constant.size20,
            ),
            proceedBtn(),
            getSizedBox(
              height: Constant.size20,
            ),
            if (Platform.isIOS && Constant.authTypeAppleLogin == "1" ||
                Constant.authTypeGoogleLogin == "1")
              buildDottedDivider(),
            getSizedBox(
              height: Constant.size20,
            ),
          ],
          if (Platform.isIOS && Constant.authTypeAppleLogin == "1") ...[
            Center(
              child: SocialMediaLoginButtonWidget(
                text: "continue_with_apple",
                logo: "apple_logo",
                logoColor: ColorsRes.mainTextColor,
                onPressed: () async {
                  authProvider = AuthProviders.apple;
                  await signInWithApple(
                    context: context,
                    firebaseAuth: firebaseAuth,
                    googleSignIn: googleSignIn,
                  ).then(
                    (value) {
                      setState(() {
                        isLoading = true;
                      });
                      if (value is UserCredential) {
                        backendApiProcess(value.user);
                      } else {
                        showMessage(
                            context, value.toString(), MessageType.error);
                      }
                    },
                  );
                },
              ),
            ),
            getSizedBox(height: 10),
          ],
          if (Constant.authTypeGoogleLogin == "1")
            Center(
              child: SocialMediaLoginButtonWidget(
                text: "continue_with_google",
                logo: "google_logo",
                onPressed: () async {
                  authProvider = AuthProviders.google;
                  await signInWithGoogle(
                    context: context,
                    firebaseAuth: firebaseAuth,
                    googleSignIn: googleSignIn,
                  ).then(
                    (value) {
                      if (value is UserCredential) {
                        backendApiProcess(value.user);
                      } else {
                        showMessage(
                            context, value.toString(), MessageType.error);
                      }
                    },
                  );
                },
              ),
            ),
          getSizedBox(
            height: Constant.size20,
          ),
          RichText(
            textAlign: TextAlign.start,
            text: TextSpan(
              style: Theme.of(context).textTheme.titleSmall!.merge(
                    TextStyle(
                      fontWeight: FontWeight.w400,
                      color: ColorsRes.subTitleMainTextColor,
                    ),
                  ),
              text: "${getTranslatedValue(
                context,
                "agreement_message_1",
              )}\t",
              children: <TextSpan>[
                TextSpan(
                    text: getTranslatedValue(context, "terms_of_service"),
                    style: TextStyle(
                      color: ColorsRes.appColor,
                      fontWeight: FontWeight.w500,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.pushNamed(context, webViewScreen,
                            arguments: getTranslatedValue(
                              context,
                              "terms_and_conditions",
                            ));
                      }),
                TextSpan(
                    text: "\t${getTranslatedValue(
                      context,
                      "and",
                    )}\t",
                    style: TextStyle(
                      color: ColorsRes.subTitleMainTextColor,
                    )),
                TextSpan(
                  text: getTranslatedValue(context, "privacy_policy"),
                  style: TextStyle(
                    color: ColorsRes.appColor,
                    fontWeight: FontWeight.w500,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Navigator.pushNamed(
                        context,
                        webViewScreen,
                        arguments: getTranslatedValue(
                          context,
                          "privacy_policy",
                        ),
                      );
                    },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  mobileNoWidget() {
    return Row(
      children: [
        const SizedBox(width: 5),
        IgnorePointer(
          ignoring: isLoading,
          child: CountryCodePicker(
            onInit: (countryCode) {
              selectedCountryCode = countryCode;
            },
            onChanged: (countryCode) {
              selectedCountryCode = countryCode;
            },
            initialSelection: Constant.initialCountryCode,
            textOverflow: TextOverflow.ellipsis,
            backgroundColor: Theme.of(context).cardColor,
            textStyle: TextStyle(color: ColorsRes.mainTextColor),
            dialogBackgroundColor: Theme.of(context).cardColor,
            dialogSize: Size(context.width, context.height),
            barrierColor: ColorsRes.subTitleMainTextColor,
            padding: EdgeInsets.zero,
            searchDecoration: InputDecoration(
              iconColor: ColorsRes.subTitleMainTextColor,
              fillColor: Theme.of(context).cardColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: ColorsRes.subTitleMainTextColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: ColorsRes.subTitleMainTextColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: ColorsRes.subTitleMainTextColor),
              ),
              focusColor: Theme.of(context).scaffoldBackgroundColor,
              prefixIcon: Icon(
                Icons.search_rounded,
                color: ColorsRes.subTitleMainTextColor,
              ),
            ),
            searchStyle: TextStyle(
              color: ColorsRes.subTitleMainTextColor,
            ),
            dialogTextStyle: TextStyle(
              color: ColorsRes.mainTextColor,
            ),
          ),
        ),
        Icon(
          Icons.keyboard_arrow_down,
          color: ColorsRes.grey,
          size: 15,
        ),
        getSizedBox(
          width: Constant.size10,
        ),
        Expanded(
          child: TextField(
            controller: edtPhoneNumber,
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
            ],
            style: TextStyle(
              color: ColorsRes.mainTextColor,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              isDense: true,
              hintStyle: TextStyle(color: Colors.grey[300]),
              hintText: "9999999999",
            ),
          ),
        )
      ],
    );
  }

  getRedirection() async {
    if (Constant.session.getBoolData(SessionManager.keySkipLogin) ||
        Constant.session.getBoolData(SessionManager.isUserLogin)) {
      if ((Constant.session.getData(SessionManager.keyLatitude) == "" &&
              Constant.session.getData(SessionManager.keyLongitude) == "") ||
          (Constant.session.getData(SessionManager.keyLatitude) == "0" &&
              Constant.session.getData(SessionManager.keyLongitude) == "0")) {
        Navigator.pushReplacementNamed(context, confirmLocationScreen,
            arguments: [null, "location"]);
      } else if (Constant.session
          .getData(SessionManager.keyUserName)
          .isNotEmpty) {
        Navigator.pushReplacementNamed(
          context,
          mainHomeScreen,
        );
      } else {
        Navigator.pushNamedAndRemoveUntil(
          context,
          mainHomeScreen,
          (route) => false,
        );
      }
    }
  }

  Future<bool> mobileNumberValidation() async {
    bool checkInternet = await checkInternetConnection();
    String? mobileValidate = await phoneValidation(
      edtPhoneNumber.text,
    );
    if (!checkInternet) {
      showMessage(
        context,
        getTranslatedValue(
          context,
          "check_internet",
        ),
        MessageType.warning,
      );
      return false;
    } else if (mobileValidate == "") {
      showMessage(
        context,
        getTranslatedValue(
          context,
          "enter_valid_mobile",
        ),
        MessageType.warning,
      );
      return false;
    } else if (mobileValidate != null && edtPhoneNumber.text.length > 15) {
      showMessage(
        context,
        getTranslatedValue(
          context,
          "enter_valid_mobile",
        ),
        MessageType.warning,
      );
      return false;
    } else {
      return true;
    }
  }

  loginWithPhoneNumber() async {
    var validation = await mobileNumberValidation();
    if (validation) {
      if (isLoading) return;
      setState(() {
        isLoading = true;
      });
      firebaseLoginProcess();
    }
  }

  firebaseLoginProcess() async {
    authProvider == AuthProviders.phone;
    setState(() {});
    if (edtPhoneNumber.text.isNotEmpty) {
      await firebaseAuth.verifyPhoneNumber(
        timeout: Duration(minutes: 1, seconds: 30),
        phoneNumber: '${selectedCountryCode!.dialCode}${edtPhoneNumber.text}',
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException e) {
          showMessage(
            context,
            e.message!,
            MessageType.warning,
          );

          setState(() {
            isLoading = false;
          });
        },
        codeSent: (String verificationId, int? resendToken) {
          forceResendingToken = resendToken;
          isLoading = false;
          setState(() {
            phoneNumber =
                '${selectedCountryCode!.dialCode} - ${edtPhoneNumber.text}';
            otpVerificationId = verificationId;

            List<dynamic> firebaseArguments = [
              firebaseAuth,
              otpVerificationId,
              edtPhoneNumber.text,
              selectedCountryCode!,
              widget.from ?? null
            ];
            Navigator.pushNamed(context, otpScreen,
                arguments: firebaseArguments);
          });
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          if (mounted) {
            setState(() {
              isLoading = false;
            });
          }
        },
        forceResendingToken: forceResendingToken,
      );
    }
  }

  Widget buildDottedDivider() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Row(
          children: List.generate(
            50,
            (index) => Expanded(
              child: Container(
                color: index % 2 == 0
                    ? ColorsRes.subTitleMainTextColor.withOpacity(0.5)
                    : Colors.transparent,
                height: 2,
              ),
            ),
          ),
        ),
        Container(
          color: Theme.of(context).cardColor,
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: CustomTextLabel(
            jsonKey: "or_",
            style: TextStyle(
              color: ColorsRes.subTitleMainTextColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  backendApiProcess(User? user) async {
    if (user != null) {
      Constant.session.setData(SessionManager.keyAuthUid, user.uid, false);
      Map<String, String> params = {
        ApiAndParams.authUid: user.uid, // In live this will use
        ApiAndParams.platform: Platform.isAndroid ? "android" : "ios",
        ApiAndParams.fcmToken:
            Constant.session.getData(SessionManager.keyFCMToken),
      };

      await context
          .read<UserProfileProvider>()
          .loginApi(context: context, params: params)
          .then(
        (value) async {
          if (value == "1") {
            if (widget.from == "add_to_cart") {
              addGuestCartBulkToCartWhileLogin(
                context: context,
                params: Constant.setGuestCartParams(
                  cartList: context.read<CartListProvider>().cartList,
                ),
              ).then((value) {
                Navigator.pop(context);
                Navigator.pop(context);
              });
            } else if (Constant.session
                .getBoolData(SessionManager.isUserLogin)) {
              if (context.read<CartListProvider>().cartList.isNotEmpty) {
                addGuestCartBulkToCartWhileLogin(
                  context: context,
                  params: Constant.setGuestCartParams(
                    cartList: context.read<CartListProvider>().cartList,
                  ),
                ).then(
                  (value) => Navigator.of(context).pushNamedAndRemoveUntil(
                    mainHomeScreen,
                    (Route<dynamic> route) => false,
                  ),
                );
              } else {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  mainHomeScreen,
                  (Route<dynamic> route) => false,
                );
              }
            }
          } else {
            setState(() {
              isLoading = false;
            });
            Constant.session.setData(SessionManager.keyUserImage,
                firebaseAuth.currentUser!.photoURL.toString(), false);

            Navigator.of(context).pushNamed(
              editProfileScreen,
              arguments: [
                widget.from ?? "register",
                {
                  ApiAndParams.authUid:
                      firebaseAuth.currentUser!.uid.toString(),
                  ApiAndParams.name:
                      firebaseAuth.currentUser!.displayName ?? "",
                  ApiAndParams.email: firebaseAuth.currentUser!.email ?? "",
                  ApiAndParams.countryCode: "",
                  ApiAndParams.mobile:
                      firebaseAuth.currentUser!.phoneNumber ?? "",
                  ApiAndParams.type: authProvider == AuthProviders.phone
                      ? "phone"
                      : authProvider == AuthProviders.google
                          ? "google"
                          : "apple",
                  ApiAndParams.platform: Platform.isAndroid ? "android" : "ios",
                  ApiAndParams.fcmToken:
                      Constant.session.getData(SessionManager.keyFCMToken),
                }
              ],
            );
          }
        },
      );
    }
  }
}
