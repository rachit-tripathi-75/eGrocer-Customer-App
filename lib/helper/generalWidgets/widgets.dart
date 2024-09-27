import 'package:egrocer/helper/utils/generalImports.dart';

Widget gradientBtnWidget(BuildContext context, double borderRadius,
    {required Function callback,
    String title = "",
    Widget? otherWidgets,
    double? height,
    double? width,
    Color? color1,
    Color? color2}) {
  return GestureDetector(
    onTap: () {
      callback();
    },
    child: Container(
      height: height ?? 45,
      width: width,
      alignment: Alignment.center,
      decoration: DesignConfig.boxGradient(
        borderRadius,
        color1: color1,
        color2: color2,
      ),
      child: otherWidgets ??= CustomTextLabel(
        text: title,
        softWrap: true,
        style: Theme.of(context).textTheme.titleMedium!.merge(TextStyle(
            color: ColorsRes.mainIconColor,
            letterSpacing: 0.5,
            fontWeight: FontWeight.w500)),
      ),
    ),
  );
}

Widget defaultImg({
  double? height,
  double? width,
  required String image,
  Color? iconColor,
  BoxFit? boxFit,
  EdgeInsetsDirectional? padding,
  bool? requiredRTL = true,
}) {
  return Padding(
    padding: padding ?? const EdgeInsets.all(0),
    child: iconColor != null
        ? SvgPicture.asset(
            Constant.getAssetsPath(1, image),
            width: width,
            height: height,
            colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
            fit: boxFit ?? BoxFit.contain,
            matchTextDirection: requiredRTL ?? true,
          )
        : SvgPicture.asset(
            Constant.getAssetsPath(1, image),
            width: width,
            height: height,
            fit: boxFit ?? BoxFit.contain,
            matchTextDirection: requiredRTL ?? true,
          ),
  );
}

getDarkLightIcon({
  double? height,
  double? width,
  required String image,
  Color? iconColor,
  BoxFit? boxFit,
  EdgeInsetsDirectional? padding,
  bool? isActive,
}) {
  String dark =
      (Constant.session.getBoolData(SessionManager.isDarkTheme)) == true
          ? "_dark"
          : "";
  String active = (isActive ??= false) == true ? "_active" : "";

  return defaultImg(
      height: height,
      width: width,
      image: "$image$active${dark}_icon",
      iconColor: iconColor,
      boxFit: boxFit,
      padding: padding);
}

List getHomeBottomNavigationBarIcons({required bool isActive}) {
  return [
    getDarkLightIcon(
        image: "home",
        isActive: isActive,
        padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0)),
    getDarkLightIcon(
        image: "category",
        isActive: isActive,
        padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0)),
    getDarkLightIcon(
        image: "wishlist",
        isActive: isActive,
        padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0)),
    getDarkLightIcon(
        image: "profile",
        isActive: isActive,
        padding: EdgeInsetsDirectional.zero),
  ];
}

Widget setNetworkImg({
  double? height,
  double? width,
  String image = "placeholder",
  Color? iconColor,
  BoxFit? boxFit,
}) {
  if (image.trim().isNotEmpty && !image.contains("http")) {
    image = "${Constant.hostUrl}storage/$image";
  }

  return image.trim().isEmpty
      ? defaultImg(
          image: "placeholder",
          height: height,
          width: width,
          boxFit: boxFit,
        )
      : CachedNetworkImage(
          imageUrl: image,
          height: height,
          width: width,
          fit: boxFit,
          placeholder: (context, url) => defaultImg(
            image: "placeholder",
            height: height,
            width: width,
            boxFit: boxFit,
            padding: EdgeInsetsDirectional.all(20),
          ),
          errorWidget: (context, url, error) => defaultImg(
            image: "placeholder",
            height: height,
            width: width,
            boxFit: boxFit,
            padding: EdgeInsetsDirectional.all(20),
          ),
        );
}

Widget getSizedBox({double? height, double? width, Widget? child}) {
  return SizedBox(
    height: height ?? 0,
    width: width ?? 0,
    child: child,
  );
}

Widget getDivider(
    {Color? color,
    double? endIndent,
    double? height,
    double? indent,
    double? thickness}) {
  return Divider(
    color: color ?? ColorsRes.subTitleMainTextColor,
    endIndent: endIndent ?? 0,
    indent: indent ?? 0,
    height: height,
    thickness: thickness,
  );
}

