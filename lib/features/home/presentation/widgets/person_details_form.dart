import 'package:find_missing_test/core/models/user_mode.dart';
import 'package:find_missing_test/core/widgets/auth/custom_text_form_field.dart';
import 'package:find_missing_test/features/auth/data/cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../generated/l10n.dart';

class FormPersonDetail extends StatelessWidget {
  const FormPersonDetail({super.key});

  @override
  Widget build(BuildContext context) {
    final authCubit = context.read<AuthCubit>();
    final translate = S.of(context);

    UserModel userTest = authCubit.userModel!;

    return authCubit.isEditProfile
        ? Form(
            key: authCubit.updateFormKey,
            child: Column(
              children: [
                CustomTextFormField(
                  enbale: authCubit.isEditProfile,
                  hintText: translate.name,
                  // hintText: userTest.name,
                  intialValue: userTest.name ?? '',
                  type: TextInputType.name,
                  prefixIcon: (Icons.person_outlined),
                  min: 3,
                  max: 24,
                  controller: authCubit.updateInputName,
                  onChanged: (value) {
                    authCubit.updateName = value!;
                  },
                ),
                CustomTextFormField(
                  enbale: authCubit.isEditProfile,
                  // hintText: '01121399497',
                  hintText: userTest.phone,
                  intialValue: userTest.phone ?? '',
                  type: TextInputType.phone,
                  prefixIcon: (Icons.phone_outlined),
                  min: 11,
                  max: 11,
                  controller: authCubit.updateInputPhone,
                  onChanged: (value) {
                    authCubit.updatePhone = value!;
                  },
                ),
              ],
            ),
          )
        : Container();
  }
}
