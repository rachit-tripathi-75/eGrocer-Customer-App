import 'package:egrocer/helper/utils/generalImports.dart';
import 'package:geolocator/geolocator.dart';

class HomeMainScreen extends StatefulWidget {
  const HomeMainScreen({Key? key}) : super(key: key);

  @override
  State<HomeMainScreen> createState() => HomeMainScreenState();
}

class HomeMainScreenState extends State<HomeMainScreen> {
  NetworkStatus networkStatus = NetworkStatus.online;

  @override
  void dispose() {
    context
        .read<HomeMainScreenProvider>()
        .scrollController[0]
        .removeListener(() {});
    context
        .read<HomeMainScreenProvider>()
        .scrollController[1]
        .removeListener(() {});
    context
        .read<HomeMainScreenProvider>()
        .scrollController[2]
        .removeListener(() {});
    context
        .read<HomeMainScreenProvider>()
        .scrollController[3]
        .removeListener(() {});
    super.dispose();
  }

  @override
  void initState() {
    if (mounted) {
      context.read<HomeMainScreenProvider>().setPages();
    }
    Future.delayed(
      Duration.zero,
      () async {
        if (!Constant.session.isUserLoggedIn()) {
          Map<String, String> params = {
            ApiAndParams.fcmToken:
                Constant.session.getData(SessionManager.keyFCMToken),
            ApiAndParams.platform: Platform.isAndroid ? "android" : "ios"
          };

          registerFcmKey(context: context, params: params);
        }

        LocationPermission permission;
        permission = await Geolocator.checkPermission();

        if (permission == LocationPermission.denied) {
          permission = await Geolocator.requestPermission();
        } else if (permission == LocationPermission.deniedForever) {
          return Future.error('Location Not Available');
        }

        if ((Constant.session.getData(SessionManager.keyLatitude) == "" &&
                Constant.session.getData(SessionManager.keyLongitude) == "") ||
            (Constant.session.getData(SessionManager.keyLatitude) == "0" &&
                Constant.session.getData(SessionManager.keyLongitude) == "0")) {
          Navigator.pushNamed(context, confirmLocationScreen,
              arguments: [null, "location"]);
        } else {
          if (context.read<HomeMainScreenProvider>().getCurrentPage() == 0) {
            if (Constant.popupBannerEnabled) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return CustomDialog();
                },
              );
            }
          }

          if (Constant.session.isUserLoggedIn()) {
            await getAppNotificationSettingsRepository(
                    params: {}, context: context)
                .then(
              (value) async {
                if (value[ApiAndParams.status].toString() == "1") {
                  late AppNotificationSettings notificationSettings =
                      AppNotificationSettings.fromJson(value);
                  if (notificationSettings.data!.isEmpty) {
                    await updateAppNotificationSettingsRepository(params: {
                      ApiAndParams.statusIds: "1,2,3,4,5,6,7,8",
                      ApiAndParams.mobileStatuses: "0,1,1,1,1,1,1,1",
                      ApiAndParams.mailStatuses: "0,1,1,1,1,1,1,1"
                    }, context: context);
                  }
                }
              },
            );
          }
        }
      },
    ).then((value) {
      context.read<DeepLinkProvider>().getDeepLinkRedirection(context: context);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeMainScreenProvider>(
      builder: (context, homeMainScreenProvider, child) {
        return Scaffold(
          bottomNavigationBar: homeBottomNavigation(
            homeMainScreenProvider.getCurrentPage(),
            homeMainScreenProvider.selectBottomMenu,
            homeMainScreenProvider.getPages().length,
            context,
          ),
          body: networkStatus == NetworkStatus.online
              ? PopScope(
                  canPop: false,
                  onPopInvoked: (didPop) {
                    if (didPop) {
                      return;
                    } else {
                      if (homeMainScreenProvider.currentPage == 0) {
                        if (Platform.isAndroid) {
                          SystemNavigator.pop();
                        } else if (Platform.isIOS) {
                          exit(0);
                        }
                      } else {
                        setState(() {});
                        homeMainScreenProvider.currentPage = 0;
                      }
                    }
                  },
                  child: IndexedStack(
                    index: homeMainScreenProvider.currentPage,
                    children: homeMainScreenProvider.getPages(),
                  ),
                )
              : Center(
                  child: CustomTextLabel(
                    jsonKey: "check_internet",
                  ),
                ),
        );
      },
    );
  }

  homeBottomNavigation(int selectedIndex, Function selectBottomMenu,
      int totalPage, BuildContext context) {
    List lblHomeBottomMenu = [
      getTranslatedValue(
        context,
        "home_bottom_menu_home",
      ),
      getTranslatedValue(
        context,
        "home_bottom_menu_category",
      ),
      getTranslatedValue(
        context,
        "home_bottom_menu_wishlist",
      ),
      getTranslatedValue(
        context,
        "home_bottom_menu_profile",
      ),
    ];
    return BottomNavigationBar(
        items: List.generate(
          totalPage,
          (index) => BottomNavigationBarItem(
            backgroundColor: Theme.of(context).cardColor,
            icon: getHomeBottomNavigationBarIcons(
                isActive: selectedIndex == index)[index],
            label: lblHomeBottomMenu[index],
          ),
        ),
        type: BottomNavigationBarType.shifting,
        currentIndex: selectedIndex,
        selectedItemColor: ColorsRes.mainTextColor,
        unselectedItemColor: Colors.transparent,
        onTap: (int ind) {
          selectBottomMenu(ind);
        },
        elevation: 5);
  }
}
