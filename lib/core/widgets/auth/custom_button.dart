import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final List<Color> backColor;

  final List<Color> textColor;
  final GestureTapCallback onPressed;

  const CustomButton({
    Key? key,
    required this.text,
    required this.backColor,
    required this.textColor,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Shader textGradient = LinearGradient(
      colors: <Color>[textColor[0], textColor[1]],
    ).createShader(
      const Rect.fromLTWH(
        0.0,
        0.0,
        200.0,
        70.0,
      ),
    );
    var size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height * 0.07,
      width: size.width * 1,
      child: InkWell(
        onTap: onPressed,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(36.0),
            gradient: LinearGradient(
              stops: const [0.4, 2],
              begin: Alignment.centerRight,
              end: Alignment.centerLeft,
              colors: backColor,
            ),
          ),
          child: Align(
            child: Text(
              text,
              style: TextStyle(
                foreground: Paint()..shader = textGradient,
                fontWeight: FontWeight.bold,
                fontSize: size.height * 0.03,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// import 'package:find_missing_test/core/utils/app_router.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';

// import '../../utils/app_color.dart';

// class CustomButton extends StatelessWidget {
//   const CustomButton({super.key, required this.onTab, required this.text});

//   final String text;
//   final Function() onTab;

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onTab,
//       child: Container(
//         width: double.infinity,
//         height: 60,
//         decoration: BoxDecoration(
//           border: Border.all(color: AppColor.kPrimaryColor),
//           gradient: const LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [
//               AppColor.kSecondaryColor,
//               AppColor.kPrimaryColor,
//               AppColor.kThirdColor,
//             ],
//           ),
//           borderRadius: BorderRadius.circular(6),
//         ),
//         child: Center(
//           child: Text(
//             text,
//             style: const TextStyle(
//                 color: AppColor.kBackGroundColor,
//                 fontWeight: FontWeight.bold,
//                 fontSize: 24),
//           ),
//         ),
//       ),
//     );
//   }
// }
