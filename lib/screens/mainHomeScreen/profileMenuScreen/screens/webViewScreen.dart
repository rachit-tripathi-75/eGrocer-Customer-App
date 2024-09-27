import 'package:egrocer/helper/utils/generalImports.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class WebViewScreen extends StatefulWidget {
  final String dataFor;

  const WebViewScreen({Key? key, required this.dataFor}) : super(key: key);

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  bool privacyPolicyExpanded = false;
  bool returnExchangePolicyExpanded = false;
  bool shippingPolicyExpanded = false;
  bool cancellationPolicyExpanded = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero).then((value) {});
  }

  @override
  Widget build(BuildContext context) {
    String htmlContent = "";
    if (widget.dataFor ==
        getTranslatedValue(
          context,
          "contact_us",
        )) {
      htmlContent = Constant.contactUs;
    } else if (widget.dataFor ==
        getTranslatedValue(
          context,
          "about_us",
        )) {
      htmlContent = Constant.aboutUs;
    } else if (widget.dataFor ==
        getTranslatedValue(
          context,
          "terms_and_conditions",
        )) {
      htmlContent = Constant.termsConditions;
    } else if (widget.dataFor ==
        getTranslatedValue(
          context,
          "privacy_policy",
        )) {
      htmlContent = Constant.privacyPolicy;
    }

    return Scaffold(
      appBar: getAppBar(
          title: CustomTextLabel(
            text: widget.dataFor,
            style: TextStyle(color: ColorsRes.mainTextColor),
          ),
          context: context),
      body: SingleChildScrollView(
        child: widget.dataFor ==
                getTranslatedValue(
                  context,
                  "policies",
                )
            ? Column(
                children: [
                  Container(
                    margin: EdgeInsetsDirectional.only(
                      start: 10,
                      end: 10,
                      bottom: 10,
                      top: 10,
                    ),
                    decoration: DesignConfig.boxDecoration(
                      Theme.of(context).cardColor,
                      10,
                    ),
                    child: ExpansionTile(
                      collapsedShape: ShapeBorder.lerp(
                          InputBorder.none, InputBorder.none, 0),
                      shape: ShapeBorder.lerp(
                          InputBorder.none, InputBorder.none, 0),
                      initiallyExpanded: privacyPolicyExpanded,
                      onExpansionChanged: (bool expanded) {
                        setState(() => privacyPolicyExpanded = expanded);
                      },
                      title: CustomTextLabel(
                        jsonKey: "privacy_policy",
                        style: TextStyle(color: ColorsRes.mainTextColor),
                      ),
                      trailing: Icon(
                        privacyPolicyExpanded ? Icons.remove : Icons.add,
                        color: ColorsRes.mainTextColor,
                      ),
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.only(
                              start: Constant.size30,
                              top: Constant.size5,
                              bottom: Constant.size10,
                              end: Constant.size10),
                          child: _getHtmlContainer(Constant.privacyPolicy),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsetsDirectional.only(
                      start: 10,
                      end: 10,
                      bottom: 10,
                    ),
                    decoration: DesignConfig.boxDecoration(
                      Theme.of(context).cardColor,
                      10,
                    ),
                    child: ExpansionTile(
                      collapsedShape: ShapeBorder.lerp(
                          InputBorder.none, InputBorder.none, 0),
                      shape: ShapeBorder.lerp(
                          InputBorder.none, InputBorder.none, 0),
                      initiallyExpanded: returnExchangePolicyExpanded,
                      onExpansionChanged: (bool expanded) {
                        setState(() => returnExchangePolicyExpanded = expanded);
                      },
                      title: CustomTextLabel(
                        jsonKey: "return_and_exchanges_policy",
                        style: TextStyle(color: ColorsRes.mainTextColor),
                      ),
                      trailing: Icon(
                        returnExchangePolicyExpanded ? Icons.remove : Icons.add,
                        color: ColorsRes.mainTextColor,
                      ),
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.only(
                              start: Constant.size30,
                              top: Constant.size5,
                              bottom: Constant.size10,
                              end: Constant.size10),
                          child: _getHtmlContainer(
                              Constant.returnAndExchangesPolicy),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsetsDirectional.only(
                      start: 10,
                      end: 10,
                      bottom: 10,
                    ),
                    decoration: DesignConfig.boxDecoration(
                      Theme.of(context).cardColor,
                      10,
                    ),
                    child: ExpansionTile(
                      collapsedShape: ShapeBorder.lerp(
                          InputBorder.none, InputBorder.none, 0),
                      shape: ShapeBorder.lerp(
                          InputBorder.none, InputBorder.none, 0),
                      initiallyExpanded: shippingPolicyExpanded,
                      onExpansionChanged: (bool expanded) {
                        setState(() => shippingPolicyExpanded = expanded);
                      },
                      title: CustomTextLabel(
                        jsonKey: "shopping_policy",
                        style: TextStyle(color: ColorsRes.mainTextColor),
                      ),
                      trailing: Icon(
                        shippingPolicyExpanded ? Icons.remove : Icons.add,
                        color: ColorsRes.mainTextColor,
                      ),
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.only(
                              start: Constant.size30,
                              top: Constant.size5,
                              bottom: Constant.size10,
                              end: Constant.size10),
                          child: _getHtmlContainer(Constant.shippingPolicy),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsetsDirectional.only(
                      start: 10,
                      end: 10,
                      bottom: 10,
                    ),
                    decoration: DesignConfig.boxDecoration(
                      Theme.of(context).cardColor,
                      10,
                    ),
                    child: ExpansionTile(
                      collapsedShape: ShapeBorder.lerp(
                          InputBorder.none, InputBorder.none, 0),
                      shape: ShapeBorder.lerp(
                          InputBorder.none, InputBorder.none, 0),
                      initiallyExpanded: cancellationPolicyExpanded,
                      onExpansionChanged: (bool expanded) {
                        setState(() => cancellationPolicyExpanded = expanded);
                      },
                      title: CustomTextLabel(
                        jsonKey: "cancellation_policy",
                        style: TextStyle(color: ColorsRes.mainTextColor),
                      ),
                      trailing: Icon(
                        cancellationPolicyExpanded ? Icons.remove : Icons.add,
                        color: ColorsRes.mainTextColor,
                      ),
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.only(
                              start: Constant.size30,
                              top: Constant.size5,
                              bottom: Constant.size10,
                              end: Constant.size10),
                          child: _getHtmlContainer(Constant.cancellationPolicy),
                        )
                      ],
                    ),
                  ),
                ],
              )
            : Padding(
                padding: EdgeInsets.all(Constant.size10),
                child: _getHtmlContainer(htmlContent),
              ),
      ),
    );
  }

  Widget _getHtmlContainer(String htmlContent) {
    return HtmlWidget(
      htmlContent,
      enableCaching: true,
      textStyle: TextStyle(
        color: ColorsRes.mainTextColor,
      ),
    );
  }
}