getProductListingCartIconButton(
    {required BuildContext context, required int count}) {
  return gradientBtnWidget(
    context,
    5,
    callback: () {},
    otherWidgets: defaultImg(
      image: "cart_icon",
      width: 20,
      height: 20,
      padding: const EdgeInsetsDirectional.all(5),
      iconColor: ColorsRes.mainIconColor,
    ),
  );
}

getLoadingIndicator() {
  return CircularProgressIndicator(
    backgroundColor: Colors.transparent,
    color: ColorsRes.appColor,
    strokeWidth: 2,
  );
}

void loginUserAccount(BuildContext buildContext, String from) {
  showDialog<String>(
    context: buildContext,
    builder: (BuildContext context) => AlertDialog(
      content: CustomTextLabel(
        jsonKey: from == "cart"
            ? "required_login_message_for_cart"
            : "required_login_message_for_wish_list",
        softWrap: true,
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: CustomTextLabel(
            jsonKey: "cancel",
            softWrap: true,
          ),
        ),
        TextButton(
          onPressed: () async {
            Navigator.pop(context);
            Navigator.pushNamed(context, loginScreen, arguments: "add_to_cart");
          },
          child: CustomTextLabel(
            jsonKey: "ok",
            softWrap: true,
          ),
        ),
      ],
      backgroundColor: Theme.of(buildContext).cardColor,
      surfaceTintColor: Colors.transparent,
    ),
  );
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}

class CustomShimmer extends StatelessWidget {
  final double? height;
  final double? width;
  final double? borderRadius;
  final EdgeInsetsGeometry? margin;

  const CustomShimmer(
      {Key? key, this.height, this.width, this.borderRadius, this.margin})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      enabled: true,
      baseColor: ColorsRes.shimmerBaseColor,
      highlightColor: ColorsRes.shimmerHighlightColor,
      child: Container(
        width: width,
        margin: margin ?? EdgeInsets.zero,
        height: height ?? 10,
        decoration: BoxDecoration(
            color: ColorsRes.shimmerContentColor,
            borderRadius: BorderRadius.circular(borderRadius ?? 10)),
      ),
    );
  }
}

// CategorySimmer
Widget getCategoryShimmer(
    {required BuildContext context, int? count, EdgeInsets? padding}) {
  return GridView.builder(
    itemCount: count,
    padding: padding ??
        EdgeInsets.symmetric(
            horizontal: Constant.size10, vertical: Constant.size10),
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemBuilder: (BuildContext context, int index) {
      return CustomShimmer(
        width: context.width,
        height: context.height,
        borderRadius: 8,
      );
    },
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        childAspectRatio: 0.8,
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10),
  );
}

// CategorySimmer
Widget getRatingPhotosShimmer(
    {required BuildContext context, int? count, EdgeInsets? padding}) {
  return GridView.builder(
    itemCount: count,
    padding: padding ??
        EdgeInsets.symmetric(
            horizontal: Constant.size10, vertical: Constant.size10),
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemBuilder: (BuildContext context, int index) {
      return CustomShimmer(
        width: context.width,
        height: context.height,
        borderRadius: 8,
      );
    },
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        childAspectRatio: 0.8,
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10),
  );
}

// BrandSimmer
Widget getBrandShimmer(
    {required BuildContext context, int? count, EdgeInsets? padding}) {
  return GridView.builder(
    itemCount: count,
    padding: padding ??
        EdgeInsets.symmetric(
            horizontal: Constant.size10, vertical: Constant.size10),
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemBuilder: (BuildContext context, int index) {
      return CustomShimmer(
        width: context.width,
        height: context.height,
        borderRadius: 8,
      );
    },
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        childAspectRatio: 0.8,
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10),
  );
}

// BrandSimmer
Widget getSellerShimmer(
    {required BuildContext context, int? count, EdgeInsets? padding}) {
  return GridView.builder(
    itemCount: count,
    padding: padding ??
        EdgeInsets.symmetric(
            horizontal: Constant.size10, vertical: Constant.size10),
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemBuilder: (BuildContext context, int index) {
      return CustomShimmer(
        width: context.width,
        height: context.height,
        borderRadius: 8,
      );
    },
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        childAspectRatio: 0.8,
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10),
  );
}

