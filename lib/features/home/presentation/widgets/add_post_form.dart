import 'package:find_missing_test/features/auth/data/cubit/auth_cubit.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/auth/custom_text_form_field.dart';
import '../../../../generated/l10n.dart';

class AddPostForm extends StatefulWidget {
  const AddPostForm({super.key});

  @override
  State<AddPostForm> createState() => _AddPostFormState();
}

class _AddPostFormState extends State<AddPostForm> {
  @override
  Widget build(BuildContext context) {
    final authCubit = context.read<AuthCubit>();
    final translate = S.of(context);

    return Form(
      key: authCubit.addChildFormKey,
      child: Column(
        children: [
          CustomTextFormField(
            hintText: translate.childName,
            type: TextInputType.name,
            prefixIcon: (Icons.person_outlined),
            min: 3,
            max: 12,
            controller: authCubit.addChildInputName,
            onChanged: (value) {
              authCubit.childName = value!;
            },
          ),
          CustomTextFormField(
              hintText: translate.age,
              type: TextInputType.number,
              prefixIcon: (Icons.numbers_outlined),
              min: 1,
              max: 2,
              onChanged: (value) {
                authCubit.childAge = value!;
              },
              controller: authCubit.addChildInputAge),
          CustomTextFormField(
            hintText: translate.address,
            type: TextInputType.text,
            prefixIcon: Icons.home,
            min: 3,
            max: 60,
            controller: authCubit.addChildInputAddress,
            onChanged: (value) {
              authCubit.childAddress = value!;
            },
          ),
          CustomTextFormField(
            lines: null,
            hintText: translate.childDetails,
            type: TextInputType.name,
            prefixIcon: (Icons.book_outlined),
            min: 6,
            max: 120,
            controller: authCubit.addChildInputDetails,
            onChanged: (value) {
              authCubit.childDetails = value!;
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ButtonStyle(backgroundColor:
                      MaterialStateProperty.resolveWith((states) {
                    if (authCubit.missimg != null) {
                      if (authCubit.missimg! &&
                          authCubit.missingClicked == translate.missing) {
                        return Colors.amber;
                      }
                    }
                    return null;
                  })),
                  onPressed: () {
                    setState(() {
                      authCubit.missingClicked = translate.missing;
                      authCubit.missimg = true;
                    });
                  },
                  child: Text(translate.missing),
                ),
              ),
              const SizedBox(
                width: 24,
              ),
              Expanded(
                child: ElevatedButton(
                  style: ButtonStyle(backgroundColor:
                      MaterialStateProperty.resolveWith((states) {
                    if (authCubit.missimg != null) {
                      if (!authCubit.missimg! &&
                          authCubit.missingClicked == translate.found) {
                        return Colors.amber;
                      }
                    }
                    return null;
                    // return Colors.blue;
                  })),
                  onPressed: () {
                    setState(() {
                      authCubit.missingClicked = translate.found;
                      authCubit.missimg = false;
                    });
                  },
                  child: Text(translate.found),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
