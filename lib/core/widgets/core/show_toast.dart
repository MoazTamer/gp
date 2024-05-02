import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../utils/app_color.dart';

void showToast(
    {required BuildContext context, required String msg, required bool done}) {
  Color backgroundColor;
  if (done) {
    backgroundColor = AppColor.kGreyColor;
  } else {
    backgroundColor = AppColor.kDRedColor;
  }
  Fluttertoast.showToast(
    msg: msg,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: backgroundColor,
    textColor: Colors.white,
    fontSize: 16.0,
  );
}
