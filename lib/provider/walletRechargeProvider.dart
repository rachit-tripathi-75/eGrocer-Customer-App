import 'package:egrocer/helper/utils/generalImports.dart';

class WalletRechargeProvider extends ChangeNotifier {
  String message = "";

  bool isPaymentUnderProcessing = false;

  //Place order variables
  String placedOrderId = "";
  String razorpayOrderId = "";
  String transactionId = "";
  String payStackReference = "";

  String paytmTxnToken = "";

  Future setWalletPaymentProcessState(bool value) async {
    isPaymentUnderProcessing = value;
    notifyListeners();
  }

  Future initiateWalletPaytmTransaction(
      {required BuildContext context, required String rechargeAmount}) async {
    try {
      Map<String, String> params = {};

      params[ApiAndParams.walletAmount] = rechargeAmount;
      params[ApiAndParams.type] = ApiAndParams.walletType;

      Map<String, dynamic> getPaytmTransactionTokenResponse =
          (await getPaytmTransactionTokenApi(context: context, params: params));

      if (getPaytmTransactionTokenResponse[ApiAndParams.status].toString() ==
          "1") {
        PaytmTransactionToken paytmTransactionToken =
            PaytmTransactionToken.fromJson(getPaytmTransactionTokenResponse);
        paytmTxnToken = paytmTransactionToken.data?.txnToken ?? "";
        notifyListeners();
      } else {
        showMessage(
          context,
          message,
          MessageType.warning,
        );
        notifyListeners();
        return false;
      }
    } catch (e) {
      message = e.toString();
      showMessage(
        context,
        message,
        MessageType.warning,
      );
      notifyListeners();
      return false;
    }
  }

  Future initiateWalletRazorpayTransaction(
      {required BuildContext context, required String rechargeAmount}) async {
    try {
      Map<String, String> params = {};

      params[ApiAndParams.paymentMethod] = context
          .read<PaymentMethodsProvider>()
          .selectedPaymentMethod
          .toString();
      params[ApiAndParams.walletAmount] = rechargeAmount;
      params[ApiAndParams.type] = ApiAndParams.walletType;

      Map<String, dynamic> getInitiatedTransactionResponse =
          (await getInitiatedTransactionApi(context: context, params: params));

      if (getInitiatedTransactionResponse[ApiAndParams.status].toString() ==
          "1") {
        InitiateTransaction initiateTransaction =
            InitiateTransaction.fromJson(getInitiatedTransactionResponse);
        razorpayOrderId = initiateTransaction.data.transactionId;
        notifyListeners();
      } else {
        showMessage(
          context,
          getInitiatedTransactionResponse["message"],
          MessageType.warning,
        );
        notifyListeners();
      }
    } catch (e) {
      message = e.toString();
      showMessage(
        context,
        message,
        MessageType.warning,
      );
      notifyListeners();
    }
  }

  Future initiateWalletPaypalTransaction(
      {required BuildContext context, required String rechargeAmount}) async {
    try {
      Map<String, String> params = {};

      params[ApiAndParams.paymentMethod] = context
          .read<PaymentMethodsProvider>()
          .selectedPaymentMethod
          .toString();
      params[ApiAndParams.walletAmount] = rechargeAmount;
      params[ApiAndParams.type] = ApiAndParams.walletType;

      Map<String, dynamic> getInitiatedTransactionResponse =
          await getInitiatedTransactionApi(context: context, params: params);

      if (getInitiatedTransactionResponse[ApiAndParams.status].toString() ==
          "1") {
        Map<String, dynamic> data =
            getInitiatedTransactionResponse[ApiAndParams.data];
        Navigator.pushNamed(context, paypalPaymentScreen,
                arguments: data["paypal_redirect_url"])
            .then((value) {
          if (value == "success" || value == "pending") {
            if (value == "pending") {
              showMessage(
                  context,
                  getTranslatedValue(
                      context, "wallet_recharge_paypal_pending_message"),
                  MessageType.warning);
            }
            Navigator.pop(context);
            return true;
          } else if (value == "fail") {
            showMessage(
              context,
              getTranslatedValue(context, "payment_cancelled_by_user"),
              MessageType.warning,
            );
            return false;
          }
        });
        notifyListeners();
      } else {
        showMessage(
          context,
          message,
          MessageType.warning,
        );
        notifyListeners();
        return false;
      }
    } catch (e) {
      message = e.toString();
      showMessage(
        context,
        message,
        MessageType.warning,
      );
      notifyListeners();
      return false;
    }
  }

