import 'package:egrocer/helper/utils/generalImports.dart';

class ProductCartButton extends StatefulWidget {
  final int count;
  final String productId;
  final String sellerId;
  final String productVariantId;
  final bool isUnlimitedStock;
  final double maximumAllowedQuantity;
  final double availableStock;
  final String? from;
  final bool isGrid;

  const ProductCartButton({
    Key? key,
    required this.count,
    required this.productId,
    required this.productVariantId,
    required this.isUnlimitedStock,
    required this.maximumAllowedQuantity,
    required this.availableStock,
    required this.isGrid,
    this.from,
    required this.sellerId,
  }) : super(key: key);

  @override
  State<ProductCartButton> createState() => _ProductCartButtonState();
}

class _ProductCartButtonState
    extends State<ProductCartButton> /*with TickerProviderStateMixin*/ {
  late AnimationController animationController;
  late Animation animation;
  int currentState = 0;

  @override
  Widget build(BuildContext context) {
    return Consumer<CartListProvider>(
      builder: (context, cartListProvider, child) {
        return (int.parse(cartListProvider.getItemCartItemQuantity(
                        widget.productId, widget.productVariantId)) ==
                    0 &&
                widget.count != -1)
            ? GestureDetector(
                onTap: () async {
                  if (Constant.session.isUserLoggedIn()) {
                    cartListProvider.currentSelectedProduct = widget.productId;
                    cartListProvider.currentSelectedVariant =
                        widget.productVariantId;

                    Map<String, String> params = {};
                    params[ApiAndParams.productId] = widget.productId;
                    params[ApiAndParams.productVariantId] =
                        widget.productVariantId;
                    params[ApiAndParams.qty] = (int.parse(
                                cartListProvider.getItemCartItemQuantity(
                                    widget.productId,
                                    widget.productVariantId)) +
                            1)
                        .toString();
                    await cartListProvider
                        .addRemoveCartItem(
                      context: context,
                      params: params,
                      isUnlimitedStock: widget.isUnlimitedStock,
                      maximumAllowedQuantity: widget.maximumAllowedQuantity,
                      availableStock: widget.availableStock,
                      actionFor: "add",
                      from: widget.from,
                      sellerId: widget.sellerId,
                    )
                        .then((value) {
                      if (value is String) {
                        showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            surfaceTintColor: Colors.transparent,
                            backgroundColor: Theme.of(context).cardColor,
                            content: CustomTextLabel(
                              jsonKey: "seller_miss_match_item_message",
                              softWrap: true,
                            ),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: CustomTextLabel(
                                  jsonKey: "cancel",
                                  softWrap: true,
                                  style: TextStyle(
                                      color: ColorsRes.subTitleMainTextColor),
                                ),
                              ),
                              TextButton(
                                onPressed: () async {
                                  context
                                      .read<CartListProvider>()
                                      .clearCart(context: context)
                                      .then((value) async {
                                    cartListProvider.currentSelectedProduct =
                                        widget.productId;
                                    cartListProvider.currentSelectedVariant =
                                        widget.productVariantId;

                                    Map<String, String> params = {};
                                    params[ApiAndParams.productId] =
                                        widget.productId;
                                    params[ApiAndParams.productVariantId] =
                                        widget.productVariantId;
                                    params[ApiAndParams
                                        .qty] = (int.parse(cartListProvider
                                                .getItemCartItemQuantity(
                                                    widget.productId,
                                                    widget.productVariantId)) +
                                            1)
                                        .toString();
                                    await cartListProvider
                                        .addRemoveCartItem(
                                      context: context,
                                      params: params,
                                      isUnlimitedStock: widget.isUnlimitedStock,
                                      maximumAllowedQuantity:
                                          widget.maximumAllowedQuantity,
                                      availableStock: widget.availableStock,
                                      actionFor: "add",
                                      from: widget.from,
                                      sellerId: widget.sellerId,
                                    )
                                        .then((value) {
                                      Navigator.pop(context);
                                    });
                                  });
                                },
                                child: CustomTextLabel(
                                  jsonKey: "ok",
                                  softWrap: true,
                                  style: TextStyle(color: ColorsRes.appColor),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                    });
                  } else {
                    // if (Constant.guestCartOptionIsOn == "1") {
                    cartListProvider.currentSelectedProduct = widget.productId;
                    cartListProvider.currentSelectedVariant =
                        widget.productVariantId;

                    Map<String, String> params = {};
                    params[ApiAndParams.productId] = widget.productId;
                    params[ApiAndParams.productVariantId] =
                        widget.productVariantId;
                    params[ApiAndParams.qty] = (int.parse(
                                cartListProvider.getItemCartItemQuantity(
                                    widget.productId,
                                    widget.productVariantId)) +
                            1)
                        .toString();
                    await cartListProvider
                        .addRemoveGuestCartItem(
                      context: context,
                      params: params,
                      isUnlimitedStock: widget.isUnlimitedStock,
                      maximumAllowedQuantity: widget.maximumAllowedQuantity,
                      availableStock: widget.availableStock,
                      actionFor: "add",
                      from: widget.from,
                      sellerId: widget.sellerId,
                    )
                        .then((value) {
                      if (value is String) {
                        showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            surfaceTintColor: Colors.transparent,
                            backgroundColor: Theme.of(context).cardColor,
                            content: CustomTextLabel(
                              jsonKey: "seller_miss_match_item_message",
                              softWrap: true,
                            ),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: CustomTextLabel(
                                  jsonKey: "cancel",
                                  softWrap: true,
                                  style: TextStyle(
                                      color: ColorsRes.subTitleMainTextColor),
                                ),
                              ),
                              TextButton(
                                onPressed: () async {
                                  context
                                      .read<CartListProvider>()
                                      .clearCart(context: context)
                                      .then((value) async {
                                    cartListProvider.currentSelectedProduct =
                                        widget.productId;
                                    cartListProvider.currentSelectedVariant =
                                        widget.productVariantId;

                                    Map<String, String> params = {};
                                    params[ApiAndParams.productId] =
                                        widget.productId;
                                    params[ApiAndParams.productVariantId] =
                                        widget.productVariantId;
                                    params[ApiAndParams
                                        .qty] = (int.parse(cartListProvider
                                                .getItemCartItemQuantity(
                                                    widget.productId,
                                                    widget.productVariantId)) +
                                            1)
                                        .toString();
                                    await cartListProvider
                                        .addRemoveCartItem(
                                      context: context,
                                      params: params,
                                      isUnlimitedStock: widget.isUnlimitedStock,
                                      maximumAllowedQuantity:
                                          widget.maximumAllowedQuantity,
                                      availableStock: widget.availableStock,
                                      actionFor: "add",
                                      from: widget.from,
                                      sellerId: widget.sellerId,
                                    )
                                        .then((value) {
                                      Navigator.pop(context);
                                    });
                                  });
                                },
                                child: CustomTextLabel(
                                  jsonKey: "ok",
                                  softWrap: true,
                                  style: TextStyle(color: ColorsRes.appColor),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                    });
                    // } else {
                    //   loginUserAccount(context, "cart");
                    // }
                  }
                },
                child: Container(
                  alignment: AlignmentDirectional.center,
                  padding: EdgeInsets.symmetric(horizontal: Constant.size10),
                  decoration: widget.isGrid
                      ? BoxDecoration(
                          color: Colors.transparent,
                        )
                      : BoxDecoration(
                          color: Colors.transparent,
                          border: Border.symmetric(
                            vertical: BorderSide(
                              color: ColorsRes.subTitleMainTextColor,
                            ),
                            horizontal: BorderSide(
                              color: ColorsRes.subTitleMainTextColor,
                            ),
                          ),
                          borderRadius: BorderRadiusDirectional.all(
                            Radius.circular(5),
                          ),
                        ),
                  height: 35,
                  width: context.width * 0.25,
                  child: (cartListProvider.cartListState ==
                              CartListState.loading &&
                          cartListProvider.currentSelectedProduct ==
                              widget.productId &&
                          cartListProvider.currentSelectedVariant ==
                              widget.productVariantId)
                      ? Container(
                          alignment: AlignmentDirectional.center,
                          child: Container(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              color: ColorsRes.appColor,
                            ),
                          ),
                        )
                      : FittedBox(
                          fit: BoxFit.fill,
                          child: CustomTextLabel(
                            jsonKey: "add_to_cart",
                            style: TextStyle(
                              color: ColorsRes.mainTextColor.withOpacity(0.8),
                            ),
                          ),
                        ),
                ),
              )
            : (int.parse(cartListProvider.getItemCartItemQuantity(
                            widget.productId, widget.productVariantId)) !=
                        0 &&
                    widget.count != -1)
                ? Container(
                    height: 35,
                    width: context.width * 0.25,
                    decoration: BoxDecoration(
                      gradient: DesignConfig.linearGradient(
                          ColorsRes.appColor, ColorsRes.appColor),
                      borderRadius: widget.isGrid
                          ? BorderRadiusDirectional.only(
                              bottomStart: Radius.circular(10),
                              bottomEnd: Radius.circular(10),
                            )
                          : BorderRadiusDirectional.all(
                              Radius.circular(5),
                            ),
                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.only(start: 5),
                          child: SizedBox(
                            height: 25,
                            width: 25,
                            child: gradientBtnWidget(
                              context,
                              50,
                              color1: ColorsRes.appColorWhite,
                              color2: ColorsRes.appColorWhite,
                              callback: () async {
                                cartListProvider.currentSelectedProduct =
                                    widget.productId;
                                cartListProvider.currentSelectedVariant =
                                    widget.productVariantId;

                                Map<String, String> params = {};
                                params[ApiAndParams.productId] =
                                    widget.productId;
                                params[ApiAndParams.productVariantId] =
                                    widget.productVariantId;
                                params[ApiAndParams.qty] = (int.parse(
                                            cartListProvider
                                                .getItemCartItemQuantity(
                                                    widget.productId,
                                                    widget.productVariantId)) -
                                        1)
                                    .toString();

                                if (Constant.session.isUserLoggedIn()) {
                                  await cartListProvider.addRemoveCartItem(
                                    context: context,
                                    params: params,
                                    isUnlimitedStock: widget.isUnlimitedStock,
                                    maximumAllowedQuantity:
                                        widget.maximumAllowedQuantity,
                                    availableStock: widget.availableStock,
                                    from: widget.from,
                                    sellerId: widget.sellerId,
                                  );
                                } else {
                                  // if (Constant.guestCartOptionIsOn == "1") {
                                  await cartListProvider.addRemoveGuestCartItem(
                                    context: context,
                                    params: params,
                                    isUnlimitedStock: widget.isUnlimitedStock,
                                    maximumAllowedQuantity:
                                        widget.maximumAllowedQuantity,
                                    availableStock: widget.availableStock,
                                    from: widget.from,
                                    sellerId: widget.sellerId,
                                  );
                                  // } else {
                                  //   loginUserAccount(context, "cart");
                                  // }
                                }
                              },
                              otherWidgets: int.parse(cartListProvider
                                          .getItemCartItemQuantity(
                                              widget.productId,
                                              widget.productVariantId)) ==
                                      1
                                  ? defaultImg(
                                      image: "cart_delete",
                                      width: 20,
                                      height: 20,
                                      padding:
                                          const EdgeInsetsDirectional.all(5),
                                      iconColor: ColorsRes.appColor,
                                    )
                                  : defaultImg(
                                      image: "cart_remove",
                                      width: 20,
                                      height: 20,
                                      padding:
                                          const EdgeInsetsDirectional.all(5),
                                      iconColor: ColorsRes.appColor,
                                    ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: (cartListProvider.cartListState ==
                                      CartListState.loading &&
                                  cartListProvider.currentSelectedProduct ==
                                      widget.productId &&
                                  cartListProvider.currentSelectedVariant ==
                                      widget.productVariantId)
                              ? Container(
                                  alignment: AlignmentDirectional.center,
                                  child: Container(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      color: ColorsRes.appColorWhite,
                                    ),
                                  ),
                                )
                              : Container(
                                  alignment: AlignmentDirectional.center,
                                  width: 35,
                                  height: 35,
                                  child: CustomTextLabel(
                                    text: cartListProvider
                                        .getItemCartItemQuantity(
                                            widget.productId,
                                            widget.productVariantId),
                                    softWrap: true,
                                    style: TextStyle(
                                        color: ColorsRes.appColorWhite),
                                  ),
                                ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.only(end: 5),
                          child: SizedBox(
                            width: 25,
                            height: 25,
                            child: gradientBtnWidget(
                              context,
                              50,
                              color1: ColorsRes.appColorWhite,
                              color2: ColorsRes.appColorWhite,
                              callback: () async {
                                cartListProvider.currentSelectedProduct =
                                    widget.productId;
                                cartListProvider.currentSelectedVariant =
                                    widget.productVariantId;
                                Map<String, String> params = {};
                                params[ApiAndParams.productId] =
                                    widget.productId;
                                params[ApiAndParams.productVariantId] =
                                    widget.productVariantId;
                                params[ApiAndParams.qty] = (int.parse(
                                            cartListProvider
                                                .getItemCartItemQuantity(
                                                    widget.productId,
                                                    widget.productVariantId)) +
                                        1)
                                    .toString();

                                if (Constant.session.isUserLoggedIn()) {
                                  await cartListProvider.addRemoveCartItem(
                                    context: context,
                                    params: params,
                                    isUnlimitedStock: widget.isUnlimitedStock,
                                    maximumAllowedQuantity:
                                        widget.maximumAllowedQuantity,
                                    availableStock: widget.availableStock,
                                    from: widget.from,
                                    sellerId: widget.sellerId,
                                  );
                                } else {
                                  // if (Constant.guestCartOptionIsOn == "1") {
                                  await cartListProvider.addRemoveGuestCartItem(
                                    context: context,
                                    params: params,
                                    isUnlimitedStock: widget.isUnlimitedStock,
                                    maximumAllowedQuantity:
                                        widget.maximumAllowedQuantity,
                                    availableStock: widget.availableStock,
                                    from: widget.from,
                                    actionFor: "add",
                                    sellerId: widget.sellerId,
                                  );
                                  // } else {
                                  //   loginUserAccount(context, "cart");
                                  // }
                                }
                              },
                              otherWidgets: defaultImg(
                                image: "cart_add",
                                width: 20,
                                height: 20,
                                padding: const EdgeInsetsDirectional.all(5),
                                iconColor: ColorsRes.appColor,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                : const SizedBox.shrink();
      },
    );
  }
}
