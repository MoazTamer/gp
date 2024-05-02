import 'package:find_missing_test/core/utils/app_styles.dart';
import 'package:find_missing_test/features/auth/presentation/login/login_form.dart';
import 'package:find_missing_test/generated/l10n.dart';
import 'package:flutter/material.dart';

class LoginBody extends StatelessWidget {
  const LoginBody({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final translate = S.of(context);

    return Container(
      height: size.height,
      width: size.width,
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: size.height * 0.02),
                child: Text(translate.hi, style: AppStyles.normal),
              ),
              Padding(
                padding: EdgeInsets.only(top: size.height * 0.015),
                child: Text(
                  translate.welcome,
                  style: AppStyles.header,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: size.height * 0.03),
                child: const LoginForm(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
