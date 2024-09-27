import 'package:egrocer/helper/utils/generalImports.dart';

class BottomSheetThemeListContainer extends StatefulWidget {
  BottomSheetThemeListContainer({
    Key? key,
  }) : super(key: key);

  @override
  State<BottomSheetThemeListContainer> createState() =>
      _BottomSheetThemeListContainerState();
}

class _BottomSheetThemeListContainerState
    extends State<BottomSheetThemeListContainer> {
  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      await context.read<ThemeProvider>().setSelectedTheme(
          currentTheme: Constant.session.getData(SessionManager.appThemeName));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List lblThemeDisplayNames = [
      "theme_display_names_system_default",
      "theme_display_names_light",
      "theme_display_names_dark",
    ];

    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            getSizedBox(
              height: 20,
            ),
            Center(
              child: CustomTextLabel(
                jsonKey: "change_theme",
                softWrap: true,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium!.merge(
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
            ListView(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              children: List.generate(
                3,
                (index) {
                  return GestureDetector(
                    onTap: () {
                      themeProvider.setSelectedTheme(
                        currentTheme: Constant.themeList[index],
                      );
                    },
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsetsDirectional.only(
                                start: Constant.size10),
                            child: CustomTextLabel(
                              jsonKey: lblThemeDisplayNames[index],
                            ),
                          ),
                        ),
                        CustomRadio(
                          inactiveColor: ColorsRes.mainTextColor,
                          activeColor: ColorsRes.appColor,
                          value: index == 0
                              ? ThemeState.systemDefault
                              : index == 1
                                  ? ThemeState.light
                                  : ThemeState.dark,
                          groupValue: themeProvider.themeState,
                          onChanged: (value) {
                            themeProvider.setSelectedTheme(
                              currentTheme: Constant.themeList[index],
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.only(
                start: 10,
                end: 10,
                bottom: 25,
              ),
              child: gradientBtnWidget(
                context,
                10,
                callback: () {
                  Navigator.pop(context);
                  themeProvider.updateTheme(
                    currentTheme:
                        themeProvider.themeState == ThemeState.systemDefault
                            ? Constant.themeList[0]
                            : themeProvider.themeState == ThemeState.light
                                ? Constant.themeList[1]
                                : Constant.themeList[2],
                  );
                },
                otherWidgets: CustomTextLabel(
                  jsonKey: "change",
                  softWrap: true,
                  style: Theme.of(context).textTheme.titleMedium!.merge(
                        TextStyle(
                          color: Colors.white,
                          letterSpacing: 0.5,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
