import 'package:egrocer/helper/utils/generalImports.dart';

class SocialMediaLoginButtonWidget extends StatelessWidget {
  final String text;
  final String logo;
  final VoidCallback onPressed;
  final Color? logoColor;

  const SocialMediaLoginButtonWidget({
    super.key,
    required this.text,
    required this.logo,
    required this.onPressed,
    this.logoColor,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          defaultImg(image: logo, width: 24,iconColor: logoColor),
          getSizedBox(width: 10),
          CustomTextLabel(
            jsonKey: text,
            style: TextStyle(
              color: ColorsRes.mainTextColor,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
