import 'package:egrocer/helper/utils/generalImports.dart';

class ProfileScreen extends StatefulWidget {
  final ScrollController scrollController;

  const ProfileScreen({
    Key? key,
    required this.scrollController,
  }) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List personalDataMenu = [];
  List settingsMenu = [];
  List otherInformationMenu = [];
  List deleteMenuItem = [];

  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) => setProfileMenuList());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(
        context: context,
        centerTitle: true,
        title: Padding(
          padding: EdgeInsetsDirectional.only(start: 15),
          child: CustomTextLabel(
            jsonKey: "profile",
            softWrap: true,
            style: TextStyle(color: ColorsRes.mainTextColor),
          ),
        ),
        showBackButton: false,
      ),
      body: Consumer<UserProfileProvider>(
        builder: (context, userProfileProvider, _) {
          setProfileMenuList();
          return ListView(
            controller: widget.scrollController,
            children: [
              ProfileHeader(),
              QuickUseWidget(),
              menuItemsContainer(
                title: "personal_data",
                menuItem: personalDataMenu,
              ),
              menuItemsContainer(
                title: "settings",
                menuItem: settingsMenu,
              ),
              menuItemsContainer(
                title: "other_information",
                menuItem: otherInformationMenu,
              ),
              menuItemsContainer(
                title: "",
                menuItem: deleteMenuItem,
                fontColor: ColorsRes.appColorRed,
                iconColor: ColorsRes.appColorRed,
              ),
            ],
          );
        },
      ),
    );
  }

  setProfileMenuList() {
    personalDataMenu = [];
    settingsMenu = [];
    otherInformationMenu = [];
    deleteMenuItem = [];

    personalDataMenu = [
      if (Constant.session.isUserLoggedIn())
        {
          "icon": "wallet_history_icon",
          "label": "my_wallet",
          "value": Consumer<SessionManager>(
            builder: (context, sessionManager, child) {
              return CustomTextLabel(
                text:
                    "${sessionManager.getData(SessionManager.keyWalletBalance)}"
                        .currency,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 17,
                  color: ColorsRes.mainTextColor,
                  fontWeight: FontWeight.w600,
                ),
              );
            },
          ),
          "clickFunction": (context) {
            Navigator.pushNamed(context, walletHistoryListScreen);
          },
          "isResetLabel": false
        },
      if (Constant.session.isUserLoggedIn())
        {
          "icon": "notification_icon",
          "label": "notification",
          "clickFunction": (context) {
            Navigator.pushNamed(context, notificationListScreen);
          },
          "isResetLabel": false
        },
      if (Constant.session.isUserLoggedIn())
        {
          "icon": "transaction_icon",
          "label": "transaction_history",
          "clickFunction": (context) {
            Navigator.pushNamed(context, transactionListScreen);
          },
          "isResetLabel": false
        },
    ];

    settingsMenu = [
      {
        "icon": "theme_icon",
        "label": "change_theme",
        "clickFunction": (context) {
          showModalBottomSheet<void>(
            context: context,
            isScrollControlled: true,
            shape: DesignConfig.setRoundedBorderSpecific(20, istop: true),
            backgroundColor: Theme.of(context).cardColor,
            builder: (BuildContext context) {
              return Wrap(
                children: [
                  BottomSheetThemeListContainer(),
                ],
              );
            },
          );
        },
        "isResetLabel": true,
      },
      if (context.read<LanguageProvider>().languages.length > 1)
        {
          "icon": "translate_icon",
          "label": "change_language",
          "clickFunction": (context) {
            showModalBottomSheet<void>(
              context: context,
              isScrollControlled: true,
              shape: DesignConfig.setRoundedBorderSpecific(20, istop: true),
              backgroundColor: Theme.of(context).cardColor,
              builder: (BuildContext context) {
                return Wrap(
                  children: [
                    BottomSheetLanguageListContainer(),
                  ],
                );
              },
            );
          },
          "isResetLabel": true,
        },
      if (Constant.session.isUserLoggedIn())
        {
          "icon": "settings",
          "label": "notifications_settings",
          "clickFunction": (context) {
            Navigator.pushNamed(
                context, notificationsAndMailSettingsScreenScreen);
          },
          "isResetLabel": false
        },
    ];

    otherInformationMenu = [
/*      if (isUserLogin)
        {
          "icon": "refer_friend_icon",
          "label": "refer_and_earn",
          "clickFunction": ReferAndEarn(),
          "isResetLabel": false
        },*/
      {
        "icon": "contact_icon",
        "label": "contact_us",
        "clickFunction": (context) {
          Navigator.pushNamed(
            context,
            webViewScreen,
            arguments: getTranslatedValue(
              context,
              "contact_us",
            ),
          );
        }
      },
      {
        "icon": "about_icon",
        "label": "about_us",
        "clickFunction": (context) {
          Navigator.pushNamed(
            context,
            webViewScreen,
            arguments: getTranslatedValue(
              context,
              "about_us",
            ),
          );
        },
        "isResetLabel": false
      },
      {
        "icon": "rate_us_icon",
        "label": "rate_us",
        "clickFunction": (BuildContext context) {
          launchUrl(
              Uri.parse(Platform.isAndroid
                  ? Constant.playStoreUrl
                  : Constant.appStoreUrl),
              mode: LaunchMode.externalApplication);
        },
      },
      {
        "icon": "share_icon",
        "label": "share_app",
        "clickFunction": (BuildContext context) {
          String shareAppMessage = getTranslatedValue(
            context,
            "share_app_message",
          );
          if (Platform.isAndroid) {
            shareAppMessage = "$shareAppMessage${Constant.playStoreUrl}";
          } else if (Platform.isIOS) {
            shareAppMessage = "$shareAppMessage${Constant.appStoreUrl}";
          }
          Share.share(shareAppMessage, subject: "Share app");
        },
      },
      {
        "icon": "faq_icon",
        "label": "faq",
        "clickFunction": (context) {
          Navigator.pushNamed(context, faqListScreen);
        }
      },
      {
        "icon": "terms_icon",
        "label": "terms_and_conditions",
        "clickFunction": (context) {
          Navigator.pushNamed(context, webViewScreen,
              arguments: getTranslatedValue(
                context,
                "terms_and_conditions",
              ));
        }
      },
      {
        "icon": "privacy_icon",
        "label": "policies",
        "clickFunction": (context) {
          Navigator.pushNamed(context, webViewScreen,
              arguments: getTranslatedValue(
                context,
                "policies",
              ));
        }
      },
      if (Constant.session.isUserLoggedIn())
        {
          "icon": "logout_icon",
          "label": "logout",
          "clickFunction": Constant.session.logoutUser,
          "isResetLabel": false
        },
    ];

    deleteMenuItem = [
      if (Constant.session.isUserLoggedIn())
        {
          "icon": "delete_user_account_icon",
          "label": "delete_user_account",
          "clickFunction": Constant.session.deleteUserAccount,
          "isResetLabel": false
        },
    ];
  }

  Widget menuItemsContainer({
    required String title,
    required List menuItem,
    Color? iconColor,
    Color? fontColor,
  }) {
    if (menuItem.isNotEmpty) {
      return Container(
        decoration: DesignConfig.boxDecoration(Theme.of(context).cardColor, 5),
        padding: EdgeInsetsDirectional.only(start: 10, end: 10),
        margin: EdgeInsetsDirectional.only(
          start: 10,
          end: 10,
          bottom: 10,
          top: Constant.session.isUserLoggedIn() ? 0 : 10,
        ),
        child: ListView(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          children: [
            if (title.isNotEmpty) getSizedBox(height: 10),
            if (title.isNotEmpty)
              CustomTextLabel(
                jsonKey: title,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: ColorsRes.mainTextColor,
                ),
              ),
            if (title.isNotEmpty) getSizedBox(height: 10),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(
                menuItem.length,
                (index) => Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        menuItem[index]['clickFunction'](context);
                      },
                      child: Padding(
                        padding:
                            EdgeInsetsDirectional.only(top: 10, bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            defaultImg(
                              image: menuItem[index]['icon'],
                              iconColor: iconColor ?? ColorsRes.mainTextColor,
                              height: 24,
                              width: 24,
                            ),
                            getSizedBox(width: 15),
                            Expanded(
                              child: CustomTextLabel(
                                jsonKey: menuItem[index]['label'],
                                style: TextStyle(
                                  fontSize: 17,
                                  color: fontColor ?? ColorsRes.mainTextColor,
                                ),
                              ),
                            ),
                            if (menuItem[index]['value'] != null)
                              menuItem[index]['value'],
                            if (menuItem[index]['value'] != null)
                              getSizedBox(width: 10),
                            Icon(
                              Icons.navigate_next,
                              color: fontColor ??
                                  ColorsRes.mainTextColor.withOpacity(0.5),
                            )
                          ],
                        ),
                      ),
                    ),
                    if (index != menuItem.length - 1)
                      getDivider(
                        height: 5,
                        color: fontColor ??
                            ColorsRes.mainTextColor.withOpacity(0.1),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return SizedBox.shrink();
    }
  }
}
