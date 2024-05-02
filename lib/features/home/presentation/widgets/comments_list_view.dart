import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:find_missing_test/core/utils/app_color.dart';
import 'package:find_missing_test/features/auth/data/cubit/auth_cubit.dart';
import 'package:find_missing_test/features/home/data/cubit/test_cubit/test_cubit.dart';
import 'package:find_missing_test/features/home/presentation/widgets/custome_comment_view.dart';
import 'package:find_missing_test/features/home/presentation/widgets/send_comment_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CommentsListView extends StatelessWidget {
  final int index;
  final List<String> postId;
  const CommentsListView(
      {super.key, required this.index, required this.postId});

  @override
  Widget build(BuildContext context) {
    final authCubit = context.read<AuthCubit>();

    if (context.read<TestCubit2>().comments.length !=
        authCubit.numOfComments[index]) {
      context.read<TestCubit2>().getComments(index, postId);
    }

    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.91,
      color: AppColor.kBackGroundColor,
      child: Scaffold(
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: BlocConsumer<TestCubit2, TestState2>(
            listener: (context, state) {},
            builder: (context, state) {
              if (state is GetCommentsLoadingState2) {
                return Column(
                  children: [
                    SizedBox(
                      height: size.height * 0.38,
                    ),
                    const Center(child: CircularProgressIndicator()),
                    SizedBox(
                      height: size.height * 0.38,
                    ),
                    SendCommentView(index: index),
                  ],
                );
              }
              if (state is GetCommentsErrorState2) {
                return Column(
                  children: [
                    SizedBox(
                      height: size.height * 0.7,
                    ),
                    Center(
                      child: Column(
                        children: [
                          SizedBox(
                              height: size.height * 0.1,
                              child: Text(state.error)),
                          SendCommentView(index: index),
                        ],
                      ),
                    ),
                  ],
                );
              }
              if (state is GetCommentsSuccessState2) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      ConditionalBuilder(
                        condition:
                            (context.read<TestCubit2>().comments.isNotEmpty &&
                                    context
                                        .read<AuthCubit>()
                                        .numOfComments
                                        .isNotEmpty) ||
                                authCubit.numOfComments[index] == 0,
                        fallback: (context) =>
                            const Center(child: CircularProgressIndicator()),
                        builder: (context) {
                          return SizedBox(
                            height: size.height * 0.79,
                            child: ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              itemCount: context
                                  .read<AuthCubit>()
                                  // .comments.length,
                                  .numOfComments[index],
                              itemBuilder: (context, index) {
                                return CustomeCommentWidget(
                                  index: index,
                                );
                              },
                            ),
                          );
                        },
                      ),

                      /////////////////////////////
                      SendCommentView(index: index),
                    ],
                  ),
                );
              }
              return SendCommentView(index: index);
            },
          ),
        ),
      ),
    );
  }
}
