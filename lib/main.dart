import 'package:egrocer/helper/utils/generalImports.dart';

late final SharedPreferences prefs;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  prefs = await SharedPreferences.getInstance();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    await FirebaseMessaging.instance.setAutoInitEnabled(true);
  } catch (_) {}

  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent));

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<DeepLinkProvider>(
          create: (context) {
            return DeepLinkProvider();
          },
        ),
        ChangeNotifierProvider<HomeMainScreenProvider>(
          create: (context) {
            return HomeMainScreenProvider();
          },
        ),
        ChangeNotifierProvider<CategoryListProvider>(
          create: (context) {
            return CategoryListProvider();
          },
        ),
        ChangeNotifierProvider<CityByLatLongProvider>(
          create: (context) {
            return CityByLatLongProvider();
          },
        ),
        ChangeNotifierProvider<HomeScreenProvider>(
          create: (context) {
            return HomeScreenProvider();
          },
        ),
        ChangeNotifierProvider<ProductChangeListingTypeProvider>(
          create: (context) {
            return ProductChangeListingTypeProvider();
          },
        ),
        ChangeNotifierProvider<FaqProvider>(
          create: (context) {
            return FaqProvider();
          },
        ),
        ChangeNotifierProvider<ProductWishListProvider>(
          create: (context) {
            return ProductWishListProvider();
          },
        ),
        ChangeNotifierProvider<ProductAddOrRemoveFavoriteProvider>(
          create: (context) {
            return ProductAddOrRemoveFavoriteProvider();
          },
        ),
        ChangeNotifierProvider<UserProfileProvider>(
          create: (context) {
            return UserProfileProvider();
          },
        ),
        ChangeNotifierProvider<CartListProvider>(
          create: (context) {
            return CartListProvider();
          },
        ),
        ChangeNotifierProvider<LanguageProvider>(
          create: (context) {
            return LanguageProvider();
          },
        ),
        ChangeNotifierProvider<ThemeProvider>(
          create: (context) {
            return ThemeProvider();
          },
        ),
        ChangeNotifierProvider<AppSettingsProvider>(
          create: (context) {
            return AppSettingsProvider();
          },
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  MyAppState createState() => MyAppState();
}

class GlobalScrollBehavior extends ScrollBehavior {
  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const ClampingScrollPhysics();
  }
}

class MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SessionManager>(
      create: (_) => SessionManager(prefs: prefs),
      child: Consumer<SessionManager>(
        builder: (context, SessionManager sessionNotifier, child) {
          Constant.session =
              Provider.of<SessionManager>(context, listen: false);

          if (Constant.session
              .getData(SessionManager.appThemeName)
              .toString()
              .isEmpty) {
            Constant.session.setData(
                SessionManager.appThemeName, Constant.themeList[0], false);
            Constant.session.setBoolData(
                SessionManager.isDarkTheme,
                PlatformDispatcher.instance.platformBrightness ==
                    Brightness.dark,
                false);
          }

          // This callback is called every time the brightness changes from the device.
          PlatformDispatcher.instance.onPlatformBrightnessChanged = () {
            if (Constant.session.getData(SessionManager.appThemeName) ==
                Constant.themeList[0]) {
              Constant.session.setBoolData(
                  SessionManager.isDarkTheme,
                  PlatformDispatcher.instance.platformBrightness ==
                      Brightness.dark,
                  true);
            }
          };

          return Consumer<LanguageProvider>(
            builder: (context, languageProvider, child) {
              if (Constant.session
                  .getData(SessionManager.appThemeName)
                  .toString()
                  .isEmpty) {
                Constant.session.setData(
                    SessionManager.appThemeName, Constant.themeList[0], false);
                Constant.session.setBoolData(
                    SessionManager.isDarkTheme,
                    PlatformDispatcher.instance.platformBrightness ==
                        Brightness.dark,
                    false);
              }

              // This callback is called every time the brightness changes from the device.
              PlatformDispatcher.instance.onPlatformBrightnessChanged = () {
                if (Constant.session.getData(SessionManager.appThemeName) ==
                    Constant.themeList[0]) {
                  Constant.session.setBoolData(
                      SessionManager.isDarkTheme,
                      PlatformDispatcher.instance.platformBrightness ==
                          Brightness.dark,
                      true);
                }
              };

              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                child: MaterialApp(
                  builder: (context, child) {
                    return ScrollConfiguration(
                      behavior: GlobalScrollBehavior(),
                      child: Center(
                        child: Directionality(
                          textDirection: languageProvider.languageDirection
                                      .toLowerCase() ==
                                  "rtl"
                              ? TextDirection.rtl
                              : TextDirection.ltr,
                          child: child!,
                        ),
                      ),
                    );
                  },
                  navigatorKey: Constant.navigatorKay,
                  onGenerateRoute: RouteGenerator.generateRoute,
                  initialRoute: "/",
                  scrollBehavior: ScrollGlowBehavior(),
                  debugShowCheckedModeBanner: false,
                  title: "egrocer",
                  theme: ColorsRes.setAppTheme().copyWith(
                    textTheme:
                        GoogleFonts.latoTextTheme(Theme.of(context).textTheme),
                  ),
                  home: SplashScreen(),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
