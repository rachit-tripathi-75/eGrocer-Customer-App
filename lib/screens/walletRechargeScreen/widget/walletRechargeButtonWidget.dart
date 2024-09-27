import 'package:egrocer/helper/utils/generalImports.dart';

class WalletRechargeButtonWidget extends StatefulWidget {
  final BuildContext context;
  final TextEditingController rechargeAmount;

  const WalletRechargeButtonWidget(
      {Key? key, required this.context, required this.rechargeAmount})
      : super(key: key);

  @override
  State<WalletRechargeButtonWidget> createState() =>
      WalletRechargeButtonWidgetState();
}

class WalletRechargeButtonWidgetState
    extends State<WalletRechargeButtonWidget> {
  final Razorpay _razorpay = Razorpay();
  late String razorpayKey = "";
  late String paystackKey = "";
  late double amount = 0.00;
  late PaystackPlugin paystackPlugin;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero).then((value) async {
      paystackPlugin = PaystackPlugin();

      _razorpay.on(
          Razorpay.EVENT_PAYMENT_SUCCESS, _handleRazorPayPaymentSuccess);
      _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handleRazorPayPaymentError);
      _razorpay.on(
          Razorpay.EVENT_EXTERNAL_WALLET, _handleRazorPayExternalWallet);
    });
  }

  void _handleRazorPayPaymentSuccess(PaymentSuccessResponse response) {
    context.read<WalletRechargeProvider>().transactionId =
        response.paymentId.toString();
    context.read<WalletRechargeProvider>().addWalletTransaction(
        context: context,
        walletRechargeAmount: widget.rechargeAmount.text.toString());
  }

  void _handleRazorPayPaymentError(PaymentFailureResponse response) {
    context.read<WalletRechargeProvider>().setWalletPaymentProcessState(false);
    showMessage(
        context, response.message.toString(), MessageType.warning);
  }

  void _handleRazorPayExternalWallet(ExternalWalletResponse response) {
    context.read<WalletRechargeProvider>().setWalletPaymentProcessState(false);
    showMessage(
        context, response.toString(), MessageType.warning);
  }

  void openRazorPayGateway() async {
    final options = {
      'key': razorpayKey, //this should be come from server
      'order_id': context.read<WalletRechargeProvider>().razorpayOrderId,
      'prefill': {
        'contact': Constant.session.getData(SessionManager.keyPhone),
        'email': Constant.session.getData(SessionManager.keyEmail)
      },
    };

    _razorpay.open(options);
  }

  // Using package flutter_paystack
  Future openPaystackPaymentGateway() async {
    try {
      await paystackPlugin.initialize(
          publicKey: context
                  .read<PaymentMethodsProvider>()
                  .paymentMethodsData
                  ?.paystackPublicKey ??
              "0");

      Charge charge = Charge()
        ..amount =
            (widget.rechargeAmount.text.toString().toDouble * 100).toInt()
        ..currency = context
                .read<PaymentMethodsProvider>()
                .paymentMethodsData
                ?.paystackCurrencyCode ??
            ""
        ..reference = DateTime.now().millisecondsSinceEpoch.toString()
        ..email = Constant.session.getData(SessionManager.keyEmail);

      CheckoutResponse response = await paystackPlugin.checkout(
        context,
        fullscreen: false,
        logo: defaultImg(
          height: 50,
          width: 50,
          image: "logo",
          requiredRTL: false,
        ),
        method: CheckoutMethod.card,
        charge: charge,
      );

      if (response.status) {
        context.read<WalletRechargeProvider>().transactionId =
            response.reference.toString();
        context.read<WalletRechargeProvider>().addWalletTransaction(
            context: context,
            walletRechargeAmount: widget.rechargeAmount.text.toString());
      } else {
        context
            .read<WalletRechargeProvider>()
            .setWalletPaymentProcessState(false);
      }
    } catch (e) {
      showMessage(context, e.toString(), MessageType.error);
    }
  }

  //Paytm Payment Gateway
  openPaytmPaymentGateway(String rechargeAmount) async {
    try {
      sendApiRequest(
              apiName: ApiAndParams.apiPaytmTransactionToken,
              params: {
                ApiAndParams.walletAmount:
                    widget.rechargeAmount.text.toString().toDouble.toString(),
                ApiAndParams.type: ApiAndParams.walletType
              },
              isPost: false,
              context: context)
          .then((value) async {
        await Paytm.payWithPaytm(
                mId: context
                        .read<PaymentMethodsProvider>()
                        .paymentMethodsData
                        ?.paytmMerchantId ??
                    "",
                orderId: DateTime.now().millisecondsSinceEpoch.toString(),
                txnToken: context.read<WalletRechargeProvider>().paytmTxnToken,
                txnAmount:
                    widget.rechargeAmount.text.toString().toDouble.toString(),
                callBackUrl:
                    '${context.read<PaymentMethodsProvider>().paymentMethodsData?.paytmMode == "sandbox" ? 'https://securegw-stage.paytm.in' : 'https://securegw.paytm.in'}/theia/paytmCallback?ORDER_ID=${context.read<WalletRechargeProvider>().placedOrderId}',
                staging: context
                        .read<PaymentMethodsProvider>()
                        .paymentMethodsData
                        ?.paytmMode ==
                    "sandbox",
                appInvokeEnabled: false)
            .then((value) {
          Map<dynamic, dynamic> response = value["response"];
          if (response["STATUS"] == "TXN_SUCCESS") {
            context.read<WalletRechargeProvider>().transactionId =
                response["TXNID"].toString();
            context.read<WalletRechargeProvider>().addWalletTransaction(
                context: context,
                walletRechargeAmount: widget.rechargeAmount.text.toString());
          } else {
            showMessage(
                context, response["STATUS"], MessageType.warning);

            context
                .read<WalletRechargeProvider>()
                .setWalletPaymentProcessState(false);
          }
        });
      });
    } catch (e) {
      showMessage(context, e.toString(), MessageType.warning);
      context
          .read<WalletRechargeProvider>()
          .setWalletPaymentProcessState(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PaymentMethodsProvider>(
        builder: (context, paymentMethodsProvider, child) {
      return Consumer<WalletRechargeProvider>(
        builder: (context, walletRechargeProvider, child) {
          return gradientBtnWidget(
            context,
            5,
            callback: () async {
              if (widget.rechargeAmount.text.isNotEmpty &&
                  amountValidation(widget.rechargeAmount.text) ==
                      null &&
                  !walletRechargeProvider.isPaymentUnderProcessing) {
                walletRechargeProvider.setWalletPaymentProcessState(true).then(
                  (value) {
                    if (paymentMethodsProvider.selectedPaymentMethod ==
                        "Razorpay") {
                      razorpayKey = paymentMethodsProvider
                              .paymentMethodsData?.razorpayKey ??
                          "0";
                      amount = widget.rechargeAmount.text.toString().toDouble;

                      context
                          .read<WalletRechargeProvider>()
                          .initiateWalletRazorpayTransaction(
                              context: context,
                              rechargeAmount:
                                  widget.rechargeAmount.text.toString())
                          .then((value) => openRazorPayGateway());
                    } else if (paymentMethodsProvider.selectedPaymentMethod ==
                        "Paystack") {
                      amount = widget.rechargeAmount.text.toString().toDouble;
                      return openPaystackPaymentGateway();
                    } else if (paymentMethodsProvider.selectedPaymentMethod ==
                        "Stripe") {
                      amount = widget.rechargeAmount.text.toString().toDouble;

                      try {
                        StripeService.init(
                          stripeId: paymentMethodsProvider
                                  .paymentMethods?.data.stripePublishableKey ??
                              "",
                          secretKey: paymentMethodsProvider
                                  .paymentMethods?.data.stripeSecretKey ??
                              "",
                        ).then(
                          (value) {
                            StripeService.payWithPaymentSheet(
                              amount:
                                  int.parse((amount * 100).toStringAsFixed(0)),
                              isTestEnvironment: true,
                              awaitedOrderId: DateTime.now()
                                  .millisecondsSinceEpoch
                                  .toString(),
                              context: context,
                              currency: paymentMethodsProvider.paymentMethods
                                      ?.data.stripeCurrencyCode ??
                                  "0",
                              from: "wallet",
                            ).then(
                              (value) {
                                return context
                                    .read<WalletRechargeProvider>()
                                    .setWalletPaymentProcessState(false);
                              },
                            );
                          },
                        );
                      } catch (e) {
                        showMessage(
                            context, e.toString(), MessageType.error);
                      }
                    } else if (paymentMethodsProvider.selectedPaymentMethod ==
                        "Paytm") {
                      amount = widget.rechargeAmount.text.toString().toDouble;

                      context
                          .read<WalletRechargeProvider>()
                          .setWalletPaymentProcessState(false);
                      showMessage(
                          context,
                          getTranslatedValue(context, "something_went_wrong")
                              .toString(),
                          MessageType.warning);
                      openPaytmPaymentGateway(
                          widget.rechargeAmount.text.toString());
                    } else if (paymentMethodsProvider.selectedPaymentMethod ==
                        "Paypal") {
                      amount = widget.rechargeAmount.text.toString().toDouble;
                      context
                          .read<WalletRechargeProvider>()
                          .initiateWalletPaypalTransaction(
                              context: context,
                              rechargeAmount:
                                  widget.rechargeAmount.text.toString())
                          .then(
                        (value) {
                          context
                              .read<WalletRechargeProvider>()
                              .setWalletPaymentProcessState(false);
                        },
                      );
                    } else if (paymentMethodsProvider.selectedPaymentMethod ==
                        "Midtrans") {
                      amount = widget.rechargeAmount.text.toString().toDouble;
                      context
                          .read<WalletRechargeProvider>()
                          .initiateWalletMidtransTransaction(
                            context: context,
                            rechargeAmount:
                                widget.rechargeAmount.text.toString(),
                          );
                    } else if (paymentMethodsProvider.selectedPaymentMethod ==
                        "Phonepe") {
                      amount = widget.rechargeAmount.text.toString().toDouble;
                      context
                          .read<WalletRechargeProvider>()
                          .initiateWalletPhonePeTransaction(
                            context: context,
                            rechargeAmount:
                                widget.rechargeAmount.text.toString(),
                          );
                    }
                  },
                );
              } else {
                showMessage(
                    context,
                    getTranslatedValue(context, "enter_valid_amount")
                        .toString(),
                    MessageType.warning);
              }
            },
            otherWidgets: (context
                    .read<WalletRechargeProvider>()
                    .isPaymentUnderProcessing)
                ? Container(
                    alignment: Alignment.center,
                    padding: EdgeInsetsDirectional.all(4),
                    width: 40,
                    height: 40,
                    child: CircularProgressIndicator(
                      color: ColorsRes.appColorWhite,
                    ),
                  )
                : context
                        .read<WalletRechargeProvider>()
                        .isPaymentUnderProcessing
                    ? Container(
                        alignment: Alignment.center,
                        padding: EdgeInsetsDirectional.all(4),
                        width: 40,
                        height: 40,
                        child: CircularProgressIndicator(
                          color: ColorsRes.appColorWhite,
                        ),
                      )
                    : Container(
                        alignment: Alignment.center,
                        child: CustomTextLabel(
                          jsonKey: "recharge",
                          style: Theme.of(context).textTheme.titleMedium!.merge(
                                TextStyle(
                                  letterSpacing: 0.5,
                                  fontWeight: FontWeight.w500,
                                  color: ColorsRes.appColorWhite,
                                  fontSize: 16,
                                ),
                              ),
                        ),
                      ),
          );
        },
      );
    });
  }
}
