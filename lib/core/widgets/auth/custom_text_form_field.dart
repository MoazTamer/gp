import 'package:flutter/material.dart';

import '../../utils/app_color.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    required this.prefixIcon,
    required this.hintText,
    this.isPassword = false,
    required this.type,
    required this.min,
    required this.max,
    required this.controller,
    required this.onChanged,
    this.enbale = true,
    this.lines = 1,
    this.intialValue = '',
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    // required this.valid,
  });

  final int? lines;
  final bool? enbale;
  final IconData? prefixIcon;
  final String? hintText;
  final bool isPassword;
  final TextInputType type;
  final int min, max;
  final TextEditingController controller;
  final Function(String?) onChanged;
  final String? intialValue;
  final AutovalidateMode autovalidateMode;
  // final String? Function(String?) valid;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: TextFormField(
        enabled: enbale,
        maxLines: lines,
        obscureText: isPassword,
        keyboardType: type,
        onChanged: onChanged,
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please Enter Your $hintText';
          }
          if (value.length < min) {
            return 'Please Enter Valid $hintText';
          }
          if (value.length > max) {
            return '$hintText must be smaller than $max characters';
          }
          return null;
        },
        cursorColor: AppColor.kGreyColor,
        initialValue: intialValue,
        autovalidateMode: autovalidateMode,
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: Icon(prefixIcon),
          prefixIconColor: AppColor.kBlackGreyColor,
          filled: true,
          fillColor: AppColor.kWhiteGreyColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(36),
            borderSide: const BorderSide(color: AppColor.kWhiteGreyColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(36),
            borderSide: const BorderSide(color: AppColor.kWhiteGreyColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(36),
            borderSide: const BorderSide(color: AppColor.kWhiteGreyColor),
          ),
        ),
      ),
    );
  }
}
