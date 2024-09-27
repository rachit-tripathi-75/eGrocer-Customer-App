import 'package:egrocer/helper/utils/generalImports.dart';

class HomeScreenProductListItem extends StatefulWidget {
  final ProductListItem product;
  final int position;

  const HomeScreenProductListItem(
      {Key? key, required this.product, required this.position})
      : super(key: key);

  @override
  State<HomeScreenProductListItem> createState() => _State();
}

class _State extends State<HomeScreenProductListItem> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ProductListItem product = widget.product;
    List<Variants>? variants = product.variants;
    return variants!.isNotEmpty
        ? Consumer<ProductListProvider>(
            builder: (context, productListProvider, _) {
              return GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, productDetailScreen, arguments: [
                    product.id.toString(),
                    product.name,
                    product
                  ]);
                },
                child: ChangeNotifierProvider<SelectedVariantItemProvider>(
                  create: (context) => SelectedVariantItemProvider(),
                  child: Container(
                    height: context.width * 0.75,
                    width: context.width * 0.45,
                    margin:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    decoration: DesignConfig.boxDecoration(
                        Theme.of(context).cardColor, 8),
                    child: Stack(
                      children: [
                        Column(
                          children: [
                            Expanded(
                              child: Consumer<SelectedVariantItemProvider>(
                                builder: (context, selectedVariantItemProvider,
                                    child) {
                                  return Stack(
                                    children: [
                                      Container(
                                        child: ClipRRect(
                                          borderRadius: Constant.borderRadius10,
                                          clipBehavior:
                                              Clip.antiAliasWithSaveLayer,
                                          child: setNetworkImg(
                                            boxFit: BoxFit.cover,
                                            image: product.imageUrl ?? "",
                                            height: context.width,
                                            width: context.width,
                                          ),
                                        ),
                                        decoration: BoxDecoration(
                                          color: ColorsRes.appColorWhite,
                                          borderRadius:
                                              BorderRadiusDirectional.all(
                                            Radius.circular(
                                              10,
                                            ),
                                          ),
                                        ),
                                      ),
                                      if (product
                                              .variants?[
                                                  selectedVariantItemProvider
                                                      .getSelectedIndex()]
                                              .status ==
                                          "0")
                                        PositionedDirectional(
                                          top: 0,
                                          end: 0,
                                          start: 0,
                                          bottom: 0,
                                          child: getOutOfStockWidget(
                                            height: context.width,
                                            width: context.width,
                                            context: context,
                                          ),
                                        ),
                                      PositionedDirectional(
                                        bottom: 5,
                                        end: 5,
                                        child: Column(
                                          children: [
                                            if (product.indicator.toString() ==
                                                "1")
                                              defaultImg(
                                                height: 24,
                                                width: 24,
                                                image: "product_veg_indicator",
                                                boxFit: BoxFit.cover,
                                              ),
                                            if (product.indicator.toString() ==
                                                "2")
                                              defaultImg(
                                                  height: 24,
                                                  width: 24,
                                                  image:
                                                      "product_non_veg_indicator",
                                                  boxFit: BoxFit.cover),
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
                                          totalRatings: widget
                                              .product.ratingCount
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
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: EdgeInsetsDirectional.only(
                                      start: 5, bottom: 10, top: 10, end: 5),
                                  child: CustomTextLabel(
                                    text: product.name ?? "",
                                    softWrap: true,
                                    maxLines: 1,
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: ColorsRes.mainTextColor),
                                  ),
                                ),
                                ProductVariantDropDownMenuGrid(
                                  variants: variants,
                                  from: "",
                                  product: product,
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
                  ),
                ),
              );
            },
          )
        : const SizedBox.shrink();
  }
}
