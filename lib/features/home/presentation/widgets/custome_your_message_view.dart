import 'package:find_missing_test/core/models/message_model.dart';
import 'package:find_missing_test/core/utils/app_color.dart';
import 'package:find_missing_test/core/utils/app_styles.dart';
import 'package:flutter/material.dart';

class CustomeYourMessage extends StatelessWidget {
  final MessageModel messageModel;
  const CustomeYourMessage({super.key, required this.messageModel});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerEnd,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: const BoxDecoration(
            color: AppColor.kDarkGreyColor,
            borderRadius: BorderRadiusDirectional.only(
              bottomStart: Radius.circular(12),
              topEnd: Radius.circular(12),
              topStart: Radius.circular(12),
            ),
          ),
          child: Text(
            messageModel.message!,
            style: AppStyles.input.copyWith(
              fontSize: 14,
              color: AppColor.kBackGroundColor,
            ),
          ),
        ),
      ),
    );
  }
}
