import 'package:find_missing_test/core/utils/app_styles.dart';
import 'package:find_missing_test/core/widgets/auth/custom_button.dart';
import 'package:find_missing_test/features/auth/data/cubit/auth_cubit.dart';
import 'package:find_missing_test/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/app_router.dart';
import '../../../../core/widgets/auth/custom_text_form_field.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final authCubit = context.read<AuthCubit>();
    final translate = S.of(context);

    Size size = MediaQuery.of(context).size;
    return Form(
      key: authCubit.loginFormKey,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.036),
        child: Column(
          children: [
            CustomTextFormField(
              hintText: translate.email,
              type: TextInputType.emailAddress,
              prefixIcon: (Icons.email_outlined),
              min: 12,
              max: 30,
              onChanged: (value) {
                authCubit.loginEmail = value!;
              },
              controller: authCubit.loginInputEmail,
            ),
            CustomTextFormField(
              isPassword: true,
              hintText: translate.pass,
              type: TextInputType.text,
              prefixIcon: (Icons.lock_outline),
              min: 6,
              max: 30,
              controller: authCubit.loginInputPass,
              onChanged: (value) {
                authCubit.loginPass = value!;
              },
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: size.height * 0.08, bottom: size.height * 0.2),
              child: CustomButton(
                text: translate.login,
                onPressed: () {
                  authCubit.login(context);
                },
                backColor: const [
                  Color(0xff92A3FD),
                  Color(0xff9DCEFF),
                ],
                textColor: const [Colors.white, Colors.white],
              ),
            ),
            Text(
              translate.loginu,
              style: AppStyles.boldFont,
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                translate.dont,
                style: AppStyles.small,
              ),
              TextButton(
                onPressed: () {
                  GoRouter.of(context).push(AppRouter.kRegisterView);
                },
                child: Text(
                  translate.register,
                  style: AppStyles.small1,
                ),
              )
            ]),
          ],
        ),
      ),
    );
  }
}
