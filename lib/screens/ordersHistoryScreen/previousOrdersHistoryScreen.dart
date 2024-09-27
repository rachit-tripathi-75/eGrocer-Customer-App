import 'package:egrocer/helper/utils/generalImports.dart';

class PreviousOrdersHistoryScreen extends StatefulWidget {
  const PreviousOrdersHistoryScreen({Key? key}) : super(key: key);

  @override
  State<PreviousOrdersHistoryScreen> createState() =>
      _PreviousOrdersHistoryScreenState();
}

class _PreviousOrdersHistoryScreenState
    extends State<PreviousOrdersHistoryScreen> with TickerProviderStateMixin {
  late ScrollController scrollController = ScrollController()
    ..addListener(scrollListener);

  scrollListener() {
    // nextPageTrigger will have a value equivalent to 70% of the list size.
    var nextPageTrigger = 0.7 * scrollController.position.maxScrollExtent;

// _scrollController fetches the next paginated data when the current position of the user on the screen has surpassed
    if (scrollController.position.pixels > nextPageTrigger) {
      if (mounted) {
        if (context.read<PreviousOrdersProvider>().hasMoreData) {
          context
              .read<PreviousOrdersProvider>()
              .getOrders(params: {}, context: context);
        }
      }
    }
  }

  @override
  void dispose() {
    scrollController.removeListener(scrollListener);
    scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      context.read<PreviousOrdersProvider>().getOrders(
          params: {ApiAndParams.type: ApiAndParams.previous}, context: context);
    });
  }

  String getOrderedItemNames(List<OrderItem> orderItems) {
    String itemNames = "";
    for (var i = 0; i < orderItems.length; i++) {
      if (i == orderItems.length - 1) {
        itemNames = itemNames + orderItems[i].productName.toString();
      } else {
        itemNames = "${orderItems[i].productName}, ";
      }
    }
    return itemNames;
  }

  Widget _buildOrderDetailsContainer(Order order) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, orderDetailScreen,
            arguments: [order.id, "previousOrders"]).then((value) {
          if (value != null) {
            context.read<ActiveOrdersProvider>().updateOrder(value as Order);
          }
        });
      },
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Constant.size10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CustomTextLabel(
                      text: "${getTranslatedValue(
                        context,
                        "order",
                      )} #${order.id}",
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: ColorsRes.mainTextColor),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, orderDetailScreen,
                                arguments: [order.id, "previousOrders"])
                            .then((value) {
                          if (value != null) {
                            context
                                .read<ActiveOrdersProvider>()
                                .updateOrder(value as Order);
                          }
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.transparent)),
                        padding: const EdgeInsets.symmetric(vertical: 2.5),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CustomTextLabel(
                              jsonKey: "view_details",
                              style: TextStyle(
                                  fontSize: 12.0,
                                  color: ColorsRes.subTitleMainTextColor),
                            ),
                            const SizedBox(
                              width: 5.0,
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 12.0,
                              color: ColorsRes.subTitleMainTextColor,
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                getDivider(),
                CustomTextLabel(
                  text: "${getTranslatedValue(
                    context,
                    "placed_order_on",
                  )} ${order.date.toString().formatDate()}",
                  style: TextStyle(
                      fontSize: 12.5, color: ColorsRes.subTitleMainTextColor),
                ),
                const SizedBox(
                  height: 5.0,
                ),
                CustomTextLabel(
                  text: getOrderedItemNames(order.items ?? []),
                  style: TextStyle(
                    fontSize: 12.5,
                    color: ColorsRes.mainTextColor,
                  ),
                ),
              ],
            ),
          ),
          getDivider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: [
                Expanded(
                  child: CustomTextLabel(
                    jsonKey: "total",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: ColorsRes.mainTextColor,
                    ),
                  ),
                ),
                CustomTextLabel(
                  text: order.finalTotal?.currency,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: ColorsRes.mainTextColor,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderContainer(Order order) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, orderDetailScreen,
            arguments: [order.id, "previousOrders"]).then((value) {
          if (value != null) {
            context.read<ActiveOrdersProvider>().updateOrder(value as Order);
          }
        });
      },
      child: Container(
        margin: EdgeInsets.only(bottom: Constant.size10),
        decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(10)),
        width: context.width,
        padding: EdgeInsets.symmetric(vertical: Constant.size5),
        child: Column(
          children: [
            _buildOrderDetailsContainer(order),
          ],
        ),
      ),
    );
  }

  Widget _buildOrders() {
    return Consumer<PreviousOrdersProvider>(
      builder: (context, provider, _) {
        if (provider.previousOrdersState == PreviousOrdersState.loaded ||
            provider.previousOrdersState == PreviousOrdersState.loadingMore) {
          return setRefreshIndicator(
              refreshCallback: () async {
                context.read<PreviousOrdersProvider>().orders.clear();
                context.read<PreviousOrdersProvider>().offset = 0;
                context
                    .read<PreviousOrdersProvider>()
                    .getOrders(params: {}, context: context);
              },
              child: ListView(
                padding: EdgeInsets.symmetric(
                  horizontal: Constant.size10,
                  vertical: Constant.size10,
                ),
                controller: scrollController,
                shrinkWrap: true,
                children: [
                  Column(
                    children: List.generate(
                      provider.orders.length,
                      (index) => _buildOrderContainer(
                        provider.orders[index],
                      ),
                    ),
                  ),
                  if (provider.previousOrdersState ==
                      PreviousOrdersState.loadingMore)
                    _buildOrderContainerShimmer(),
                ],
              ));
        }
        if (provider.previousOrdersState == PreviousOrdersState.empty) {
          return Container(
            alignment: Alignment.center,
            height: context.height,
            width: context.width,
            child: DefaultBlankItemMessageScreen(
              image: "no_order_icon",
              title: "empty_previous_orders_message",
              description: "empty_previous_orders_description",
              buttonTitle: "go_back",
              callback: () {
                Navigator.pop(context);
              },
            ),
          );
        }
        if (provider.previousOrdersState == PreviousOrdersState.error) {
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
                await context.read<ActiveOrdersProvider>().getOrders(
                    params: {ApiAndParams.type: ApiAndParams.previous},
                    context: context);
              },
            ),
          );
        }
        return _buildOrdersHistoryShimmer();
      },
    );
  }

  Widget _buildOrderContainerShimmer() {
    return CustomShimmer(
      height: 140,
      width: context.width,
      margin: const EdgeInsetsDirectional.only(top: 10),
    );
  }

  Widget _buildOrdersHistoryShimmer() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(10, (index) => index)
              .map((e) => _buildOrderContainerShimmer())
              .toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildOrders(),
    );
  }
}
