import 'package:egrocer/helper/utils/generalImports.dart';

class CategoryListScreen extends StatefulWidget {
  final ScrollController scrollController;
  final String? categoryName;
  final String? categoryId;

  const CategoryListScreen({
    Key? key,
    required this.scrollController,
    this.categoryName,
    this.categoryId,
  }) : super(key: key);

  @override
  State<CategoryListScreen> createState() => _CategoryListScreenState();
}

class _CategoryListScreenState extends State<CategoryListScreen> {
  ScrollController scrollController = ScrollController();

  scrollListener() {
    // nextPageTrigger will have a value equivalent to 70% of the list size.
    var nextPageTrigger = 0.7 * scrollController.position.maxScrollExtent;

// _scrollController fetches the next paginated data when the current position of the user on the screen has surpassed
    if (scrollController.position.pixels > nextPageTrigger) {
      if (mounted) {
        if (context.read<CategoryListProvider>().hasMoreData) {
          callApi(false);
        }
      }
    }
  }

  @override
  void initState() {
    scrollController.addListener(scrollListener);
    super.initState();
    //fetch categoryList from api
    Future.delayed(Duration.zero).then((value) async {
      await callApi(true);
    });
  }

  callApi(bool isReset) {
    if (isReset == true) {
      context.read<CategoryListProvider>().offset = 0;
      context.read<CategoryListProvider>().categories.clear();
    }
    return context
        .read<CategoryListProvider>()
        .getCategoryApiProvider(context: context, params: {
      ApiAndParams.categoryId:
          widget.categoryId == null ? "0" : widget.categoryId.toString()
    });
  }

  @override
  dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(
        context: context,
        centerTitle: true,
        title: Padding(
          padding: EdgeInsetsDirectional.only(start: 15),
          child: CustomTextLabel(
            text: widget.categoryName == null
                ? getTranslatedValue(context, "categories")
                : widget.categoryName.toString(),
            style: TextStyle(color: ColorsRes.mainTextColor),
          ),
        ),
        actions: [
          setNotificationIcon(context: context),
          setCartCounter(context: context),
        ],
        showBackButton: false,
      ),
      body: setRefreshIndicator(
        refreshCallback: () async {
          await callApi(true);
        },
        child: Column(
          children: [
            getSearchWidget(context: context),
            Expanded(
              child: ListView(
                controller: scrollController,
                children: [
                  categoryWidget(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

// categoryList ui
  Widget categoryWidget() {
    return Consumer<CategoryListProvider>(
      builder: (context, categoryListProvider, _) {
        if (categoryListProvider.categoryState == CategoryState.loaded ||
            categoryListProvider.categoryState == CategoryState.loadingMore) {
          return GridView.builder(
            itemCount: categoryListProvider.categories.length,
            padding: EdgeInsets.symmetric(
                horizontal: Constant.size10, vertical: Constant.size10),
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            // Disable GridView scrolling
            itemBuilder: (BuildContext context, int index) {
              CategoryItem category = categoryListProvider.categories[index];

              return CategoryItemContainer(
                category: category,
                voidCallBack: () {
                  if (category.hasChild!) {
                    Navigator.pushNamed(context, categoryListScreen,
                        arguments: [
                          ScrollController(),
                          category.name,
                          category.id.toString()
                        ]);
                  } else {
                    Navigator.pushNamed(context, productListScreen, arguments: [
                      "category",
                      category.id.toString(),
                      category.name
                    ]);
                  }
                },
              );
            },
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 0.8,
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10),
          );
        } else if (categoryListProvider.categoryState ==
            CategoryState.loading) {
          return getCategoryShimmer(context: context, count: 9);
        } else {
          return NoInternetConnectionScreen(
            height: context.height * 0.65,
            message: categoryListProvider.message,
            callback: () {
              callApi(true);
            },
          );
        }
      },
    );
  }
}
