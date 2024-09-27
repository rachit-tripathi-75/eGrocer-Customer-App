import 'package:egrocer/helper/utils/generalImports.dart';

class ProductListRatingBuilderWidget extends StatelessWidget {
  final double averageRating;
  final int totalRatings;
  final double? size;
  final double? spacing;
  final double? fontSize;

  ProductListRatingBuilderWidget({
    super.key,
    required this.averageRating,
    required this.totalRatings,
    this.size,
    this.spacing,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return totalRatings != 0
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsetsDirectional.all(5),
                decoration: BoxDecoration(
                    color: Theme.of(context)
                        .scaffoldBackgroundColor
                        .withOpacity(0.85),
                    borderRadius: BorderRadius.circular(7)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    getSizedBox(width: 5),
                    CustomTextLabel(
                      text: "$averageRating",
                      style: TextStyle(
                        color: ColorsRes.mainTextColor,
                        fontSize: fontSize ?? 13,
                      ),
                    ),
                    getSizedBox(width: 5),
                    defaultImg(
                      image: "rate_icon",
                      iconColor: ColorsRes.activeRatingColor,
                      height: size,
                      width: size,
                      padding: EdgeInsetsDirectional.only(end: spacing ?? 0),
                    ),
                    getSizedBox(width: 5),
                    CustomTextLabel(
                      text: "|",
                      style: TextStyle(
                        color: ColorsRes.subTitleMainTextColor,
                        fontSize: fontSize ?? 13,
                      ),
                    ),
                    getSizedBox(width: 5),
                    CustomTextLabel(
                      text: "${totalRatings}",
                      style: TextStyle(
                        color: ColorsRes.mainTextColor,
                        fontSize: fontSize ?? 13,
                      ),
                    ),
                    getSizedBox(width: 5),
                  ],
                ),
              ),
            ],
          )
        : SizedBox.shrink();
  }
}
