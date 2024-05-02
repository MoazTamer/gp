import 'package:find_missing_test/core/utils/app_styles.dart';
import 'package:find_missing_test/features/auth/data/cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/app_router.dart';
import '../../../../core/widgets/auth/custom_button.dart';
import '../../../../core/widgets/auth/custom_text_form_field.dart';
import '../../../../generated/l10n.dart';

class RegisterForm extends StatelessWidget {
  const RegisterForm({super.key});

  @override
  Widget build(BuildContext context) {
    final authCubit = context.read<AuthCubit>();
    final translate = S.of(context);

    Size size = MediaQuery.of(context).size;
    return Form(
      key: authCubit.registerFormKey,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.036),
        child: Column(
          children: [
            CustomTextFormField(
              hintText: translate.uname,
              type: TextInputType.name,
              prefixIcon: (Icons.person_outlined),
              min: 3,
              max: 12,
              controller: authCubit.registerInputName,
              onChanged: (value) {
                authCubit.registerName = value!;
              },
            ),
            CustomTextFormField(
                hintText: translate.email,
                type: TextInputType.emailAddress,
                prefixIcon: (Icons.email_outlined),
                min: 12,
                max: 30,
                onChanged: (value) {
                  authCubit.registerEmail = value!;
                },
                controller: authCubit.registerInputEmail),
            CustomTextFormField(
              hintText: translate.phone,
              type: TextInputType.phone,
              prefixIcon: (Icons.phone_outlined),
              min: 11,
              max: 11,
              controller: authCubit.registerInputPhone,
              onChanged: (value) {
                authCubit.registerPhone = value!;
              },
            ),
            CustomTextFormField(
                isPassword: true,
                hintText: translate.pass,
                type: TextInputType.text,
                prefixIcon: (Icons.lock_outline),
                min: 6,
                max: 30,
                onChanged: (value) {
                  authCubit.registerPass = value!;
                },
                controller: authCubit.registerInputPass),
            Padding(
              padding: EdgeInsets.only(
                  top: size.height * 0.03, bottom: size.height * 0.1),
              child: CustomButton(
                text: translate.register,
                onPressed: () {
                  authCubit.directRegister(context);
                  // authCubit.sendPhoneVerification(context);
                },
                backColor: const [
                  Color(0xff92A3FD),
                  Color(0xff9DCEFF),
                ],
                textColor: const [Colors.white, Colors.white],
              ),
            ),
            Text(
              translate.register,
              style: AppStyles.boldFont,
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                translate.have,
                style: AppStyles.small,
              ),
              TextButton(
                onPressed: () {
                  GoRouter.of(context).go(AppRouter.kLoginView);
                },
                child: Text(
                  translate.loginu,
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
