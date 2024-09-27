import 'package:egrocer/helper/utils/generalImports.dart';
import 'package:image_picker_platform_interface/src/types/image_source.dart'
    as ip;

class EditProfile extends StatefulWidget {
  final String? from;
  final Map<String, String>? loginParams;

  const EditProfile({Key? key, this.from, this.loginParams}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController edtUsername = TextEditingController();
  late TextEditingController edtEmail = TextEditingController();
  late TextEditingController edtMobile = TextEditingController();
  bool isLoading = false;
  String tempName = "";
  String tempEmail = "";
  String tempMobile = "";
  String selectedImagePath = "";

  bool isEditable = false;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero).then((value) {
      if (Constant.session.isUserLoggedIn()) {
        isEditable =
            Constant.session.getData(SessionManager.keyLoginType) == "phone";
      } else {
        isEditable = widget.loginParams?[ApiAndParams.type] == "phone";
      }

      tempName = widget.from == "header"
          ? Constant.session.getData(SessionManager.keyUserName)
          : widget.loginParams?[ApiAndParams.name] ?? "";
      tempEmail = widget.from == "header"
          ? Constant.session.getData(SessionManager.keyEmail)
          : widget.loginParams?[ApiAndParams.email] ?? "";
      tempMobile = widget.from == "header"
          ? Constant.session.getData(SessionManager.keyPhone)
          : widget.loginParams?[ApiAndParams.mobile] ?? "";

      edtUsername = TextEditingController(text: tempName);
      edtEmail = TextEditingController(text: tempEmail);
      edtMobile = TextEditingController(text: tempMobile);

      selectedImagePath = "";
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(
        context: context,
        title: CustomTextLabel(
          text: widget.from == "register"
              ? getTranslatedValue(
                  context,
                  "register",
                )
              : getTranslatedValue(
                  context,
                  "edit_profile",
                ),
          style: TextStyle(color: ColorsRes.mainTextColor),
        ),
        showBackButton: widget.from != "register",
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(
            horizontal: Constant.size10, vertical: Constant.size15),
        children: [
          imgWidget(),
          Container(
            decoration:
                DesignConfig.boxDecoration(Theme.of(context).cardColor, 10),
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.only(top: 20),
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: Constant.size10, vertical: Constant.size15),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  userInfoWidget(),
                  const SizedBox(height: 50),
                  proceedBtn()
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  proceedBtn() {
    return Consumer<UserProfileProvider>(
      builder: (context, userProfileProvider, _) {
        return userProfileProvider.profileState == ProfileState.loading
            ? const Center(child: CircularProgressIndicator())
            : gradientBtnWidget(
                context,
                10,
                title: getTranslatedValue(
                  context,
                  widget.from == "register_header" ? "register" : "update",
                ),
                callback: () {
                  try {
                    _formKey.currentState!.save();
                    if (_formKey.currentState!.validate()) {
                      widget.loginParams?[ApiAndParams.name] =
                          edtUsername.text.trim();
                      widget.loginParams?[ApiAndParams.email] =
                          edtEmail.text.trim();
                      widget.loginParams?[ApiAndParams.mobile] =
                          edtMobile.text.trim();
                      if (widget.from == "register" ||
                          widget.from == "register_header") {
                        userProfileProvider
                            .registerAccountApi(
                                context: context,
                                params: widget.loginParams ?? {})
                            .then(
                          (value) {
                            if (context
                                .read<CartListProvider>()
                                .cartList
                                .isNotEmpty) {
                              addGuestCartBulkToCartWhileLogin(
                                context: context,
                                params: Constant.setGuestCartParams(
                                  cartList:
                                      context.read<CartListProvider>().cartList,
                                ),
                              ).then(
                                (value) => Navigator.of(context)
                                    .pushNamedAndRemoveUntil(mainHomeScreen,
                                        (Route<dynamic> route) => false),
                              );
                            } else {
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  mainHomeScreen,
                                  (Route<dynamic> route) => false);
                            }
                          },
                        );
                      } else if (widget.from == "add_to_cart") {
                        Map<String, String> params = {};
                        params[ApiAndParams.name] = edtUsername.text.trim();
                        params[ApiAndParams.email] = edtEmail.text.trim();
                        userProfileProvider
                            .updateUserProfile(
                                context: context,
                                selectedImagePath: selectedImagePath,
                                params: params)
                            .then(
                          (value) {
                            if (context
                                .read<CartListProvider>()
                                .cartList
                                .isNotEmpty) {
                              addGuestCartBulkToCartWhileLogin(
                                  context: context,
                                  params: Constant.setGuestCartParams(
                                    cartList: context
                                        .read<CartListProvider>()
                                        .cartList,
                                  )).then(
                                (value) {
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                },
                              );
                            } else {
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  mainHomeScreen,
                                  (Route<dynamic> route) => false);
                            }
                          },
                        );
                      } else {
                        Map<String, String> params = {};
                        params[ApiAndParams.name] = edtUsername.text.trim();
                        params[ApiAndParams.email] = edtEmail.text.trim();
                        userProfileProvider
                            .updateUserProfile(
                                context: context,
                                selectedImagePath: selectedImagePath,
                                params: params)
                            .then(
                          (value) {
                            if (value is bool) {
                              if (Constant.session.getData(
                                          SessionManager.keyLatitude) ==
                                      "0" &&
                                  Constant.session.getData(
                                          SessionManager.keyLongitude) ==
                                      "0" &&
                                  Constant.session
                                          .getData(SessionManager.keyAddress) ==
                                      "") {
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                  confirmLocationScreen,
                                  (Route<dynamic> route) => false,
                                  arguments: [null, "location"],
                                );
                              } else {
                                if (widget.from == "header") {
                                  if (context
                                      .read<CartListProvider>()
                                      .cartList
                                      .isNotEmpty) {
                                    addGuestCartBulkToCartWhileLogin(
                                      context: context,
                                      params: Constant.setGuestCartParams(
                                        cartList: context
                                            .read<CartListProvider>()
                                            .cartList,
                                      ),
                                    ).then(
                                      (value) => Navigator.of(context)
                                          .pushNamedAndRemoveUntil(
                                        mainHomeScreen,
                                        (Route<dynamic> route) => false,
                                      ),
                                    );
                                  } else {
                                    Navigator.of(context)
                                        .pushNamedAndRemoveUntil(
                                      mainHomeScreen,
                                      (Route<dynamic> route) => false,
                                    );
                                  }
                                } else if (widget.from == "add_to_cart") {
                                  addGuestCartBulkToCartWhileLogin(
                                      context: context,
                                      params: Constant.setGuestCartParams(
                                        cartList: context
                                            .read<CartListProvider>()
                                            .cartList,
                                      )).then(
                                    (value) {
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    },
                                  );
                                } else {
                                  showMessage(
                                    context,
                                    getTranslatedValue(context,
                                        "profile_updated_successfully"),
                                    MessageType.success,
                                  );
                                }
                              }
                              userProfileProvider.changeState();
                            } else {
                              userProfileProvider.changeState();
                              showMessage(
                                context,
                                value.toString(),
                                MessageType.warning,
                              );
                            }
                          },
                        );
                      }
                    }
                  } catch (e) {
                    userProfileProvider.changeState();
                    showMessage(
                      context,
                      e.toString(),
                      MessageType.error,
                    );
                  }
                },
              );
      },
    );
  }

  userInfoWidget() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          editBoxWidget(
            context,
            edtUsername,
            emptyValidation,
            getTranslatedValue(
              context,
              "user_name",
            ),
            getTranslatedValue(
              context,
              "enter_user_name",
            ),
            TextInputType.text,
          ),
          SizedBox(height: Constant.size15),
          editBoxWidget(
            context,
            edtEmail,
            validateEmail,
            getTranslatedValue(
              context,
              "email",
            ),
            getTranslatedValue(
              context,
              "enter_valid_email",
            ),
            TextInputType.text,
            isEditable: (tempEmail.isEmpty || isEditable),
          ),
          SizedBox(height: Constant.size15),
          editBoxWidget(
            context,
            edtMobile,
            phoneValidation,
            getTranslatedValue(
              context,
              "mobile_number",
            ),
            getTranslatedValue(
              context,
              "enter_valid_mobile",
            ),
            TextInputType.text,
            isEditable: !isEditable,
          ),
        ],
      ),
    );
  }

  imgWidget() {
    return Center(
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.only(bottom: 15, end: 15),
            child: ClipRRect(
              borderRadius: Constant.borderRadius10,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: selectedImagePath.isEmpty
                  ? setNetworkImg(
                      height: 100,
                      width: 100,
                      boxFit: BoxFit.cover,
                      image:
                          Constant.session.getData(SessionManager.keyUserImage),
                    )
                  : Image.file(
                      File(selectedImagePath),
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          if (widget.from != "register")
            Positioned(
              right: 0,
              bottom: 0,
              child: GestureDetector(
                onTap: () async {
                  showModalBottomSheet<XFile>(
                    context: context,
                    isScrollControlled: true,
                    shape:
                        DesignConfig.setRoundedBorderSpecific(20, istop: true),
                    backgroundColor: Theme.of(context).cardColor,
                    builder: (BuildContext context) {
                      return Wrap(
                        children: [
                          Padding(
                            padding: EdgeInsetsDirectional.only(
                                start: 20, end: 20, bottom: 20),
                            child: Column(
                              children: [
                                getSizedBox(
                                  height: 20,
                                ),
                                Center(
                                  child: CustomTextLabel(
                                    jsonKey: "select_option",
                                    softWrap: true,
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .merge(
                                          TextStyle(
                                            letterSpacing: 0.5,
                                            color: ColorsRes.mainTextColor,
                                          ),
                                        ),
                                  ),
                                ),
                                getSizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () async {
                                        PermissionStatus storageStatus =
                                            await Permission.storage.status;
                                        PermissionStatus photoStatus =
                                            await Permission.photos.status;

                                        if (storageStatus.isGranted ||
                                            photoStatus.isGranted) {
                                          ImagePicker()
                                              .pickImage(
                                            source: ip.ImageSource.gallery,
                                          )
                                              .then((value) {
                                            if (value != null) {
                                              Navigator.pop(context, value);
                                            }
                                          });
                                        } else if (storageStatus.isDenied ||
                                            photoStatus.isDenied) {
                                          if (Platform.isIOS) {
                                            Permission.storage.request();
                                          } else if (Platform.isAndroid) {
                                            final deviceInfoPlugin =
                                                DeviceInfoPlugin();
                                            final androidDeviceInfo =
                                                await deviceInfoPlugin
                                                    .androidInfo;
                                            if (androidDeviceInfo
                                                    .version.sdkInt <
                                                33) {
                                              Permission.storage.request();
                                            } else if (androidDeviceInfo
                                                    .version.sdkInt >=
                                                33) {
                                              Permission.photos.request();
                                            }
                                          }
                                        } else if (storageStatus
                                                .isPermanentlyDenied ||
                                            photoStatus.isPermanentlyDenied) {
                                          if (!Constant.session.getBoolData(
                                              SessionManager
                                                  .keyPermissionGalleryHidePromptPermanently)) {
                                            showModalBottomSheet(
                                              context: context,
                                              builder: (context) {
                                                return Wrap(
                                                  children: [
                                                    PermissionHandlerBottomSheet(
                                                      titleJsonKey:
                                                          "storage_permission_title",
                                                      messageJsonKey:
                                                          "storage_permission_message",
                                                      sessionKeyForAskNeverShowAgain:
                                                          SessionManager
                                                              .keyPermissionGalleryHidePromptPermanently,
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          }
                                        }
                                      },
                                      icon: Icon(
                                        Icons.image_rounded,
                                        size: 50,
                                      ),
                                      splashColor: ColorsRes.appColor,
                                      splashRadius: 50,
                                      color: ColorsRes.subTitleMainTextColor,
                                      tooltip: getTranslatedValue(
                                          context, "gallery"),
                                    ),
                                    getSizedBox(
                                      width: 10,
                                    ),
                                    IconButton(
                                      onPressed: () async {
                                        await hasCameraPermissionGiven(context)
                                            .then(
                                          (value) async {
                                            if (value is PermissionStatus) {
                                              if (Platform.isAndroid) {
                                                if (value.isGranted) {
                                                  ImagePicker()
                                                      .pickImage(
                                                    source:
                                                        ip.ImageSource.camera,
                                                    preferredCameraDevice:
                                                        CameraDevice.front,
                                                    maxHeight: 512,
                                                    maxWidth: 512,
                                                  )
                                                      .then(
                                                    (value) {
                                                      if (value != null) {
                                                        Navigator.pop(
                                                            context, value);
                                                      }
                                                    },
                                                  );
                                                } else if (value.isDenied) {
                                                  await Permission.camera
                                                      .request();
                                                } else if (value
                                                    .isPermanentlyDenied) {
                                                  if (!Constant.session
                                                      .getBoolData(SessionManager
                                                          .keyPermissionCameraHidePromptPermanently)) {
                                                    showModalBottomSheet(
                                                      context: context,
                                                      builder: (context) {
                                                        return Wrap(
                                                          children: [
                                                            PermissionHandlerBottomSheet(
                                                              titleJsonKey:
                                                                  "camera_permission_title",
                                                              messageJsonKey:
                                                                  "camera_permission_message",
                                                              sessionKeyForAskNeverShowAgain:
                                                                  SessionManager
                                                                      .keyPermissionCameraHidePromptPermanently,
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    );
                                                  }
                                                }
                                              } else if (Platform.isIOS) {
                                                ImagePicker()
                                                    .pickImage(
                                                  source: ip.ImageSource.camera,
                                                  preferredCameraDevice:
                                                      CameraDevice.front,
                                                  maxHeight: 512,
                                                  maxWidth: 512,
                                                )
                                                    .then(
                                                  (value) {
                                                    if (value != null) {
                                                      Navigator.pop(
                                                          context, value);
                                                    }
                                                  },
                                                );
                                              }
                                            }
                                          },
                                        );
                                      },
                                      icon: Icon(
                                        Icons.camera_alt_rounded,
                                        color: ColorsRes.subTitleMainTextColor,
                                        size: 50,
                                      ),
                                      splashColor: ColorsRes.appColor,
                                      splashRadius: 50,
                                      color: ColorsRes.subTitleMainTextColor,
                                      tooltip: getTranslatedValue(
                                        context,
                                        "take_photo",
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      );
                    },
                  ).then(
                    (value) {
                      if (value != null) {
                        cropImage(value.path);
                      }
                    },
                  );
                },
                child: Container(
                  decoration: DesignConfig.boxGradient(5),
                  padding: const EdgeInsets.all(5),
                  margin: const EdgeInsetsDirectional.only(end: 8, top: 8),
                  child: defaultImg(
                    image: "edit_icon",
                    iconColor: ColorsRes.mainIconColor,
                    height: 15,
                    width: 15,
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }

  Future<void> cropImage(String filePath) async {
    await ImageCropper().cropImage(
      sourcePath: filePath,
      aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
      compressQuality: 50,
      compressFormat: ImageCompressFormat.png,
      maxHeight: 512,
      maxWidth: 512,
      uiSettings: [
        AndroidUiSettings(
          toolbarColor: Theme.of(context).cardColor,
          toolbarWidgetColor: ColorsRes.mainTextColor,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: true,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          activeControlsWidgetColor: ColorsRes.appColor,
        ),
        IOSUiSettings(
          minimumAspectRatio: 1.0,
          aspectRatioPickerButtonHidden: false,
          aspectRatioLockDimensionSwapEnabled: true,
          aspectRatioLockEnabled: true,
          resetAspectRatioEnabled: true,
        ),
      ],
    ).then(
      (croppedFile) {
        if (croppedFile != null) {
          selectedImagePath = croppedFile.path;
          setState(() {});
        }
      },
    );
  }

  @override
  void dispose() {
    edtUsername.dispose();
    edtEmail.dispose();
    edtMobile.dispose();
    super.dispose();
  }
}
