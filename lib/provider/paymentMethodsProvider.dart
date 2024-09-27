import 'package:egrocer/helper/utils/generalImports.dart';

enum PaymentMethodsState {
  loading,
  loaded,
  empty,
  error,
}

class PaymentMethodsProvider extends ChangeNotifier {
  PaymentMethodsState paymentMethodsState = PaymentMethodsState.loading;

  //Payment methods variables
  PaymentMethods? paymentMethods;
  PaymentMethodsData? paymentMethodsData;
  String selectedPaymentMethod = "";
  int availablePaymentMethods = 0;
  String isCodAllowed = "0";
  String message = "";

  Future getPaymentMethods({required BuildContext context}) async {
    try {
      Map<String, dynamic> getPaymentMethodsSettings =
          (await getPaymentMethodsSettingsApi(context: context, params: {}));

      if (getPaymentMethodsSettings[ApiAndParams.status].toString() == "1") {
        List<int> decodedBytes = base64
            .decode(getPaymentMethodsSettings[ApiAndParams.data].toString());
        String decodedString = utf8.decode(decodedBytes);
        Map<String, dynamic> map = json.decode(decodedString);
        getPaymentMethodsSettings[ApiAndParams.data] = map;

        paymentMethods = PaymentMethods.fromJson(getPaymentMethodsSettings);
        paymentMethodsData = paymentMethods?.data;

        if (paymentMethodsData?.codPaymentMethod == "1" &&
            isCodAllowed == "1") {
          selectedPaymentMethod = "COD";
        } else if (paymentMethodsData?.midtransPaymentMethod == "1") {
          selectedPaymentMethod = "Midtrans";
        } else if (paymentMethodsData?.phonePayPaymentMethod == "1") {
          selectedPaymentMethod = "Phonepe";
        } else if (paymentMethodsData?.razorpayPaymentMethod == "1") {
          selectedPaymentMethod = "Razorpay";
        } else if (paymentMethodsData?.paystackPaymentMethod == "1") {
          selectedPaymentMethod = "Paystack";
        } else if (paymentMethodsData?.stripePaymentMethod == "1") {
          selectedPaymentMethod = "Stripe";
        } else if (paymentMethodsData?.paytmPaymentMethod == "1") {
          selectedPaymentMethod = "Paytm";
        } else if (paymentMethodsData?.paypalPaymentMethod == "1") {
          selectedPaymentMethod = "Paypal";
        }

        paymentMethodsState = PaymentMethodsState.loaded;
        notifyListeners();
      } else {
        showMessage(
          context,
          message,
          MessageType.warning,
        );
        paymentMethodsState = PaymentMethodsState.error;
        notifyListeners();
      }
    } catch (e) {
      message = e.toString();
      showMessage(
        context,
        message,
        MessageType.warning,
      );
      paymentMethodsState = PaymentMethodsState.error;
      notifyListeners();
    }
  }

  Future setSelectedPaymentMethod(String method) async {
    selectedPaymentMethod = method;
    notifyListeners();
  }

  Future updatePaymentMethodsCount() async {
    availablePaymentMethods++;
  }

  Future resetPaymentMethodsCount() async {
    availablePaymentMethods = 0;
  }
}
