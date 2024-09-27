import 'package:egrocer/helper/utils/generalImports.dart';

Widget ProductDetailImportantInformationWidget(
  BuildContext context,
  ProductData product,
) {
  String productType = product.indicator.toString();
  String cancelableStatus = product.cancelableStatus.toString();
  String returnStatus = product.returnStatus.toString();
  return Container(
    padding: EdgeInsetsDirectional.all(10),
    margin: EdgeInsetsDirectional.only(top: 10, start: 10, end: 10),
    decoration: DesignConfig.boxDecoration(Theme.of(context).cardColor, 5),
    child: Column(
      children: [
        if (productType != "null" && productType != "0")
          Row(
            children: [
              defaultImg(
                height: 22,
                width: 22,
                image: productType == "1"
                    ? "product_veg_indicator"
                    : "product_non_veg_indicator",
              ),
              getSizedBox(width: 10),
              CustomTextLabel(
                jsonKey: productType == "1" ? "vegetarian" : "non_vegetarian",
                style: TextStyle(
                  color: ColorsRes.subTitleMainTextColor,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        getSizedBox(height: Constant.size10),
        Row(
          children: [
            defaultImg(
              height: 22,
              width: 22,
              image: cancelableStatus == "1"
                  ? "product_cancellable"
                  : "product_non_cancellable",
            ),
            getSizedBox(width: 10),
            Expanded(
              child: CustomTextLabel(
                text: (cancelableStatus == "1")
                    ? "${getTranslatedValue(context, "product_is_cancellable_till")} ${Constant.getOrderActiveStatusLabelFromCode(product.tillStatus, context)}"
                    : getTranslatedValue(context, "non_cancellable"),
                style: TextStyle(
                  color: ColorsRes.subTitleMainTextColor,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
        getSizedBox(height: Constant.size10),
        Row(
          children: [
            defaultImg(
              height: 22,
              width: 22,
              image: returnStatus == "1"
                  ? "product_returnable"
                  : "product_non_returnable",
            ),
            getSizedBox(width: 10),
            Expanded(
              child: CustomTextLabel(
                text: (returnStatus == "1")
                    ? "${getTranslatedValue(context, "product_is_returnable_till")} ${product.returnDays} ${getTranslatedValue(context, "days")}"
                    : getTranslatedValue(context, "non_returnable"),
                style: TextStyle(
                  color: ColorsRes.subTitleMainTextColor,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
