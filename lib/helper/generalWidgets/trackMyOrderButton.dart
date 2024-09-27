import 'package:egrocer/helper/utils/generalImports.dart';

class TrackMyOrderButton extends StatelessWidget {
  final double width;
  final List<List<dynamic>> status;

  const TrackMyOrderButton(
      {Key? key, required this.status, required this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (status.isNotEmpty) {
          showModalBottomSheet(
            backgroundColor: Theme.of(context).cardColor,
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
            context: context,
            builder: (context) {
              return OrderTrackingHistoryBottomSheet(
                listOfStatus: status,
              );
            },
          );
        } else {
          showMessage(
              context,
              getTranslatedValue(context, "something_went_wrong"),
              MessageType.warning);
        }
      },
      child: Container(
        alignment: Alignment.center,
        width: width,
        child: CustomTextLabel(
          jsonKey: "track_my_order",
          softWrap: true,
          style: TextStyle(color: ColorsRes.appColor),
        ),
      ),
    );
  }
}
