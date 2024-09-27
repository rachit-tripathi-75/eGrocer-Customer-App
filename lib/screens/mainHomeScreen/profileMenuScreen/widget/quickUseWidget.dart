import 'package:egrocer/helper/utils/generalImports.dart';

class QuickUseWidget extends StatelessWidget {
  const QuickUseWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Constant.session.isUserLoggedIn()
        ? Padding(
            padding: const EdgeInsetsDirectional.all(10),
            child: Row(
              children: [
                Expanded(
                  child: buttonWidget(
                    defaultImg(
                      image: "orders",
                      iconColor: ColorsRes.mainTextColor,
                      height: 23,
                      width: 23,
                    ),
                    "all_orders",
                    onClickAction: () {
                      Navigator.pushNamed(
                        context,
                        orderHistoryScreen,
                      );
                    },
                    padding: const EdgeInsetsDirectional.only(
                      end: 5,
                    ),
                    context: context,
                  ),
                ),
                Expanded(
                  child: buttonWidget(
                    defaultImg(
                      image: "home_map_icon",
                      iconColor: ColorsRes.mainTextColor,
                      height: 23,
                      width: 23,
                    ),
                    "address",
                    onClickAction: () => Navigator.pushNamed(
                      context,
                      addressListScreen,
                      arguments: "quick_widget",
                    ),
                    padding: const EdgeInsetsDirectional.only(
                      start: 5,
                      end: 5,
                    ),
                    context: context,
                  ),
                ),
                Expanded(
                  child: buttonWidget(
                    defaultImg(
                      image: "cart_icon",
                      iconColor: ColorsRes.mainTextColor,
                      height: 23,
                      width: 23,
                    ),
                    "cart",
                    onClickAction: () {
                      if (Constant.session.isUserLoggedIn()) {
                        Navigator.pushNamed(context, cartScreen);
                      } else {
                        // loginUserAccount(context, "cart");
                        Navigator.pushNamed(context, cartScreen);
                      }
                    },
                    padding: const EdgeInsetsDirectional.only(
                      start: 5,
                    ),
                    context: context,
                  ),
                ),
              ],
            ),
          )
        : Container();
  }
}
