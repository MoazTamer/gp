import 'package:find_missing_test/core/widgets/auth/custom_text_form_field.dart';
import 'package:find_missing_test/features/auth/data/cubit/auth_cubit.dart';
import 'package:find_missing_test/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SendCommentView extends StatelessWidget {
  final int index;
  const SendCommentView({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    final authCubit = context.read<AuthCubit>();

    Size size = MediaQuery.of(context).size;

    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) => SizedBox(
        height: size.height * 0.1,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: [
              if (authCubit.yourComment == '')
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.send_outlined),
                ),
              if (authCubit.yourComment != '')
                IconButton(
                  onPressed: () {
                    authCubit.createComment(
                      authCubit.postsId[index],
                    );
                    authCubit.yourComment = '';
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.send_outlined,
                    color: Colors.blue,
                  ),
                ),
              Expanded(
                child: SizedBox(
                  width: size.width,
                  child: CustomTextFormField(
                    autovalidateMode: AutovalidateMode.disabled,
                    controller: authCubit.inputComment,
                    hintText: S.of(context).wComment,
                    max: 1000,
                    min: 0,
                    lines: null,
                    onChanged: (value) {
                      authCubit.yourComment = value!;
                      authCubit.writeComment();
                    },
                    prefixIcon: null,
                    type: TextInputType.text,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