AppBar getAppBar(
    {required BuildContext context,
    bool? centerTitle,
    required Widget title,
    List<Widget>? actions,
    Color? backgroundColor,
    bool? showBackButton,
    GestureTapCallback? onTap}) {
  return AppBar(
    leading: showBackButton ?? true
        ? GestureDetector(
            onTap: onTap ??
                () {
                  Navigator.pop(context);
                },
            child: Container(
              color: Colors.transparent,
              child: Padding(
                padding: EdgeInsets.all(18),
                child: SizedBox(
                  child: defaultImg(
                    boxFit: BoxFit.contain,
                    image: "ic_arrow_back",
                    iconColor: ColorsRes.mainTextColor,
                  ),
                  height: 10,
                  width: 10,
                ),
              ),
            ),
          )
        : null,
    automaticallyImplyLeading: true,
    elevation: 0,
    titleSpacing: 0,
    title: title,
    centerTitle: centerTitle ?? false,
    surfaceTintColor: Colors.transparent,
    backgroundColor: backgroundColor ?? Theme.of(context).cardColor,
    actions: actions ?? [],
  );
}

class ScrollGlowBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const ClampingScrollPhysics(parent: AlwaysScrollableScrollPhysics());
  }
}

Widget getProductListShimmer(
    {required BuildContext context, required bool isGrid}) {
  return isGrid
      ? GridView.builder(
          itemCount: 6,
          padding: EdgeInsets.symmetric(
              horizontal: Constant.size10, vertical: Constant.size10),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            return const CustomShimmer(
              width: double.maxFinite,
              height: double.maxFinite,
            );
          },
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: 0.7,
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10),
        )
      : Column(
          children: List.generate(20, (index) {
            return const Padding(
              padding: EdgeInsetsDirectional.fromSTEB(10, 0, 10, 10),
              child: CustomShimmer(
                width: double.maxFinite,
                height: 125,
              ),
            );
          }),
        );
}

Widget getProductItemShimmer(
    {required BuildContext context, required bool isGrid}) {
  return isGrid
      ? GridView.builder(
          itemCount: 2,
          padding: EdgeInsets.symmetric(
              horizontal: Constant.size10, vertical: Constant.size10),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            return const CustomShimmer(
              width: double.maxFinite,
              height: double.maxFinite,
            );
          },
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: 0.7,
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10),
        )
      : const Padding(
          padding: EdgeInsetsDirectional.fromSTEB(10, 0, 10, 10),
          child: CustomShimmer(
            width: double.maxFinite,
            height: 125,
          ),
        );
}

//Search widgets for the multiple screen
Widget getSearchWidget({
  required BuildContext context,
}) {
  return GestureDetector(
    onTap: () {
      Navigator.pushNamed(context, productSearchScreen);
    },
    child: Container(
      color: Theme.of(context).cardColor,
      padding: const EdgeInsetsDirectional.only(
        start: 10,
        end: 10,
        bottom: 10,
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: DesignConfig.boxDecoration(
                  Theme.of(context).scaffoldBackgroundColor, 10),
              child: ListTile(
                title: TextField(
                  enabled: false,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    hintText:
                        getTranslatedValue(context, "product_search_hint"),
                    iconColor: ColorsRes.subTitleMainTextColor,
                  ),
                ),
                horizontalTitleGap: 0,
                contentPadding: EdgeInsets.zero,
                leading: IconButton(
                  padding: EdgeInsets.zero,
                  icon: Icon(
                    Icons.search,
                    color: ColorsRes.subTitleMainTextColor,
                  ),
                  onPressed: null,
                ),
              ),
            ),
          ),
          SizedBox(width: Constant.size10),
          Container(
            decoration: DesignConfig.boxGradient(10),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: defaultImg(
              image: "voice_search_icon",
              iconColor: ColorsRes.mainIconColor,
            ),
          ),
        ],
      ),
    ),
  );
}

Widget setRefreshIndicator(
    {required RefreshCallback refreshCallback, required Widget child}) {
  return RefreshIndicator(
    onRefresh: refreshCallback,
    child: child,
    backgroundColor: Colors.transparent,
    color: ColorsRes.appColor,
    triggerMode: RefreshIndicatorTriggerMode.anywhere,
  );
}

