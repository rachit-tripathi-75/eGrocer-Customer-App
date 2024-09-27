import 'package:egrocer/helper/generalWidgets/ratingImagesWidget.dart';
import 'package:egrocer/helper/utils/generalImports.dart';
import 'package:egrocer/screens/productDetailScreen/widget/otherImagesViewWidget.dart';
import 'package:egrocer/screens/productDetailScreen/widget/productDetailImportantInformationWidget.dart';
import 'package:egrocer/screens/productDetailScreen/widget/productDetailSimilarProductsWidget.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class ProductDetailWidget extends StatefulWidget {
  final BuildContext context;
  final ProductData product;

  ProductDetailWidget(
      {super.key, required this.context, required this.product});

  @override
  State<ProductDetailWidget> createState() => _ProductDetailWidgetState();
}

class _ProductDetailWidgetState extends State<ProductDetailWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            return Row(
              children: [
                OtherImagesViewWidget(context, Axis.vertical, constraints),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      fullScreenProductImageScreen,
                      arguments: [
                        context.read<ProductDetailProvider>().currentImage,
                        context.read<ProductDetailProvider>().images,
                      ],
                    );
                  },
                  child: Consumer<SelectedVariantItemProvider>(
                    builder: (context, selectedVariantItemProvider, child) {
                      return Stack(
                        children: [
                          Padding(
                            padding: EdgeInsetsDirectional.only(
                                start: 10, top: 10, end: 10),
                            child: ClipRRect(
                              borderRadius: Constant.borderRadius10,
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              child: setNetworkImg(
                                boxFit: BoxFit.cover,
                                image: context
                                        .read<ProductDetailProvider>()
                                        .images[
                                    context
                                        .read<ProductDetailProvider>()
                                        .currentImage],
                                height: (context
                                            .read<ProductDetailProvider>()
                                            .productData
                                            .images
                                            .length >
                                        1)
                                    ? ((constraints.maxWidth * 0.8) - 10)
                                    : constraints.maxWidth - 20,
                                width: (context
                                            .read<ProductDetailProvider>()
                                            .productData
                                            .images
                                            .length >
                                        1)
                                    ? ((constraints.maxWidth * 0.8) - 10)
                                    : constraints.maxWidth - 20,
                              ),
                            ),
                          ),
                          if (widget
                                  .product
                                  .variants[selectedVariantItemProvider
                                      .getSelectedIndex()]
                                  .status ==
                              "0")
                            Container(
                              height: (context
                                          .read<ProductDetailProvider>()
                                          .productData
                                          .images
                                          .length >
                                      1)
                                  ? ((constraints.maxWidth * 0.8) - 10)
                                  : constraints.maxWidth - 20,
                              width: (context
                                          .read<ProductDetailProvider>()
                                          .productData
                                          .images
                                          .length >
                                      1)
                                  ? ((constraints.maxWidth * 0.8) - 10)
                                  : constraints.maxWidth - 20,
                              margin: EdgeInsetsDirectional.all(10),
                              child: getOutOfStockWidget(
                                height: (context
                                            .read<ProductDetailProvider>()
                                            .productData
                                            .images
                                            .length >
                                        1)
                                    ? ((constraints.maxWidth * 0.8) - 10)
                                    : constraints.maxWidth - 20,
                                width: (context
                                            .read<ProductDetailProvider>()
                                            .productData
                                            .images
                                            .length >
                                        1)
                                    ? ((constraints.maxWidth * 0.8) - 10)
                                    : constraints.maxWidth - 20,
                                context: context,
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
        Container(
          padding: EdgeInsetsDirectional.only(
              top: 10, start: 10, end: 10, bottom: 10),
          margin: EdgeInsetsDirectional.only(
            top: 10,
            start: 10,
            end: 10,
          ),
          decoration:
              DesignConfig.boxDecoration(Theme.of(context).cardColor, 5),
          child: Consumer<SelectedVariantItemProvider>(
            builder: (context, selectedVariantItemProvider, _) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextLabel(
                          text: widget.product.name,
                          softWrap: true,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: ColorsRes.mainTextColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  getSizedBox(height: Constant.size10),
                  Padding(
                    padding: EdgeInsetsDirectional.only(end: 5),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CustomTextLabel(
                          text: double.parse(widget
                                      .product
                                      .variants[selectedVariantItemProvider
                                          .getSelectedIndex()]
                                      .discountedPrice) !=
                                  0
                              ? widget
                                  .product
                                  .variants[selectedVariantItemProvider
                                      .getSelectedIndex()]
                                  .discountedPrice
                                  .currency
                              : widget
                                  .product
                                  .variants[selectedVariantItemProvider
                                      .getSelectedIndex()]
                                  .price
                                  .currency,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 17,
                              color: ColorsRes.appColor,
                              fontWeight: FontWeight.w500),
                        ),
                        getSizedBox(width: 5),
                        RichText(
                          maxLines: 2,
                          softWrap: true,
                          overflow: TextOverflow.clip,
                          text: TextSpan(children: [
                            TextSpan(
                              style: TextStyle(
                                  fontSize: 17,
                                  color: ColorsRes.grey,
                                  decoration: TextDecoration.lineThrough,
                                  decorationThickness: 2),
                              text: double.parse(widget.product.variants[0]
                                          .discountedPrice) !=
                                      0
                                  ? widget.product.variants[0].price.currency
                                  : "",
                            ),
                          ]),
                        ),
                        Spacer(),
                        ProductListRatingBuilderWidget(
                          averageRating: context
                              .read<RatingListProvider>()
                              .productRatingData
                              .averageRating
                              .toString()
                              .toDouble,
                          totalRatings: context
                              .read<RatingListProvider>()
                              .totalData
                              .toString()
                              .toInt,
                          size: 15,
                          spacing: 2,
                          fontSize: 16,
                        )
                      ],
                    ),
                  ),
                  getSizedBox(height: Constant.size10),
                  ProductDetailAddToCartButtonWidget(
                    context: context,
                    product: widget.product,
                  ),
                ],
              );
            },
          ),
        ),
        ProductDetailImportantInformationWidget(context, widget.product),
        getSizedBox(height: Constant.size10),
        Container(
          margin: EdgeInsetsDirectional.only(
            start: 10,
            end: 10,
            bottom: 10,
          ),
          decoration: DesignConfig.boxDecoration(
            Theme.of(context).cardColor,
            10,
          ),
          child: ExpansionTile(
            collapsedShape:
                ShapeBorder.lerp(InputBorder.none, InputBorder.none, 0),
            shape: ShapeBorder.lerp(InputBorder.none, InputBorder.none, 0),
            initiallyExpanded: true,
            title: CustomTextLabel(
              jsonKey: "product_specifications",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ColorsRes.mainTextColor,
              ),
            ),
            iconColor: ColorsRes.mainTextColor,
            collapsedIconColor: ColorsRes.mainTextColor,
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.only(
                  start: 5,
                  end: 5,
                  bottom: 10,
                ),
                child: Container(
                  margin: EdgeInsetsDirectional.all(10),
                  child: Column(
                    children: [
                      getSpecificationItem(
                        titleJson: "fssai_lic_no",
                        value: widget.product.fssaiLicNo.toString(),
                        voidCallback: () {},
                        isClickable: false,
                      ),
                      getSpecificationItem(
                        titleJson: "category",
                        value: widget.product.categoryName.toString(),
                        voidCallback: () {
                          Navigator.pushNamed(
                            context,
                            productListScreen,
                            arguments: [
                              "category",
                              widget.product.categoryId.toString(),
                              widget.product.categoryName.toString(),
                            ],
                          );
                        },
                        isClickable: true,
                      ),
                      getSpecificationItem(
                        titleJson: "seller_name",
                        value: widget.product.sellerName,
                        voidCallback: () {
                          Navigator.pushNamed(
                            context,
                            productListScreen,
                            arguments: [
                              "seller",
                              widget.product.sellerId.toString(),
                              widget.product.sellerName.toString(),
                            ],
                          );
                        },
                        isClickable: true,
                      ),
                      getSpecificationItem(
                        titleJson: "brand",
                        value: widget.product.brandName,
                        voidCallback: () {
                          Navigator.pushNamed(
                            context,
                            productListScreen,
                            arguments: [
                              "brand",
                              widget.product.brandId.toString(),
                              widget.product.brandName.toString(),
                            ],
                          );
                        },
                        isClickable: true,
                      ),
                      getSpecificationItem(
                        titleJson: "made_in",
                        value: widget.product.madeIn,
                        voidCallback: () {
                          Navigator.pushNamed(
                            context,
                            productListScreen,
                            arguments: [
                              "country",
                              widget.product.madeInId.toString(),
                              widget.product.madeIn.toString(),
                            ],
                          );
                        },
                        isClickable: true,
                      ),
                      getSpecificationItem(
                        titleJson: "manufacturer",
                        value: widget.product.manufacturer,
                        voidCallback: () {},
                        isClickable: false,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsetsDirectional.only(
            start: 10,
            end: 10,
            bottom: 10,
          ),
          decoration: DesignConfig.boxDecoration(
            Theme.of(context).cardColor,
            10,
          ),
          child: ExpansionTile(
            collapsedShape:
                ShapeBorder.lerp(InputBorder.none, InputBorder.none, 0),
            shape: ShapeBorder.lerp(InputBorder.none, InputBorder.none, 0),
            initiallyExpanded: true,
            title: CustomTextLabel(
              jsonKey: "product_overview",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ColorsRes.mainTextColor,
              ),
            ),
            iconColor: ColorsRes.mainTextColor,
            collapsedIconColor: ColorsRes.mainTextColor,
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.only(
                  start: 5,
                  end: 5,
                ),
                child: Container(
                  margin: EdgeInsetsDirectional.all(10),
                  child: Column(
                    children: [
                      HtmlWidget(
                        widget.product.description,
                        enableCaching: true,
                        renderMode: RenderMode.column,
                        buildAsync: false,
                        textStyle: TextStyle(
                          color: ColorsRes.mainTextColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Consumer<RatingListProvider>(
          builder: (context, ratingListProvider, child) {
            if (ratingListProvider.ratings.length > 0) {
              return Container(
                margin: EdgeInsetsDirectional.only(
                  start: 10,
                  end: 10,
                  bottom: 10,
                ),
                decoration: DesignConfig.boxDecoration(
                  Theme.of(context).cardColor,
                  10,
                ),
                child: ExpansionTile(
                  collapsedShape:
                      ShapeBorder.lerp(InputBorder.none, InputBorder.none, 0),
                  shape:
                      ShapeBorder.lerp(InputBorder.none, InputBorder.none, 0),
                  initiallyExpanded: true,
                  title: CustomTextLabel(
                    jsonKey: "ratings_and_reviews",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: ColorsRes.mainTextColor,
                    ),
                  ),
                  iconColor: ColorsRes.mainTextColor,
                  collapsedIconColor: ColorsRes.mainTextColor,
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional.symmetric(horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          getOverallRatingSummary(
                              context: context,
                              productRatingData:
                                  ratingListProvider.productRatingData,
                              totalRatings:
                                  ratingListProvider.totalData.toString()),
                          if (ratingListProvider.totalImages > 0)
                            getSizedBox(height: 20),
                          if (ratingListProvider.totalImages > 0)
                            CustomTextLabel(
                              text:
                                  "${getTranslatedValue(context, "customer_photos")}(${ratingListProvider.totalImages})",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: ColorsRes.mainTextColor,
                              ),
                            ),
                          if (ratingListProvider.totalImages > 0)
                            getSizedBox(height: 20),
                          if (ratingListProvider.totalImages > 0)
                            RatingImagesWidget(
                              images: ratingListProvider.images,
                              from: "productDetails",
                              productId: widget.product.id,
                              totalImages: ratingListProvider.totalImages,
                            ),
                          getSizedBox(height: 20),
                          CustomTextLabel(
                            jsonKey: "customer_reviews",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: ColorsRes.mainTextColor,
                            ),
                          ),
                          getSizedBox(height: 20),
                          ListView(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.zero,
                            children: List.generate(
                              ratingListProvider.ratings.length,
                              (index) {
                                ProductRatingList rating =
                                    ratingListProvider.ratings[index];
                                return Column(
                                  children: [
                                    getRatingReviewItem(rating: rating),
                                    getSizedBox(height: 10),
                                    getDivider(
                                      color: ColorsRes.grey.withOpacity(0.5),
                                      height: 0,
                                      endIndent: 0,
                                      indent: 0,
                                    ),
                                    getSizedBox(height: 10),
                                  ],
                                );
                              },
                            ),
                          ),
                          if (ratingListProvider.totalData > 5)
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, ratingAndReviewScreen,
                                    arguments: widget.product.id.toString());
                              },
                              child: Padding(
                                padding: EdgeInsetsDirectional.only(
                                  top: 10,
                                  end: 10,
                                  bottom: 10,
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        border: BorderDirectional(
                                          bottom: BorderSide(
                                              color: ColorsRes.mainTextColor),
                                        ),
                                      ),
                                      child: CustomTextLabel(
                                        text:
                                            "${getTranslatedValue(context, "view_all_reviews_title")} ${ratingListProvider.totalData.toString().toInt} ${getTranslatedValue(context, "reviews")}",
                                        style: TextStyle(
                                          color: ColorsRes.mainTextColor,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    getSizedBox(width: 5),
                                    Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      color: ColorsRes.mainTextColor,
                                      size: 13,
                                    ),
                                  ],
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                ),
                              ),
                            ),
                          getSizedBox(height: 10),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return SizedBox.shrink();
            }
          },
        ),
        if (widget.product.relatedProducts != null &&
            widget.product.relatedProducts!.isNotEmpty)
          Container(
            margin: EdgeInsetsDirectional.only(
              start: 10,
              end: 10,
              bottom: 20,
            ),
            decoration: DesignConfig.boxDecoration(
              Theme.of(context).cardColor,
              10,
            ),
            child: ExpansionTile(
              collapsedShape:
                  ShapeBorder.lerp(InputBorder.none, InputBorder.none, 0),
              shape: ShapeBorder.lerp(
                OutlineInputBorder(
                  borderSide: BorderSide(
                    color: ColorsRes.subTitleMainTextColor,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                OutlineInputBorder(
                  borderSide: BorderSide(
                    color: ColorsRes.subTitleMainTextColor,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                10,
              ),
              initiallyExpanded: true,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              title: CustomTextLabel(
                jsonKey: "similar_products",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: ColorsRes.mainTextColor,
                ),
              ),
              iconColor: ColorsRes.mainTextColor,
              collapsedIconColor: ColorsRes.mainTextColor,
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.only(
                    start: 5,
                    end: 5,
                  ),
                  child: ChangeNotifierProvider<ProductListProvider>(
                    create: (context) => ProductListProvider(),
                    child: ProductDetailSimilarProductsWidget(
                        similarProducts: widget.product.relatedProducts ?? []),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

Widget getSpecificationItem({
  required String titleJson,
  required String value,
  required VoidCallback voidCallback,
  required bool isClickable,
}) {
  if (value != "null" && value != "") {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 2,
              child: CustomTextLabel(
                jsonKey: titleJson,
                softWrap: true,
                style: TextStyle(
                  color: ColorsRes.subTitleMainTextColor,
                ),
              ),
            ),
            getSizedBox(width: 10),
            CustomTextLabel(
              text: ":",
              softWrap: true,
              style: TextStyle(
                color: ColorsRes.subTitleMainTextColor,
              ),
            ),
            getSizedBox(width: 10),
            Expanded(
              flex: 7,
              child: GestureDetector(
                onTap: voidCallback,
                child: CustomTextLabel(
                  text: value,
                  softWrap: true,
                  style: TextStyle(
                    color: isClickable
                        ? Colors.blueAccent
                        : ColorsRes.mainTextColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
        getSizedBox(height: 10),
      ],
    );
  } else {
    return SizedBox.shrink();
  }
}
