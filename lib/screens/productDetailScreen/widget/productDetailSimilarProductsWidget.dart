import 'package:egrocer/helper/utils/generalImports.dart';

class ProductDetailSimilarProductsWidget extends StatelessWidget {
  final List<ProductListItem> similarProducts;

  ProductDetailSimilarProductsWidget({
    super.key,
    required this.similarProducts,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        constraints: BoxConstraints(minWidth: context.width),
        alignment: AlignmentDirectional.centerStart,
        padding: EdgeInsetsDirectional.symmetric(horizontal: 5),
        child: Row(
          children: List.generate(similarProducts.length, (index) {
            ProductListItem product = similarProducts[index];
            return HomeScreenProductListItem(
              product: product,
              position: index,
            );
          }),
        ),
      ),
    );
  }
}