Widget setCartCounter({required BuildContext context, String? from}) {
  return GestureDetector(
    onTap: () {
      if (from == null) {
        if (Constant.session.isUserLoggedIn()) {
          Navigator.pushNamed(context, cartScreen);
        } else {
          // if (Constant.guestCartOptionIsOn == "1") {
          Navigator.pushNamed(context, cartScreen);
          // } else {
          //   loginUserAccount(context, "cart");
          // }
        }
      } else {
        Navigator.pop(context);
      }
    },
    child: Container(
      margin: const EdgeInsets.all(10),
      child: Stack(
        children: [
          defaultImg(
              height: 24,
              width: 24,
              iconColor: ColorsRes.appColor,
              image: "cart_icon"),
          Consumer<CartListProvider>(
              builder: (context, cartListProvider, child) {
            return context.read<CartListProvider>().cartList.isNotEmpty
                ? PositionedDirectional(
                    end: 0,
                    top: 0,
                    child: SizedBox(
                      height: 12,
                      width: 12,
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: ColorsRes.appColor,
                        child: CustomTextLabel(
                          text: context
                              .read<CartListProvider>()
                              .cartList
                              .length
                              .toString(),
                          softWrap: true,
                          style: TextStyle(
                            color: ColorsRes.mainIconColor,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                  )
                : const SizedBox.shrink();
          }),
        ],
      ),
    ),
  );
}

Widget setNotificationIcon({required BuildContext context}) {
  return IconButton(
    onPressed: () {
      Navigator.pushNamed(context, notificationListScreen);
    },
    icon: defaultImg(
      image: "notification_icon",
      iconColor: ColorsRes.appColor,
    ),
  );
}

Widget getOutOfStockWidget(
    {required double height,
    required double width,
    double? textSize,
    required BuildContext context}) {
  return Container(
    alignment: AlignmentDirectional.center,
    decoration: BoxDecoration(
      borderRadius: Constant.borderRadius10,
      color: Colors.black.withOpacity(0.3),
    ),
    child: FittedBox(
      fit: BoxFit.none,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: Constant.borderRadius5,
          color: Colors.black,
        ),
        child: CustomTextLabel(
          jsonKey: "out_of_stock",
          softWrap: true,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              fontSize: textSize ?? 18,
              fontWeight: FontWeight.w400,
              color: ColorsRes.appColorRed),
        ),
      ),
    ),
  );
}

