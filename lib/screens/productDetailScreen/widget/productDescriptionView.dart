import 'package:egrocer/helper/utils/generalImports.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class ProductDescriptionView extends StatelessWidget {
  final ProductData product;
  final BuildContext context;

  const ProductDescriptionView(
      {Key? key, required this.context, required this.product})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        HtmlWidget(
          product.description,
          enableCaching: true,
          renderMode: RenderMode.column,
          buildAsync: false,
          textStyle: TextStyle(
            color: ColorsRes.mainTextColor,
            decoration: TextDecoration.none,
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  getHtmlWidget() {
    return HtmlWidget(
      product.description,
      enableCaching: true,
      renderMode: RenderMode.column,
      buildAsync: false,
      textStyle: TextStyle(color: ColorsRes.mainTextColor),
    );
  }
}
