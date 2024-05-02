import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';

import '../../../../core/utils/app_color.dart';
import 'package:find_missing_test/features/auth/data/cubit/auth_cubit.dart';

class OtpDetails extends StatelessWidget {
  const OtpDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final authCubit = context.read<AuthCubit>();

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0),
        child: OTPTextField(
          length: 6,
          width: MediaQuery.of(context).size.width / 1.2,
          textFieldAlignment: MainAxisAlignment.spaceBetween,
          fieldWidth: MediaQuery.of(context).size.width / 9,
          fieldStyle: FieldStyle.box,
          outlineBorderRadius: 12,
          style: const TextStyle(fontSize: 18, color: AppColor.kPrimaryColor),
          onCompleted: (pin) {
            print("Completed: $pin");
            authCubit.pin = pin;
          },
          onChanged: (pin) {},
        ),
      ),
    );
  }
}
