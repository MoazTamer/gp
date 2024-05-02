import 'package:find_missing_test/core/utils/app_color.dart';
import 'package:find_missing_test/core/utils/app_styles.dart';
import 'package:find_missing_test/core/widgets/auth/custom_button.dart';
import 'package:find_missing_test/features/auth/data/cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'otp_detalis.dart';

class VerificationView extends StatelessWidget {
  const VerificationView({super.key});

  @override
  Widget build(BuildContext context) {
    final authCubit = context.read<AuthCubit>();

    return Scaffold(
      backgroundColor: AppColor.kBackGroundColor,
      appBar: AppBar(
        backgroundColor: AppColor.kBackGroundColor,
        title: const Text(
          'Verification',
        ),
        titleTextStyle: AppStyles.header,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColor.kBlackColor, size: 36),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(36.0),
              child: Column(
                children: [
                  Expanded(
                    flex: 24,
                    child: ListView(
                      physics: const BouncingScrollPhysics(),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Image(
                            image:
                                const AssetImage('assets/verificationCode.jpg'),
                            fit: BoxFit.fill,
                            height: MediaQuery.of(context).size.height / 4,
                            width: MediaQuery.of(context).size.width / 2,
                          ),
                        ),
                        Center(
                          child: Text(
                            'Enter the OTP sent to: ${authCubit.registerPhone}',
                            style: AppStyles.normal
                                .copyWith(color: Colors.black, fontSize: 18),
                          ),
                        ),
                        const OtpDetails(),
                      ],
                    ),
                  ),
                  const Spacer(),
                  CustomButton(
                    text: 'Register',
                    onPressed: () {
                      authCubit.login(context);
                    },
                    backColor: const [
                      AppColor.kPrimaryColor,
                      Color.fromARGB(255, 120, 93, 93)
                    ],
                    textColor: const [Colors.white, Colors.white],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
