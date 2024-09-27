import 'package:egrocer/helper/utils/generalImports.dart';

enum CartState {
  initial,
  loading,
  silentLoading,
  loaded,
  error,
}

class CartProvider extends ChangeNotifier {
  CartState cartState = CartState.initial;
  String message = '';
  late Cart cartData;
  late double subTotal = 0.0;

  Future<void> getCartListProvider({required BuildContext context}) async {
    if (cartState == CartState.loaded)
      cartState = CartState.silentLoading;
    else {
      cartState = CartState.loading;
    }
    notifyListeners();

    try {
      Map<String, String> params = await Constant.getProductsDefaultParams();
      Map<String, dynamic> getData =
          await getCartListApi(context: context, params: params);

      if (getData[ApiAndParams.status].toString() == "1") {
        cartData = Cart.fromJson(getData);
        subTotal = double.parse(cartData.data.subTotal);
        cartState = CartState.loaded;
        notifyListeners();
      } else {
        cartState = CartState.error;
        notifyListeners();
      }
    } catch (e) {
      message = e.toString();
      showMessage(
        context,
        message,
        MessageType.warning,
      );
      cartState = CartState.error;
      notifyListeners();
    }
  }

  Future<void> getGuestCartListProvider({required BuildContext context}) async {
    if (cartState == CartState.loaded)
      cartState = CartState.silentLoading;
    else {
      cartState = CartState.loading;
    }

    notifyListeners();

    try {
      Map<String, String> params = await Constant.getProductsDefaultParams();
      params.addAll(Constant.setGuestCartParams(
          cartList: context.read<CartListProvider>().cartList,
          cartParams: params));

      Map<String, dynamic> getData =
          await getGuestCartListApi(context: context, params: params);

      if (getData[ApiAndParams.status].toString() == "1") {
        cartData = Cart.fromJson(getData);
        subTotal = double.parse(cartData.data.subTotal);
        cartState = CartState.loaded;
        notifyListeners();
      } else {
        cartState = CartState.error;
        notifyListeners();
      }
    } catch (e) {
      message = e.toString();
      showMessage(
        context,
        message,
        MessageType.warning,
      );
      cartState = CartState.error;
      notifyListeners();
    }
  }

  Future setSubTotal(double newSubtotal) async {
    Constant.isPromoCodeApplied = false;
    Constant.selectedCoupon = "";
    Constant.discountedAmount = 0.0;
    Constant.discount = 0.0;
    Constant.selectedPromoCodeId = "0";
    subTotal = newSubtotal;
    notifyListeners();
  }

  Future removeItemFromCartList(
      {required int productId, required int variantId}) async {
    for (int i = 0; i < cartData.data.cart.length; i++) {
      CartItem cartItem = cartData.data.cart[i];

      if (cartItem.productId.toString() == productId.toString() &&
          cartItem.productVariantId.toString() == variantId.toString()) {
        cartData.data.cart.remove(cartItem);
        notifyListeners();
      }
    }
  }

  Future checkCartItemsStockStatus() async {
    bool isOneOrMoreItemsOutOfStock = false;
    for (int i = 0; i < cartData.data.cart.length; i++) {
      if (cartData.data.cart[i].status == "0") {
        isOneOrMoreItemsOutOfStock = true;
      }
    }
    return isOneOrMoreItemsOutOfStock;
  }
}
