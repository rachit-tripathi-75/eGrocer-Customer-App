import 'package:egrocer/helper/utils/generalImports.dart';
import 'package:egrocer/screens/checkoutScreen/widget/orderNoteWidget.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({Key? key}) : super(key: key);

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  late UserAddressData? selectedAddress;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero).then(
      (value) async {
        await context
            .read<CheckoutProvider>()
            .getTimeSlotsSettings(context: context);

        await context
            .read<CheckoutProvider>()
            .getSingleAddressProvider(context: context)
            .then(
          (selectedAddress) async {
            Map<String, String> params = {
              ApiAndParams.latitude: selectedAddress?.latitude?.toString() ??
                  Constant.session.getData(SessionManager.keyLatitude),
              ApiAndParams.longitude: selectedAddress?.longitude?.toString() ??
                  Constant.session.getData(SessionManager.keyLongitude),
              ApiAndParams.isCheckout: "1"
            };

            if (Constant.selectedPromoCodeId != "0") {
              params[ApiAndParams.promoCodeId] = Constant.selectedPromoCodeId;
            }

            await context
                .read<CheckoutProvider>()
                .getOrderChargesProvider(
                  context: context,
                  params: params,
                )
                .then(
              (value) async {
                setState(() {});
                await context
                    .read<PaymentMethodsProvider>()
                    .getPaymentMethods(context: context)
                    .then(
                  (value) {
                    setState(() {});
                    StripeService.init(
                      stripeId: context
                              .read<PaymentMethodsProvider>()
                              .paymentMethods
                              ?.data
                              .stripePublishableKey ??
                          "",
                      secretKey: context
                              .read<PaymentMethodsProvider>()
                              .paymentMethods
                              ?.data
                              .stripeSecretKey ??
                          "",
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) {
          return;
        } else {
          if (!context.read<CheckoutProvider>().isPaymentUnderProcessing) {
            Navigator.pop(context);
          } else {
            showMessage(
                context,
                getTranslatedValue(context,
                    "you_can_not_go_back_until_payment_cancel_or_success"),
                MessageType.warning);
          }
        }
      },
      child: Scaffold(
        appBar: getAppBar(
          context: context,
          title: CustomTextLabel(
            jsonKey: "checkout",
            softWrap: true,
            style: TextStyle(
              color: ColorsRes.mainTextColor,
            ),
          ),
          onTap: () async {
            if (context.read<CheckoutProvider>().isPaymentUnderProcessing) {
              showMessage(
                  context,
                  getTranslatedValue(context,
                      "you_can_not_go_back_until_payment_cancel_or_success"),
                  MessageType.warning);
            } else {
              Navigator.pop(context);
            }
          },
        ),
        body: Consumer<CheckoutProvider>(
          builder: (context, checkoutProvider, _) {
            return Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      if (checkoutProvider.deliveryChargeData?.userBalance
                                  .toString() !=
                              "0" &&
                          checkoutProvider.deliveryChargeData?.userBalance
                                  .toString() !=
                              null)
                        Container(
                          decoration: DesignConfig.boxDecoration(
                              Theme.of(context).cardColor, 10),
                          padding: const EdgeInsets.all(10),
                          margin: EdgeInsetsDirectional.only(
                            start: 10,
                            end: 10,
                            top: 10,
                          ),
                          child: Row(
                            children: [
                              defaultImg(
                                image: "wallet",
                                iconColor: ColorsRes.appColor,
                              ),
                              getSizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomTextLabel(
                                      jsonKey: "wallet_balance",
                                    ),
                                    CustomTextLabel(
                                      jsonKey:
                                          "${context.read<CheckoutProvider>().availableWalletAmount}"
                                              .currency,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: ColorsRes.appColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              getSizedBox(width: 10),
                              CustomCheckbox(
                                value: checkoutProvider.usedWallet ?? false,
                                onChanged: (value) {
                                  checkoutProvider.userWalletAmount(value!);
                                },
                              ),
                            ],
                          ),
                        ),
                      if (checkoutProvider.checkoutAddressState ==
                              CheckoutAddressState.addressLoading &&
                          checkoutProvider.checkoutTimeSlotsState ==
                              CheckoutTimeSlotsState.timeSlotsLoading &&
                          context
                                  .read<PaymentMethodsProvider>()
                                  .paymentMethodsState ==
                              PaymentMethodsState.loading)
                        getCheckoutShimmer(),
                      if (context
                                  .read<PaymentMethodsProvider>()
                                  .paymentMethodsState ==
                              PaymentMethodsState.loaded &&
                          (checkoutProvider.checkoutTimeSlotsState ==
                                  CheckoutTimeSlotsState.timeSlotsLoaded ||
                              checkoutProvider.checkoutTimeSlotsState ==
                                  CheckoutTimeSlotsState.timeSlotsError) &&
                          (checkoutProvider.checkoutAddressState ==
                                  CheckoutAddressState.addressLoaded ||
                              checkoutProvider.checkoutAddressState ==
                                  CheckoutAddressState.addressBlank ||
                              checkoutProvider.checkoutAddressState ==
                                  CheckoutAddressState.addressError))
                        getAddressWidget(context),
                      if (context
                                  .read<PaymentMethodsProvider>()
                                  .paymentMethodsState ==
                              PaymentMethodsState.loaded &&
                          (checkoutProvider.checkoutTimeSlotsState ==
                                  CheckoutTimeSlotsState.timeSlotsLoaded ||
                              checkoutProvider.checkoutTimeSlotsState ==
                                  CheckoutTimeSlotsState.timeSlotsError) &&
                          (checkoutProvider.checkoutAddressState ==
                                  CheckoutAddressState.addressLoaded ||
                              checkoutProvider.checkoutAddressState ==
                                  CheckoutAddressState.addressBlank ||
                              checkoutProvider.checkoutAddressState ==
                                  CheckoutAddressState.addressError))
                        GetTimeSlots(),
                      if (context
                                  .read<PaymentMethodsProvider>()
                                  .paymentMethodsState ==
                              PaymentMethodsState.loaded &&
                          (checkoutProvider.checkoutTimeSlotsState ==
                                  CheckoutTimeSlotsState.timeSlotsLoaded ||
                              checkoutProvider.checkoutTimeSlotsState ==
                                  CheckoutTimeSlotsState.timeSlotsError) &&
                          (checkoutProvider.checkoutAddressState ==
                                  CheckoutAddressState.addressLoaded ||
                              checkoutProvider.checkoutAddressState ==
                                  CheckoutAddressState.addressBlank ||
                              checkoutProvider.checkoutAddressState ==
                                  CheckoutAddressState.addressError))
                        OrderNoteWidget(
                          edtOrderNote: checkoutProvider.edtOrderNote,
                        ),
                      if (checkoutProvider.totalAmount != 0.0 &&
                          (context
                                      .read<PaymentMethodsProvider>()
                                      .paymentMethodsState ==
                                  PaymentMethodsState.loaded &&
                              (checkoutProvider.checkoutTimeSlotsState ==
                                      CheckoutTimeSlotsState.timeSlotsLoaded ||
                                  checkoutProvider.checkoutTimeSlotsState ==
                                      CheckoutTimeSlotsState.timeSlotsError) &&
                              (checkoutProvider.checkoutAddressState ==
                                      CheckoutAddressState.addressLoaded ||
                                  checkoutProvider.checkoutAddressState ==
                                      CheckoutAddressState.addressBlank ||
                                  checkoutProvider.checkoutAddressState ==
                                      CheckoutAddressState.addressError)))
                        PaymentMethodsWidget(
                          isPaymentUnderProcessing:
                              checkoutProvider.isPaymentUnderProcessing,
                        ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    if (context
                                .read<PaymentMethodsProvider>()
                                .paymentMethodsState ==
                            PaymentMethodsState.loaded &&
                        (checkoutProvider.checkoutTimeSlotsState ==
                                CheckoutTimeSlotsState.timeSlotsLoaded ||
                            checkoutProvider.checkoutTimeSlotsState ==
                                CheckoutTimeSlotsState.timeSlotsError) &&
                        (checkoutProvider.checkoutAddressState ==
                                CheckoutAddressState.addressLoaded ||
                            checkoutProvider.checkoutAddressState ==
                                CheckoutAddressState.addressBlank ||
                            checkoutProvider.checkoutAddressState ==
                                CheckoutAddressState.addressError) &&
                        checkoutProvider.checkoutDeliveryChargeState ==
                            CheckoutDeliveryChargeState.deliveryChargeLoaded &&
                        checkoutProvider.selectedAddress?.id != null)
                      getDeliveryCharges(context),
                    if (checkoutProvider.checkoutDeliveryChargeState ==
                        CheckoutDeliveryChargeState.deliveryChargeLoading)
                      getDeliveryChargeShimmer(),
                    PlaceOrderButtonWidget(
                      context: context,
                    ),
                  ],
                )
              ],
            );
          },
        ),
      ),
    );
  }

  getCheckoutShimmer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        CustomShimmer(
          margin: EdgeInsetsDirectional.all(Constant.size10),
          borderRadius: 7,
          width: double.maxFinite,
          height: 150,
        ),
        const CustomShimmer(
          width: 250,
          height: 25,
          borderRadius: 10,
          margin: EdgeInsetsDirectional.all(10),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(
              10,
              (index) {
                return const CustomShimmer(
                  width: 50,
                  height: 80,
                  borderRadius: 10,
                  margin: EdgeInsetsDirectional.fromSTEB(10, 0, 0, 10),
                );
              },
            ),
          ),
        ),
        const CustomShimmer(
          width: double.maxFinite,
          height: 45,
          borderRadius: 10,
          margin: EdgeInsetsDirectional.all(10),
        ),
        const CustomShimmer(
          width: double.maxFinite,
          height: 45,
          borderRadius: 10,
          margin: EdgeInsetsDirectional.all(10),
        ),
        const CustomShimmer(
          width: 250,
          height: 25,
          borderRadius: 10,
          margin: EdgeInsetsDirectional.all(10),
        ),
        const CustomShimmer(
          width: double.maxFinite,
          height: 45,
          borderRadius: 10,
          margin: EdgeInsetsDirectional.all(10),
        ),
        const CustomShimmer(
          width: double.maxFinite,
          height: 45,
          borderRadius: 10,
          margin: EdgeInsetsDirectional.all(10),
        ),
        const CustomShimmer(
          width: double.maxFinite,
          height: 45,
          borderRadius: 10,
          margin: EdgeInsetsDirectional.all(10),
        ),
      ],
    );
  }

  getDeliveryChargeShimmer() {
    return Padding(
      padding: EdgeInsets.all(Constant.size10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: CustomShimmer(
                  height: 20,
                  borderRadius: 7,
                ),
              ),
              getSizedBox(
                width: Constant.size10,
              ),
              const Expanded(
                child: CustomShimmer(
                  height: 20,
                  width: 80,
                  borderRadius: 7,
                ),
              )
            ],
          ),
          getSizedBox(
            height: Constant.size7,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: CustomShimmer(
                  height: 20,
                  borderRadius: 7,
                ),
              ),
              getSizedBox(
                width: Constant.size10,
              ),
              const Expanded(
                child: CustomShimmer(
                  height: 20,
                  borderRadius: 7,
                ),
              )
            ],
          ),
          getSizedBox(
            height: Constant.size7,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: CustomShimmer(
                  height: 22,
                  borderRadius: 7,
                ),
              ),
              getSizedBox(
                width: Constant.size10,
              ),
              const Expanded(
                child: CustomShimmer(
                  height: 22,
                  borderRadius: 7,
                ),
              )
            ],
          ),
          getSizedBox(
            height: Constant.size7,
          ),
        ],
      ),
    );
  }
}
