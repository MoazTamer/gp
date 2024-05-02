import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:find_missing_test/core/models/user_mode.dart';
import 'package:find_missing_test/core/utils/app_color.dart';
import 'package:find_missing_test/core/utils/app_styles.dart';
import 'package:find_missing_test/features/auth/data/cubit/auth_cubit.dart';
import 'package:find_missing_test/features/home/presentation/chat_view.dart';
import 'package:find_missing_test/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatListView extends StatelessWidget {
  const ChatListView({super.key});

  @override
  Widget build(BuildContext context) {
    final authCubit = context.read<AuthCubit>();

    Size size = MediaQuery.of(context).size;
    List<UserModel> users = authCubit.users;
    authCubit.getAllUsers();

    return Scaffold(
      backgroundColor: AppColor.kBackGroundColor,
      appBar: AppBar(
        title: Text(
          S.of(context).chats,
          style: AppStyles.header,
        ),
        backgroundColor: AppColor.kBackGroundColor,
        elevation: 0,
      ),
      body: SafeArea(
        child: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {},
          builder: (context, state) {
            return ConditionalBuilder(
              fallback: (context) =>
                  const Center(child: CircularProgressIndicator()),
              condition: users.isNotEmpty,
              builder: (context) => ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return ChatView(
                      userModel: users[index],
                    );
                  },
                  separatorBuilder: (context, index) {
                    return Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: size.height * 0.014),
                      child: Container(
                        width: double.infinity,
                        height: size.height * 0.001,
                        color: AppColor.kWhiteGreyColor,
                      ),
                    );
                  },
                  itemCount: authCubit.users.length),
            );
          },
        ),
      ),
    );
  }
}