Widget getOverallRatingSummary(
    {required BuildContext context,
    required ProductRatingData productRatingData,
    required String totalRatings}) {
  return Row(
    children: [
      Column(
        children: [
          CircleAvatar(
            backgroundColor: ColorsRes.appColor,
            maxRadius: 45,
            minRadius: 20,
            child: CustomTextLabel(
              text: "${productRatingData.averageRating.toString().toDouble}",
              style: TextStyle(
                color: ColorsRes.appColorWhite,
                fontWeight: FontWeight.bold,
                fontSize: 35,
              ),
            ),
          ),
          getSizedBox(height: 10),
          CustomTextLabel(
            text:
                "${getTranslatedValue(context, "rating")}\n${totalRatings.toString().toInt}",
            style: TextStyle(
              color: ColorsRes.subTitleMainTextColor,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      Container(
        margin: EdgeInsetsDirectional.only(start: 20, end: 20),
        color: ColorsRes.subTitleMainTextColor,
        height: 165,
        width: 0.7,
      ),
      Expanded(
        child: Column(
          children: [
            PercentageWiseRatingBar(
              context: context,
              index: 4,
              totalRatings: productRatingData.fiveStarRating.toString().toInt,
              ratingPercentage: calculatePercentage(
                totalRatings: totalRatings.toString().toInt,
                starsWiseRatings:
                    productRatingData.fiveStarRating.toString().toInt,
              ),
            ),
            PercentageWiseRatingBar(
              context: context,
              index: 3,
              totalRatings: productRatingData.fourStarRating.toString().toInt,
              ratingPercentage: calculatePercentage(
                totalRatings: totalRatings.toString().toInt,
                starsWiseRatings:
                    productRatingData.fourStarRating.toString().toInt,
              ),
            ),
            PercentageWiseRatingBar(
              context: context,
              index: 2,
              totalRatings: productRatingData.threeStarRating.toString().toInt,
              ratingPercentage: calculatePercentage(
                totalRatings: totalRatings.toString().toInt,
                starsWiseRatings:
                    productRatingData.threeStarRating.toString().toInt,
              ),
            ),
            PercentageWiseRatingBar(
              context: context,
              index: 1,
              totalRatings: productRatingData.twoStarRating.toString().toInt,
              ratingPercentage: calculatePercentage(
                totalRatings: totalRatings.toString().toInt,
                starsWiseRatings:
                    productRatingData.twoStarRating.toString().toInt,
              ),
            ),
            PercentageWiseRatingBar(
              context: context,
              index: 0,
              totalRatings: productRatingData.oneStarRating.toString().toInt,
              ratingPercentage: calculatePercentage(
                totalRatings: totalRatings.toString().toInt,
                starsWiseRatings:
                    productRatingData.oneStarRating.toString().toInt,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

Widget PercentageWiseRatingBar({
  required double ratingPercentage,
  required int totalRatings,
  required int index,
  required BuildContext context,
}) {
  return Column(
    children: [
      Row(
        children: [
          CustomTextLabel(
            text: "${index + 1}",
          ),
          getSizedBox(width: 5),
          Icon(
            Icons.star_rounded,
            color: Colors.amber,
          ),
          getSizedBox(width: 5),
          Expanded(
            child: Container(
              height: 5,
              width: context.width * 0.4,
              decoration: BoxDecoration(
                color: ColorsRes.mainTextColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(7),
              ),
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                child: Container(
                  height: 5,
                  width: (context.width * 0.34) * ratingPercentage,
                  decoration: BoxDecoration(
                    color: ColorsRes.appColor,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ),
          ),
          getSizedBox(width: 10),
          CustomTextLabel(
            text: "$totalRatings",
            style: TextStyle(
              color: ColorsRes.subTitleMainTextColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
      getSizedBox(height: 10),
    ],
  );
}

double calculatePercentage(
    {required int totalRatings, required int starsWiseRatings}) {
  double percentage = 0.0;

  percentage = (starsWiseRatings * 100) / totalRatings;
  return percentage / 100;
}

Widget getRatingReviewItem({required ProductRatingList rating}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsetsDirectional.only(
              start: 5,
            ),
            decoration: BoxDecoration(
              color: ColorsRes.appColor,
              borderRadius: BorderRadiusDirectional.all(
                Radius.circular(5),
              ),
            ),
            child: Row(
              children: [
                CustomTextLabel(
                  text: rating.rate,
                  style: TextStyle(
                    color: ColorsRes.appColorWhite,
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                  ),
                ),
                Icon(
                  Icons.star_rate_rounded,
                  color: Colors.amber,
                  size: 20,
                )
              ],
            ),
          ),
          getSizedBox(width: 7),
          CustomTextLabel(
            text: rating.user?.name.toString() ?? "",
            style: TextStyle(
                color: ColorsRes.mainTextColor,
                fontWeight: FontWeight.w800,
                fontSize: 15),
            softWrap: true,
          )
        ],
      ),
      getSizedBox(height: 10),
      if (rating.review.toString().length > 100)
        ExpandableText(
          text: rating.review.toString(),
          max: 0.2,
          color: ColorsRes.subTitleMainTextColor,
        ),
      if (rating.review.toString().length <= 100)
        CustomTextLabel(
          text: rating.review.toString(),
          style: TextStyle(
            color: ColorsRes.subTitleMainTextColor,
          ),
        ),
      getSizedBox(height: 10),
      if (rating.images != null && rating.images!.length > 0)
        LayoutBuilder(
          builder: (context, constraints) => Wrap(
            runSpacing: 10,
            spacing: constraints.maxWidth * 0.017,
            children: List.generate(
              rating.images!.length,
              (index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                        context, fullScreenProductImageScreen, arguments: [
                      index,
                      rating.images?.map((e) => e.imageUrl.toString()).toList()
                    ]);
                  },
                  child: ClipRRect(
                    borderRadius: Constant.borderRadius2,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: setNetworkImg(
                      image: rating.images?[index].imageUrl ?? "",
                      width: 50,
                      height: 50,
                      boxFit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      getSizedBox(height: 10),
      CustomTextLabel(
        text: rating.updatedAt.toString().formatDate(),
        style: TextStyle(
          color: ColorsRes.subTitleMainTextColor,
        ),
        maxLines: 2,
        softWrap: true,
        overflow: TextOverflow.ellipsis,
      ),
    ],
  );
}
