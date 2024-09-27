import 'package:egrocer/helper/utils/generalImports.dart';

class ProductGridItemContainer extends StatefulWidget {
  final ProductListItem product;

  const ProductGridItemContainer({Key? key, required this.product})
      : super(key: key);

  @override
  State<ProductGridItemContainer> createState() => _State();
}

class _State extends State<ProductGridItemContainer> {
  late BuildContext context1;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    context1 = context;
    ProductListItem product = widget.product;
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          productDetailScreen,
          arguments: [
            product.id.toString(),
            product.name,
            product,
          ],
        );
      },
      child: ChangeNotifierProvider<SelectedVariantItemProvider>(
        create: (context) => SelectedVariantItemProvider(),
        child: product.variants!.length > 0
            ? Container(
                decoration:
                    DesignConfig.boxDecoration(Theme.of(context).cardColor, 8),
                child: Stack(
                  children: [
                    Column(
                      children: [
                        Expanded(
                          child: Consumer<SelectedVariantItemProvider>(
                            builder:
                                (context, selectedVariantItemProvider, child) {
                              return Stack(
                                children: [
                                  Container(
                                    child: ClipRRect(
                                      borderRadius: Constant.borderRadius10,
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      child: setNetworkImg(
                                        boxFit: BoxFit.cover,
                                        image: product.imageUrl.toString(),
                                        height: double.maxFinite,
                                        width: double.maxFinite,
                                      ),
                                    ),
                                    decoration: BoxDecoration(
                                      color: ColorsRes.appColorWhite,
                                      borderRadius: Constant.borderRadius10,
                                    ),
                                  ),
                                  if (product
                                          .variants?[selectedVariantItemProvider
                                              .getSelectedIndex()]
                                          .status
                                          .toString() ==
                                      "0")
                                    PositionedDirectional(
                                      top: 0,
                                      end: 0,
                                      start: 0,
                                      bottom: 0,
                                      child: getOutOfStockWidget(
                                        height: double.maxFinite,
                                        width: double.maxFinite,
                                        context: context,
                                      ),
                                    ),
                                  PositionedDirectional(
                                    bottom: 5,
                                    end: 5,
                                    child: Column(
                                      children: [
                                        if (product.indicator.toString() == "1")
                                          defaultImg(
                                            height: 24,
                                            width: 24,
                                            image: "product_veg_indicator",
                                          ),
                                        if (product.indicator.toString() == "2")
                                          defaultImg(
                                            height: 24,
                                            width: 24,
                                            image: "product_non_veg_indicator",
                                          ),
                                      ],
                                    ),
                                  ),
                                  PositionedDirectional(
                                    bottom: 5,
                                    start: 5,
                                    child: ProductListRatingBuilderWidget(
                                      averageRating: widget
                                          .product.averageRating
                                          .toString()
                                          .toDouble,
                                      totalRatings: widget.product.ratingCount
                                          .toString()
                                          .toInt,
                                      size: 13,
                                      spacing: 2,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                        getSizedBox(
                          height: Constant.size10,
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: EdgeInsetsDirectional.only(start: 5),
                              child: CustomTextLabel(
                                text: product.name.toString(),
                                maxLines: 1,
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: ColorsRes.mainTextColor,
                                ),
                              ),
                            ),
                            getSizedBox(
                              height: Constant.size10,
                            ),
                            if (product.variants!.isNotEmpty)
                              ProductVariantDropDownMenuGrid(
                                from: "",
                                product: product,
                                variants: product.variants,
                                isGrid: true,
                              ),
                          ],
                        )
                      ],
                    ),
                    PositionedDirectional(
                      end: 5,
                      top: 5,
                      child: ProductWishListIcon(
                        product: product,
                      ),
                    ),
                  ],
                ),
              )
            : SizedBox.shrink(),
      ),
    );
  }
}
