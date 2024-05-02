import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:find_missing_test/core/models/user_mode.dart';
import 'package:find_missing_test/core/utils/app_color.dart';
import 'package:find_missing_test/core/utils/app_router.dart';
import 'package:find_missing_test/core/utils/app_styles.dart';
import 'package:find_missing_test/features/auth/data/cubit/auth_cubit.dart';
import 'package:find_missing_test/features/home/presentation/widgets/custome_my_message_view.dart';
import 'package:find_missing_test/features/home/presentation/widgets/custome_your_message_view.dart';
import 'package:find_missing_test/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ChatDetailsView extends StatelessWidget {
  final UserModel userModel;
  const ChatDetailsView({super.key, required this.userModel});

  @override
  Widget build(BuildContext context) {
    final authCubit = context.read<AuthCubit>();
    final String s = S.of(context).typeMessage;
    return Builder(builder: (context) {
      authCubit.getMessages(receiverId: userModel.id!);

      return BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is GetMessageSuuccessState) {
            authCubit.messages = authCubit.messages.reversed.toList();
          }
          return Scaffold(
            backgroundColor: AppColor.kBackGroundColor,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: AppColor.kBackGroundColor,
              titleTextStyle: AppStyles.header.copyWith(fontSize: 18),
              iconTheme: const IconThemeData(color: AppColor.kBlackColor),
              titleSpacing: 0,
              title: InkWell(
                splashColor: AppColor.kBackGroundColor,
                highlightColor: AppColor.kBackGroundColor,
                onTap: () {
                  GoRouter.of(context).push(
                    AppRouter.kPersonVisitProfileView,
                    extra: userModel.id,
                  );
                },
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundImage: NetworkImage(userModel.imageUrl!),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Expanded(child: Text(userModel.name!)),
                  ],
                ),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                children: [
                  ConditionalBuilder(
                    condition: authCubit.messages.isNotEmpty,
                    fallback: (context) => Expanded(child: Container()),
                    // const Center(child: CircularProgressIndicator()),
                    builder: (context) => Expanded(
                      child: Column(
                        children: [
                          Expanded(
                            child: ListView.separated(
                              reverse: true,
                              physics: const BouncingScrollPhysics(),
                              itemCount: authCubit.messages.length,
                              separatorBuilder: (context, index) => Container(
                                height: 1,
                              ),
                              itemBuilder: (context, index) {
                                var message = authCubit.messages[index];
                                if (authCubit.userModel!.id ==
                                    message.senderId) {
                                  return CustomeMyMessage(
                                      messageModel: message);
                                }
                                return CustomeYourMessage(
                                  messageModel: message,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Container(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: AppColor.kWhiteGreyColor,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(12)),
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: TextFormField(
                                controller: authCubit.messageController,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: s,
                                ),
                              ),
                            ),
                          ),
                          // if (context
                          //     .read<AuthCubit>()
                          //     .messageController
                          //     .text
                          //     .isNotEmpty)
                          MaterialButton(
                              onPressed: () {
                                authCubit.sendMessage(
                                    recieverId: userModel.id!,
                                    message: context
                                        .read<AuthCubit>()
                                        .messageController
                                        .text);
                                context
                                    .read<AuthCubit>()
                                    .messageController
                                    .text = '';
                              },
                              child: const Icon(Icons.send_rounded)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }
}
