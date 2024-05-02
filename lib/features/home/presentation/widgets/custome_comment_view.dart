import 'package:find_missing_test/core/models/comment_model.dart';
import 'package:find_missing_test/core/utils/app_color.dart';
import 'package:find_missing_test/core/utils/app_router.dart';
import 'package:find_missing_test/core/utils/app_styles.dart';
import 'package:find_missing_test/features/home/data/cubit/test_cubit/test_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class CustomeCommentWidget extends StatelessWidget {
  final int index;
  const CustomeCommentWidget({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    List<CommentModel> comments = context.read<TestCubit2>().comments;
    CommentModel commentModel = comments[index];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              GoRouter.of(context).push(
                AppRouter.kPersonVisitProfileView,
                extra: commentModel.writerCommentId,
              );
            },
            child: CircleAvatar(
              radius: size.width * 0.06,
              backgroundImage: NetworkImage(commentModel.writerCommentImage),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Container(
                decoration: BoxDecoration(
                    color: AppColor.kWhiteGreyColor,
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              GoRouter.of(context).push(
                                  AppRouter.kPersonVisitProfileView,
                                  extra: commentModel.writerCommentId);
                            },
                            child: Text(
                              commentModel.writerCommentName,
                              style: AppStyles.normal,
                            ),
                          ),
                          const Spacer(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                  '${commentModel.date.toDate().year}/${commentModel.date.toDate().month}/${commentModel.date.toDate().day}',
                                  style: AppStyles.small.copyWith(
                                    fontSize: 12,
                                    color: AppColor.kGreyColor,
                                  )),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      Text(
                        commentModel.comment,
                        style: AppStyles.small,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
