import 'package:egrocer/helper/utils/generalImports.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String otpVerificationId;
  final String phoneNumber;
  final FirebaseAuth firebaseAuth;
  final CountryCode selectedCountryCode;
  final String? from;

  const OtpVerificationScreen({
    Key? key,
    required this.otpVerificationId,
    required this.phoneNumber,
    required this.firebaseAuth,
    required this.selectedCountryCode,
    this.from,
  }) : super(key: key);

  @override
  State<OtpVerificationScreen> createState() => _LoginAccountState();
}

class _LoginAccountState extends State<OtpVerificationScreen> {
  bool isDark = Constant.session.getBoolData(SessionManager.isDarkTheme);
  int otpLength = 6;
  bool isLoading = false;
  String resendOtpVerificationId = "";
  int? forceResendingToken;

  late PinTheme defaultPinTheme;

  late PinTheme focusedPinTheme;

  late PinTheme submittedPinTheme;

  /// Create Controller
  final pinController = TextEditingController();

  static const _duration = Duration(minutes: 1, seconds: 30);
  Timer? _timer;
  Duration _remaining = _duration;

  void startTimer() {
    _remaining = _duration;
    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      setState(() {
        if (_remaining.inSeconds > 0) {
          _remaining = _remaining - Duration(seconds: 1);
        } else {
          _timer?.cancel();
        }
      });
    });
  }

  @override
  void initState() {
    // TODO REMOVE DEMO OTP FROM HERE
    Future.delayed(Duration.zero).then((value) {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: TextStyle(
        fontSize: 20,
        color: ColorsRes.mainTextColor,
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: ColorsRes.mainTextColor,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
    );

    focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: ColorsRes.mainTextColor),
      borderRadius: BorderRadius.circular(10),
    );

    submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: Theme.of(context).cardColor,
        border: Border.all(
          color: ColorsRes.appColor,
        ),
      ),
    );

    return Scaffold(
      body: Center(
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
            otpWidgets(),
          ],
        ),
      ),
    );
  }

  Widget otpPinWidget() {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Pinput(
        defaultPinTheme: defaultPinTheme,
        focusedPinTheme: focusedPinTheme,
        submittedPinTheme: submittedPinTheme,
        autofillHints: const [AutofillHints.oneTimeCode],
        controller: pinController,
        length: 6,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        hapticFeedbackType: HapticFeedbackType.heavyImpact,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          FilteringTextInputFormatter.singleLineFormatter
        ],
        autofocus: true,
        closeKeyboardWhenCompleted: true,
        pinAnimationType: PinAnimationType.slide,
        pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
        animationCurve: Curves.bounceInOut,
        enableSuggestions: true,
        pinContentAlignment: AlignmentDirectional.center,
        isCursorAnimationEnabled: true,
        onCompleted: (value) async {
          await checkOtpValidation().then((msg) {
            if (msg != "") {
              setState(() {
                isLoading = false;
              });
              showMessage(context, msg, MessageType.warning);
            } else {
              setState(() {
                isLoading = false;
              });
              verifyOtp();
            }
          });
        },
      ),
    );
  }

  Widget resendOtpWidget() {
    return Center(
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: Theme.of(context).textTheme.titleSmall!.merge(
                TextStyle(
                  fontWeight: FontWeight.w400,
                  color: ColorsRes.mainTextColor,
                ),
              ),
          text: (_timer != null && _timer!.isActive)
              ? "${getTranslatedValue(
                  context,
                  "resend_otp_in",
                )} "
              : "",
          children: <TextSpan>[
            TextSpan(
                text: _timer != null && _timer!.isActive
                    ? '${_remaining.inMinutes.toString().padLeft(2, '0')}:${(_remaining.inSeconds % 60).toString().padLeft(2, '0')}'
                    : getTranslatedValue(
                        context,
                        "resend_otp",
                      ),
                style: TextStyle(
                    color: ColorsRes.appColor, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  headerWidget(String title, String subtitle) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: CustomTextLabel(
        text: title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
          color: ColorsRes.mainTextColor,
        ),
      ),
      subtitle: CustomTextLabel(
        text: subtitle,
        style: TextStyle(color: ColorsRes.grey),
      ),
    );
  }

  verifyOtp() async {
    setState(() {
      isLoading = true;
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: resendOtpVerificationId.isNotEmpty
              ? resendOtpVerificationId
              : widget.otpVerificationId,
          smsCode: pinController.text);

      widget.firebaseAuth.signInWithCredential(credential).then((value) {
        User? user = value.user;
        backendApiProcess(user);
      }).catchError((e) {
        showMessage(
          context,
          getTranslatedValue(
            context,
            "enter_valid_otp",
          ),
          MessageType.warning,
        );
        setState(() {
          isLoading = false;
        });
      });
    });
  }

  otpWidgets() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        headerWidget(
          getTranslatedValue(
            context,
            "enter_verification_code",
          ),
          getTranslatedValue(
            context,
            "otp_send_message",
          ),
        ),
        CustomTextLabel(
          text: "${widget.selectedCountryCode}-${widget.phoneNumber}",
        ),
        const SizedBox(height: 30),
        otpPinWidget(),
        const SizedBox(height: 30),
        GestureDetector(
          onTap: _timer != null && _timer!.isActive
              ? null
              : () {
                  setState(() {
                    startTimer();
                  });
                  firebaseLoginProcess();
                },
          child: resendOtpWidget(),
        ),
      ]),
    );
  }

  backendApiProcess(User? user) async {
    if (user != null) {
      Constant.session.setData(SessionManager.keyAuthUid, user.uid, false);
      Map<String, String> params = {
        ApiAndParams.authUid: user.uid, // In live this will use
        // ApiAndParams.authUid: "123456", // Temp used for testing
        ApiAndParams.platform: Platform.isAndroid ? "android" : "ios",
        ApiAndParams.fcmToken:
            Constant.session.getData(SessionManager.keyFCMToken),
      };

      await context
          .read<UserProfileProvider>()
          .loginApi(context: context, params: params)
          .then((value) async {
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
          } else if (Constant.session.getBoolData(SessionManager.isUserLogin)) {
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
          Map<String, String> params = {
            ApiAndParams.authUid: user.uid.toString(),
            ApiAndParams.name: user.displayName ?? "",
            ApiAndParams.email: user.email ?? "",
            ApiAndParams.countryCode: widget.selectedCountryCode.dialCode
                    ?.replaceAll("+", "")
                    .toString() ??
                "",
            ApiAndParams.mobile: user.phoneNumber
                .toString()
                .replaceAll(widget.selectedCountryCode.dialCode.toString(), ""),
            ApiAndParams.type: "phone",
            ApiAndParams.platform: Platform.isAndroid ? "android" : "ios",
            ApiAndParams.fcmToken:
                Constant.session.getData(SessionManager.keyFCMToken),
          };

          Navigator.of(context).pushReplacementNamed(editProfileScreen,
              arguments: [widget.from ?? "register", params]);
        }
      });
    }
  }

  Future checkOtpValidation() async {
    bool checkInternet = await checkInternetConnection();
    String? msg;
    if (checkInternet) {
      if (pinController.text.length == 1) {
        msg = getTranslatedValue(
          context,
          "enter_otp",
        );
      } else if (pinController.text.length < otpLength) {
        msg = getTranslatedValue(
          context,
          "enter_valid_otp",
        );
      } else {
        if (isLoading) return;
        setState(() {
          isLoading = true;
        });
        msg = "";
      }
    } else {
      msg = getTranslatedValue(
        context,
        "check_internet",
      );
    }
    return msg;
  }

  firebaseLoginProcess() async {
    if (widget.phoneNumber.isNotEmpty) {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber:
            '${widget.selectedCountryCode.dialCode} - ${widget.phoneNumber}',
        verificationCompleted: (PhoneAuthCredential credential) {
          pinController.setText(credential.smsCode ?? "");
        },
        verificationFailed: (FirebaseAuthException e) {
          showMessage(
            context,
            e.message!,
            MessageType.warning,
          );
          if (mounted) {
            isLoading = false;
            setState(() {});
          }
        },
        codeSent: (String verificationId, int? resendToken) {
          forceResendingToken = resendToken;
          if (mounted) {
            isLoading = false;
            setState(() {
              resendOtpVerificationId = verificationId;
            });
          }
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          if (mounted) {
            isLoading = false;
            setState(() {
              // isLoading = false;
            });
          }
        },
        forceResendingToken: forceResendingToken,
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (_timer != null) {
      _timer!.cancel();
    }
  }
}