  Future initiateWalletMidtransTransaction(
      {required BuildContext context, required String rechargeAmount}) async {
    try {
      Map<String, String> params = {};

      params[ApiAndParams.paymentMethod] = context
          .read<PaymentMethodsProvider>()
          .selectedPaymentMethod
          .toString();
      params[ApiAndParams.walletAmount] = rechargeAmount;
      params[ApiAndParams.type] = ApiAndParams.walletType;

      Map<String, dynamic> getInitiatedTransactionResponse =
          await getInitiatedTransactionApi(context: context, params: params);

      if (getInitiatedTransactionResponse[ApiAndParams.status].toString() ==
          "1") {
        Map<String, dynamic> data =
            getInitiatedTransactionResponse[ApiAndParams.data];

        if (data.containsKey("snapUrl") && data["snapUrl"].toString() != "") {
          Navigator.pushNamed(context, midtransPaymentScreen,
                  arguments: data["snapUrl"])
              .then((status_code) {
            if (status_code is String) {
              if (status_code == "200" || status_code == "201") {
                if (status_code == "201") {
                  showMessage(
                      context,
                      getTranslatedValue(
                          context, "wallet_recharge_midtrans_pending_message"),
                      MessageType.warning);
                }
                notifyListeners();
                Navigator.pop(context, true);
              } else if (status_code == "202") {
                showMessage(
                  context,
                  getTranslatedValue(context, "payment_cancelled_by_user"),
                  MessageType.warning,
                );
                notifyListeners();
                Navigator.pop(context, false);
              }
            }
          });
        }
      } else {
        showMessage(
          context,
          message,
          MessageType.warning,
        );
        notifyListeners();
        Navigator.pop(context, false);
      }
    } catch (e) {
      message = e.toString();
      showMessage(
        context,
        message,
        MessageType.warning,
      );
      notifyListeners();
      Navigator.pop(context, false);
    }
  }

  Future initiateWalletPhonePeTransaction(
      {required BuildContext context, required String rechargeAmount}) async {
    try {
      Map<String, String> params = {};

      params[ApiAndParams.paymentMethod] = context
          .read<PaymentMethodsProvider>()
          .selectedPaymentMethod
          .toString();
      params[ApiAndParams.walletAmount] = rechargeAmount;
      params[ApiAndParams.type] = ApiAndParams.walletType;

      Map<String, dynamic> getInitiatedTransactionResponse =
          await getInitiatedTransactionApi(context: context, params: params);

      if (getInitiatedTransactionResponse[ApiAndParams.status].toString() ==
          "1") {
        Map<String, dynamic> data =
            getInitiatedTransactionResponse[ApiAndParams.data];

        if (data.containsKey("redirectUrl") &&
            data["redirectUrl"].toString() != "") {
          Navigator.pushNamed(context, phonePePaymentScreen,
                  arguments: data["redirectUrl"])
              .then((status_code) {
            if (status_code is String) {
              if (status_code == "PAYMENT_SUCCESS" ||
                  status_code == "PAYMENT_PENDING") {
                if (status_code == "PAYMENT_PENDING") {
                  showMessage(
                      context,
                      getTranslatedValue(
                          context, "order_phonepe_pending_message"),
                      MessageType.warning);
                  Navigator.pop(context, true);
                } else if (status_code == "PAYMENT_SUCCESS") {
                  Navigator.pop(context, true);
                }
              } else if (status_code == "PAYMENT_ERROR") {
                Navigator.pop(context, false);
                showMessage(
                  context,
                  getTranslatedValue(context, "order_phonepe_error_message"),
                  MessageType.warning,
                );
                return false;
              } else if (status_code == "PAYMENT_DECLINED") {
                Navigator.pop(context, false);
                showMessage(
                  context,
                  getTranslatedValue(context, "order_phonepe_declined_message"),
                  MessageType.warning,
                );
                return false;
              } else if (status_code == "PAYMENT_CANCELLED") {
                Navigator.pop(context, false);
                showMessage(
                  context,
                  getTranslatedValue(
                      context, "order_phonepe_cancelled_message"),
                  MessageType.warning,
                );
                return false;
              }
            }
          });
        }
      } else {
        showMessage(
          context,
          message,
          MessageType.warning,
        );
        notifyListeners();
        Navigator.pop(context, false);
      }
    } catch (e) {
      message = e.toString();
      showMessage(
        context,
        message,
        MessageType.warning,
      );
      notifyListeners();
      Navigator.pop(context, false);
    }
  }

  Future addWalletTransaction(
      {required BuildContext context,
      required String walletRechargeAmount}) async {
    try {
      PackageInfo packageInfo;
      packageInfo = await PackageInfo.fromPlatform();

      Map<String, String> params = {};

      params[ApiAndParams.walletAmount] = walletRechargeAmount;
      params[ApiAndParams.deviceType] =
          setFirstLetterUppercase(Platform.operatingSystem);
      params[ApiAndParams.appVersion] = packageInfo.version;
      params[ApiAndParams.transactionId] = transactionId;
      params[ApiAndParams.paymentMethod] = context
          .read<PaymentMethodsProvider>()
          .selectedPaymentMethod
          .toString();
      params[ApiAndParams.type] = ApiAndParams.walletType;

      Map<String, dynamic> addedTransaction =
          (await getAddTransactionApi(context: context, params: params));
      if (addedTransaction[ApiAndParams.status].toString() == "1") {
        Map<String, dynamic> transactionData =
            addedTransaction[ApiAndParams.data];

        Constant.session.setData(SessionManager.keyWalletBalance,
            transactionData[ApiAndParams.userBalance].toString(), true);

        isPaymentUnderProcessing = false;
        notifyListeners();
        Navigator.pop(context, true);
      } else {
        showMessage(
          context,
          addedTransaction[ApiAndParams.message],
          MessageType.warning,
        );
        isPaymentUnderProcessing = false;
        notifyListeners();
      }
    } catch (e) {
      message = e.toString();
      showMessage(
        context,
        message,
        MessageType.warning,
      );
      isPaymentUnderProcessing = false;
      notifyListeners();
    }
  }
}
