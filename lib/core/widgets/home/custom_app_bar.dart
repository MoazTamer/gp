import 'package:flutter/material.dart';

import '../../utils/app_color.dart';
import '../../utils/app_styles.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: AppBar(
        title: Text(title),
        centerTitle: true,
        titleTextStyle: AppStyles.appBar,
        iconTheme:
            const IconThemeData(color: AppColor.kBackGroundColor, size: 28),
        shape: const OutlineInputBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(48)),
          borderSide: BorderSide(width: 0, color: AppColor.kPrimaryColor),
        ),
        backgroundColor: AppColor.kPrimaryColor,
        elevation: 0,
      ),
    );
  }
}
