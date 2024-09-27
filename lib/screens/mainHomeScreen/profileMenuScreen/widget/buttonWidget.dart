import 'package:egrocer/helper/utils/generalImports.dart';

Widget buttonWidget(Widget icon, String lbl,
    {required Function onClickAction,
    required EdgeInsetsDirectional padding,
    required BuildContext context}) {
  return Padding(
    padding: padding,
    child: Container(
      decoration: DesignConfig.boxDecoration(Theme.of(context).cardColor, 5),
      padding: const EdgeInsets.all(5),
      child: InkWell(
        splashColor: ColorsRes.appColorLightHalfTransparent,
        highlightColor: Colors.transparent,
        onTap: () {
          onClickAction();
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            getSizedBox(
              height: 8,
            ),
            icon,
            getSizedBox(
              height: 8,
            ),
            CustomTextLabel(
              jsonKey: lbl,
              style: TextStyle(
                  color: ColorsRes.mainTextColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 17),
            ),
            getSizedBox(
              height: 8,
            ),
          ],
        ),
      ),
    ),
  );
}
