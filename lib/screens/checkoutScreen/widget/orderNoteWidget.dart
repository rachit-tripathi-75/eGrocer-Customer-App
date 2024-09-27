import 'package:egrocer/helper/utils/generalImports.dart';

class OrderNoteWidget extends StatelessWidget {
  final TextEditingController edtOrderNote;

  OrderNoteWidget({super.key, required this.edtOrderNote});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: DesignConfig.boxDecoration(Theme.of(context).cardColor, 10),
      padding: const EdgeInsets.all(10),
      margin: EdgeInsetsDirectional.only(
        start: 10,
        end: 10,
      ),
      child: Padding(
        padding: EdgeInsetsDirectional.only(
          start: Constant.size10,
          end: Constant.size10,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextLabel(
              jsonKey: "order_note",
              softWrap: true,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: ColorsRes.mainTextColor,
              ),
            ),
            getSizedBox(
              height: 10,
            ),
            editBoxWidget(
              context,
              edtOrderNote,
              optionalValidation,
              getTranslatedValue(
                context,
                "order_note_hint",
              ),
              "",
              TextInputType.multiline,
              maxLength: 191,
              maxLines: 3,
              minLines: 1,
              floatingLabelBehavior: FloatingLabelBehavior.never,
            ),
          ],
        ),
      ),
    );
  }
}
