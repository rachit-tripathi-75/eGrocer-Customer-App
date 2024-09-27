import 'dart:io' as io;

import 'package:egrocer/helper/utils/generalImports.dart';

class OrderSummaryScreen extends StatefulWidget {
  final String orderId;
  final String from;

  const OrderSummaryScreen(
      {Key? key, required this.orderId, required this.from})
      : super(key: key);

  @override
  State<OrderSummaryScreen> createState() => _OrderSummaryScreenState();
}

class _OrderSummaryScreenState extends State<OrderSummaryScreen> {
  late Order order;
  late DateTime estimatedDeliveryDate;

  String getStatusCompleteDate(int currentStatus) {
    if (order.status!.isNotEmpty) {
      final statusValue = order.status?.where((element) {
        return element.first.toString() == currentStatus.toString();
      }).toList();

      if (statusValue!.isNotEmpty) {
        //[2, 04-10-2022 06:13:45am] so fetching last value
        return statusValue.first.last.toString().formatDate();
      }
    }

    return "";
  }

  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) async {
      await callApi();
    });
    super.initState();
  }

  Future callApi() async {
    context.read<CurrentOrderProvider>().getCurrentOrder(
        params: {ApiAndParams.orderId: widget.orderId},
        context: context).then((value) {
      if (value is Order) {
        order = value;
      }
    });
  }

  Widget _buildReturnOrderButton(
      {required Order order,
      required String orderItemId,
      required double width}) {
    return GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            builder: (context) =>
                ChangeNotifierProvider<UpdateOrderStatusProvider>(
                  create: (context) => UpdateOrderStatusProvider(),
                  child:
                      ReturnOrderDialog(order: order, orderItemId: orderItemId),
                )).then((value) {
          if (value != null) {
            if (value) {
              callApi();
            }
          }
        });
      },
      child: Container(
        alignment: Alignment.center,
        width: width,
        child: CustomTextLabel(
          jsonKey: "return1",
          style: TextStyle(color: ColorsRes.appColor),
        ),
      ),
    );
  }

  Widget _buildCancelItemButton(OrderItem orderItem) {
    return GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            builder: (context) =>
                ChangeNotifierProvider<UpdateOrderStatusProvider>(
                  create: (context) => UpdateOrderStatusProvider(),
                  child: CancelProductDialog(
                    order: order,
                    orderItemId: orderItem.id.toString(),
                  ),
                )).then((value) {
          //If we get true as value means we need to update this product's status to 7
          if (value) {
            callApi();
          }
        });
      },
      child: Container(
        decoration:
            BoxDecoration(border: Border.all(color: Colors.transparent)),
        child: CustomTextLabel(
          jsonKey: "cancel",
          softWrap: true,
          style: TextStyle(color: ColorsRes.appColor),
        ),
      ),
    );
  }

  Widget _buildOrderStatusContainer() {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.only(bottom: 10, top: 10),
      width: context.width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).cardColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                CustomTextLabel(
                  jsonKey: "order",
                  softWrap: true,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                    color: ColorsRes.mainTextColor,
                  ),
                ),
                const Spacer(),
                CustomTextLabel(
                  text: "#${order.id}",
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                    color: ColorsRes.mainTextColor,
                  ),
                ),
              ],
            ),
          ),
          getDivider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: getTranslatedValue(context, "placed_order_on"),
                        style: TextStyle(
                          color: ColorsRes.mainTextColor,
                        ),
                      ),
                      TextSpan(
                        text: " ${order.date.toString().formatDate()}",
                        style: TextStyle(
                          color: ColorsRes.mainTextColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                if (order.activeStatus!.isNotEmpty)
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: getTranslatedValue(context, "order_is"),
                          style: TextStyle(
                            color: ColorsRes.mainTextColor,
                          ),
                        ),
                        TextSpan(
                          text: " ${Constant.getOrderActiveStatusLabelFromCode(
                            order.activeStatus ?? "",
                            context,
                          )} ",
                          style: TextStyle(
                            color: ColorsRes.mainTextColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        TextSpan(
                          text: getTranslatedValue(context, "on"),
                          style: TextStyle(
                            color: ColorsRes.mainTextColor,
                          ),
                        ),
                        TextSpan(
                          text: " ${getStatusCompleteDate(
                            int.parse(order.activeStatus ?? ""),
                          )}",
                          style: TextStyle(
                            color: ColorsRes.mainTextColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                if (order.activeStatus!.isNotEmpty &&
                    widget.from == "activeOrders")
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: getTranslatedValue(
                              context, "estimate_delivery_date"),
                          style: TextStyle(
                            color: ColorsRes.mainTextColor,
                          ),
                        ),
                        TextSpan(
                          text:
                              " ${estimatedDeliveryDate.toString().formatEstimateDate()}",
                          style: TextStyle(
                            color: ColorsRes.mainTextColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          if (order.activeStatus.toString() != "1") getDivider(),
          if (order.activeStatus.toString() != "1")
            Center(
              child: LayoutBuilder(builder: (context, boxConstraints) {
                return TrackMyOrderButton(
                    status: order.status ?? [],
                    width: boxConstraints.maxWidth * (0.5));
              }),
            )
        ],
      ),
    );
  }

  Widget _buildOrderItemsDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextLabel(
          jsonKey: "items",
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w500,
            color: ColorsRes.mainTextColor,
          ),
        ),
        getSizedBox(
          height: 5,
        ),
        Consumer<CurrentOrderProvider>(
          builder: (context, currentOrderProvider, child) {
            return Column(
              children: List.generate(order.items?.length ?? 0, (index) {
                OrderItem? orderItem = order.items?[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(10),
                  width: context.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Theme.of(context).cardColor),
                  child: LayoutBuilder(builder: (context, boxConstraints) {
                    return Column(
                      children: [
                        Row(
                          children: [
                            ClipRRect(
                              borderRadius: Constant.borderRadius10,
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              child: setNetworkImg(
                                boxFit: BoxFit.cover,
                                image: orderItem?.imageUrl ?? "",
                                width: boxConstraints.maxWidth * (0.25),
                                height: boxConstraints.maxWidth * (0.25),
                              ),
                            ),
                            SizedBox(
                              width: boxConstraints.maxWidth * (0.05),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomTextLabel(
                                    text: orderItem?.productName,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: ColorsRes.mainTextColor,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  CustomTextLabel(
                                    text: "x ${orderItem?.quantity}",
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  CustomTextLabel(
                                    text:
                                        "${orderItem?.measurement} ${orderItem?.unit}",
                                    style: TextStyle(
                                        color: ColorsRes.subTitleMainTextColor),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  CustomTextLabel(
                                    text: orderItem?.price.toString().currency,
                                    style: TextStyle(
                                        color: ColorsRes.appColor,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  orderItem?.cancelStatus ==
                                          Constant.orderStatusCode[6]
                                      ? Column(
                                          children: [
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            _buildCancelItemButton(orderItem!),
                                          ],
                                        )
                                      : const SizedBox(),
                                  (orderItem?.activeStatus ==
                                          Constant.orderStatusCode[7])
                                      ? Column(
                                          children: [
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            CustomTextLabel(
                                              text: Constant
                                                  .getOrderActiveStatusLabelFromCode(
                                                      orderItem?.activeStatus ??
                                                          "",
                                                      context),
                                              style: TextStyle(
                                                  color: ColorsRes.appColorRed),
                                            )
                                          ],
                                        )
                                      : const SizedBox(),
                                  (orderItem?.returnStatus == "1" &&
                                          orderItem?.returnRequested == "1")
                                      ? CustomTextLabel(
                                          jsonKey: "return_requested",
                                          style: TextStyle(
                                              color: ColorsRes.appColorRed),
                                        )
                                      : (orderItem?.returnStatus == "1" &&
                                              orderItem?.returnRequested == "3")
                                          ? Column(
                                              mainAxisSize: MainAxisSize.max,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                CustomTextLabel(
                                                  jsonKey: "return_rejected",
                                                  style: TextStyle(
                                                    color:
                                                        ColorsRes.appColorRed,
                                                  ),
                                                ),
                                                CustomTextLabel(
                                                  text:
                                                      "${getTranslatedValue(context, "return_reason")}: ${orderItem?.returnReason}",
                                                  style: TextStyle(
                                                      color: ColorsRes
                                                          .subTitleMainTextColor),
                                                ),
                                              ],
                                            )
                                          : const SizedBox(),
                                ],
                              ),
                            ),
                          ],
                        ),
                        if (widget.from == "previousOrders")
                          Align(
                            alignment: AlignmentDirectional.centerEnd,
                            child: (orderItem!.itemRating!.isNotEmpty)
                                ? (orderItem.itemRating?.first.rate
                                            .toString() !=
                                        "0")
                                    ? GestureDetector(
                                        onTap: () {
                                          openRatingDialog(
                                            order: order,
                                            index: index,
                                          ).then((value) {
                                            callApi();
                                          });
                                        },
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.star_rate_rounded,
                                              color: Colors.amber,
                                            ),
                                            getSizedBox(width: 5),
                                            CustomTextLabel(
                                              text: orderItem
                                                      .itemRating!.isNotEmpty
                                                  ? orderItem
                                                      .itemRating?.first.rate
                                                  : "0",
                                              style: TextStyle(
                                                color: ColorsRes
                                                    .subTitleMainTextColor,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : gradientBtnWidget(
                                        context,
                                        5,
                                        callback: () {
                                          openRatingDialog(
                                            order: order,
                                            index: index,
                                          ).then((value) {
                                            callApi();
                                          });
                                        },
                                        otherWidgets: CustomTextLabel(
                                          jsonKey: "write_a_review",
                                          style: TextStyle(
                                            color: ColorsRes.appColorWhite,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        height: 30,
                                        width: context.width * 0.30,
                                      )
                                : gradientBtnWidget(
                                    context,
                                    5,
                                    callback: () {
                                      openRatingDialog(
                                              order: order, index: index)
                                          .then((value) {
                                        callApi();
                                      });
                                    },
                                    otherWidgets: CustomTextLabel(
                                      jsonKey: "write_a_review",
                                      style: TextStyle(
                                        color: ColorsRes.appColorWhite,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    height: 30,
                                    width: context.width * 0.30,
                                  ),
                          ),
                        if (widget.from == "previousOrders" &&
                            orderItem?.returnStatus == "1" &&
                            (orderItem?.returnRequested == null ||
                                orderItem?.returnRequested == "null"))
                          getDivider(),
                        if (widget.from == "previousOrders" &&
                            orderItem?.returnStatus == "1" &&
                            (orderItem?.returnRequested == null ||
                                orderItem?.returnRequested == "null"))
                          _buildReturnOrderButton(
                            order: order,
                            orderItemId: orderItem?.id ?? "",
                            width: boxConstraints.maxWidth * (0.5),
                          ),
                        if (widget.from == "activeOrders" &&
                            orderItem?.cancelStatus == "1" &&
                            (orderItem?.returnRequested == null ||
                                orderItem?.returnRequested == "null"))
                          getDivider(),
                        if (widget.from == "activeOrders" &&
                            orderItem?.cancelStatus == "1" &&
                            (orderItem?.returnRequested == null ||
                                orderItem?.returnRequested == "null"))
                          _buildCancelItemButton(
                            orderItem!,
                          ),
                      ],
                    );
                  }),
                );
              }),
            );
          },
        ),
      ],
    );
  }

  Widget _buildDeliveryInformationContainer() {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.only(bottom: 10, top: 10),
      width: context.width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).cardColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: CustomTextLabel(
              jsonKey: "delivery_information",
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
                color: ColorsRes.mainTextColor,
              ),
            ),
          ),
          getDivider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextLabel(
                  jsonKey: widget.from == "previousOrders"
                      ? "delivered_at"
                      : "delivery_to",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: ColorsRes.mainTextColor,
                  ),
                ),
                const SizedBox(
                  height: 2.5,
                ),
                CustomTextLabel(
                  text: order.orderAddress,
                  style: TextStyle(
                    color: ColorsRes.subTitleMainTextColor,
                    fontSize: 13.0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderNoteContainer() {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.only(bottom: 10, top: 10),
      width: context.width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).cardColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: CustomTextLabel(
              jsonKey: "order_note_title",
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
                color: ColorsRes.mainTextColor,
              ),
            ),
          ),
          getDivider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: CustomTextLabel(
              jsonKey: order.orderNote.toString(),
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: ColorsRes.mainTextColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBillDetails() {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.only(bottom: 10, top: 10),
      width: context.width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).cardColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: CustomTextLabel(
              jsonKey: "billing_details",
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
                color: ColorsRes.mainTextColor,
              ),
            ),
          ),
          getDivider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                Row(
                  children: [
                    CustomTextLabel(
                      jsonKey: "payment_method",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: ColorsRes.mainTextColor,
                      ),
                    ),
                    const Spacer(),
                    CustomTextLabel(text: order.paymentMethod),
                  ],
                ),
                SizedBox(
                  height: Constant.size10,
                ),
                order.transactionId!.isEmpty
                    ? const SizedBox()
                    : Column(
                        children: [
                          Row(
                            children: [
                              CustomTextLabel(
                                jsonKey: "transaction_id",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: ColorsRes.mainTextColor,
                                ),
                              ),
                              const Spacer(),
                              CustomTextLabel(
                                text: order.transactionId,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: Constant.size10,
                          ),
                        ],
                      ),
                Row(
                  children: [
                    CustomTextLabel(
                      jsonKey: "subtotal",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: ColorsRes.mainTextColor,
                      ),
                    ),
                    const Spacer(),
                    CustomTextLabel(
                      text: order.total?.currency,
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: ColorsRes.mainTextColor),
                    ),
                  ],
                ),
                SizedBox(
                  height: Constant.size10,
                ),
                Row(
                  children: [
                    CustomTextLabel(
                      jsonKey: "delivery_charge",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: ColorsRes.mainTextColor,
                      ),
                    ),
                    const Spacer(),
                    CustomTextLabel(
                      text: order.deliveryCharge?.currency,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: ColorsRes.mainTextColor,
                      ),
                    ),
                  ],
                ),
                if (double.parse(order.promoDiscount ?? "0.0") > 0.0)
                  SizedBox(
                    height: Constant.size10,
                  ),
                if (double.parse(order.promoDiscount ?? "0.0") > 0.0)
                  Row(
                    children: [
                      CustomTextLabel(
                        text:
                            "${getTranslatedValue(context, "discount")}(${order.promoCode})",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: ColorsRes.mainTextColor,
                        ),
                      ),
                      const Spacer(),
                      CustomTextLabel(
                        text: "-${order.promoDiscount?.currency}",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: ColorsRes.mainTextColor,
                        ),
                      ),
                    ],
                  ),
                if (double.parse(order.walletBalance ?? "0.0") > 0.0)
                  SizedBox(
                    height: Constant.size10,
                  ),
                if (double.parse(order.walletBalance ?? "0.0") > 0.0)
                  Row(
                    children: [
                      CustomTextLabel(
                        text: "${getTranslatedValue(context, "wallet")}",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: ColorsRes.mainTextColor,
                        ),
                      ),
                      const Spacer(),
                      CustomTextLabel(
                        text: "-${order.walletBalance?.currency}",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: ColorsRes.mainTextColor,
                        ),
                      ),
                    ],
                  ),
                SizedBox(
                  height: Constant.size10,
                ),
                Row(
                  children: [
                    CustomTextLabel(
                      jsonKey: "total",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: ColorsRes.mainTextColor,
                      ),
                    ),
                    const Spacer(),
                    CustomTextLabel(
                      text: order.finalTotal?.currency,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: ColorsRes.appColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
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
          Navigator.pop(context, order);
        }
      },
      child: Scaffold(
        appBar: getAppBar(
            context: context,
            title: CustomTextLabel(
              jsonKey: "order_summary",
              style: TextStyle(color: ColorsRes.mainTextColor),
            )),
        body: Consumer<CurrentOrderProvider>(
          builder: (context, currentOrderProvider, child) {
            if (currentOrderProvider.currentOrderState ==
                    CurrentOrderState.loaded ||
                currentOrderProvider.currentOrderState ==
                    CurrentOrderState.silentLoading) {
              estimatedDeliveryDate =
                  DateTime.parse(order.createdAt.toString());

              estimatedDeliveryDate
                  .add(Duration(days: Constant.estimateDeliveryDays));

              return Stack(
                children: [
                  PositionedDirectional(
                    start: 0,
                    end: 0,
                    top: 0,
                    bottom: 0,
                    child: SingleChildScrollView(
                      padding: EdgeInsetsDirectional.only(
                          top: Constant.size10,
                          start: Constant.size10,
                          end: Constant.size10,
                          bottom: Constant.size65),
                      child: Column(
                        children: [
                          _buildOrderStatusContainer(),
                          _buildOrderItemsDetails(),
                          if (order.orderNote.toString().isNotEmpty)
                            _buildOrderNoteContainer(),
                          _buildDeliveryInformationContainer(),
                          _buildBillDetails()
                        ],
                      ),
                    ),
                  ),
                  if (order.activeStatus.toString() == "6")
                    PositionedDirectional(
                      bottom: 10,
                      start: 10,
                      end: 10,
                      child: Consumer<OrderInvoiceProvider>(
                        builder: (context, orderInvoiceProvider, child) {
                          return gradientBtnWidget(
                            context,
                            10,
                            callback: () {
                              orderInvoiceProvider.getOrderInvoiceApiProvider(
                                params: {
                                  ApiAndParams.orderId: order.id.toString()
                                },
                                context: context,
                              ).then(
                                (htmlContent) async {
                                  try {
                                    if (htmlContent != null) {
                                      final appDocDirPath = io
                                              .Platform.isAndroid
                                          ? (await ExternalPath
                                              .getExternalStoragePublicDirectory(
                                                  ExternalPath
                                                      .DIRECTORY_DOWNLOADS))
                                          : (await getApplicationDocumentsDirectory())
                                              .path;

                                      final targetFileName =
                                          "${getTranslatedValue(context, "app_name")}-${getTranslatedValue(context, "invoice")}#${order.id.toString()}.pdf";

                                      io.File file = io.File(
                                          "$appDocDirPath/$targetFileName");

                                      // Write down the file as bytes from the bytes got from the HTTP request.
                                      await file.writeAsBytes(htmlContent,
                                          flush: false);
                                      await file.writeAsBytes(htmlContent);

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        action: SnackBarAction(
                                          label: getTranslatedValue(
                                              context, "show_file"),
                                          onPressed: () {
                                            OpenFilex.open(file.path);
                                          },
                                        ),
                                        content: CustomTextLabel(
                                          jsonKey: "file_saved_successfully",
                                          softWrap: true,
                                          style: TextStyle(
                                              color: ColorsRes.mainTextColor),
                                        ),
                                        duration: const Duration(seconds: 5),
                                        backgroundColor: Theme.of(context)
                                            .scaffoldBackgroundColor,
                                      ));
                                    }
                                  } catch (_) {}
                                },
                              );
                            },
                            otherWidgets:
                                orderInvoiceProvider.orderInvoiceState ==
                                        OrderInvoiceState.loading
                                    ? Center(
                                        child: CircularProgressIndicator(
                                          color: ColorsRes.appColorWhite,
                                        ),
                                      )
                                    : CustomTextLabel(
                                        jsonKey: "get_Invoice",
                                        softWrap: true,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium!
                                            .merge(
                                              TextStyle(
                                                color: ColorsRes.appColorWhite,
                                                letterSpacing: 0.5,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                      ),
                          );
                        },
                      ),
                    ),
                ],
              );
            } else if (currentOrderProvider.currentOrderState ==
                CurrentOrderState.loading) {
              return ListView(
                children: [
                  CustomShimmer(
                    height: 160,
                    width: context.width,
                    borderRadius: 10,
                    margin: EdgeInsetsDirectional.only(
                      top: 10,
                      start: 10,
                      end: 10,
                    ),
                  ),
                  CustomShimmer(
                    height: 120,
                    width: context.width,
                    borderRadius: 10,
                    margin: EdgeInsetsDirectional.only(
                      top: 10,
                      start: 10,
                      end: 10,
                    ),
                  ),
                  CustomShimmer(
                    height: 120,
                    width: context.width,
                    borderRadius: 10,
                    margin: EdgeInsetsDirectional.only(
                      top: 10,
                      start: 10,
                      end: 10,
                    ),
                  ),
                  CustomShimmer(
                    height: 120,
                    width: context.width,
                    borderRadius: 10,
                    margin: EdgeInsetsDirectional.only(
                      top: 10,
                      start: 10,
                      end: 10,
                    ),
                  ),
                  CustomShimmer(
                    height: 120,
                    width: context.width,
                    borderRadius: 10,
                    margin: EdgeInsetsDirectional.only(
                      top: 10,
                      start: 10,
                      end: 10,
                    ),
                  ),
                  CustomShimmer(
                    height: 120,
                    width: context.width,
                    borderRadius: 10,
                    margin: EdgeInsetsDirectional.only(
                      top: 10,
                      start: 10,
                      end: 10,
                    ),
                  ),
                  CustomShimmer(
                    height: 120,
                    width: context.width,
                    borderRadius: 10,
                    margin: EdgeInsetsDirectional.only(
                      top: 10,
                      start: 10,
                      end: 10,
                    ),
                  ),
                ],
              );
            } else {
              return Container(
                alignment: Alignment.center,
                height: context.height,
                width: context.width,
                child: DefaultBlankItemMessageScreen(
                  height: context.height,
                  image: "something_went_wrong",
                  title: getTranslatedValue(
                      context, "something_went_wrong_message_title"),
                  description: getTranslatedValue(
                      context, "something_went_wrong_message_description"),
                  buttonTitle: getTranslatedValue(context, "try_again"),
                  callback: () async {
                    callApi();
                  },
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Future openRatingDialog({required Order order, required int index}) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      constraints: BoxConstraints(maxHeight: context.height * 0.7),
      shape: DesignConfig.setRoundedBorderSpecific(20, istop: true),
      backgroundColor: Theme.of(context).cardColor,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            constraints: BoxConstraints(
              minHeight: context.height * 0.5,
            ),
            padding: EdgeInsetsDirectional.only(
                start: Constant.size15,
                end: Constant.size15,
                top: Constant.size15,
                bottom: Constant.size15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: defaultImg(
                            image: "ic_arrow_back",
                            iconColor: ColorsRes.mainTextColor,
                            height: 15,
                            width: 15,
                          ),
                        ),
                      ),
                      CustomTextLabel(
                        jsonKey: "ratings",
                        softWrap: true,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleMedium!.merge(
                              TextStyle(
                                letterSpacing: 0.5,
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                                color: ColorsRes.mainTextColor,
                              ),
                            ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: getSizedBox(
                          height: 15,
                          width: 15,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: MultiProvider(
                    providers: [
                      ChangeNotifierProvider<RatingListProvider>(
                        create: (BuildContext context) {
                          return RatingListProvider();
                        },
                      )
                    ],
                    child: SubmitRatingWidget(
                      size: 100,
                      order: order,
                      itemIndex: index,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
