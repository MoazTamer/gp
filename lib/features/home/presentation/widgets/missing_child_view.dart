import 'package:cached_network_image/cached_network_image.dart';
import 'package:find_missing_test/core/models/post_model.dart';
import 'package:find_missing_test/core/models/user_mode.dart';
import 'package:find_missing_test/core/utils/app_router.dart';
import 'package:find_missing_test/core/utils/app_styles.dart';
import 'package:find_missing_test/features/auth/data/cubit/auth_cubit.dart';
import 'package:find_missing_test/features/home/data/cubit/test_cubit/test_cubit.dart';
import 'package:find_missing_test/generated/l10n.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/app_color.dart';

class MissingChildView extends StatelessWidget {
  final PostModel posts;
  final int index;
  final List<int> numOfComments;
  final List<String> postsId;
  const MissingChildView({
    super.key,
    required this.posts,
    required this.index,
    required this.numOfComments,
    required this.postsId,
  });

  @override
  Widget build(BuildContext context) {
    final authCubit = context.read<AuthCubit>();
    final translate = S.of(context);

    UserModel userTest = authCubit.userModel!;
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: size.height * 0.01, horizontal: size.width * 0.024),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColor.kBackGroundColor,
              borderRadius: BorderRadius.circular(size.height * 0.014),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 2,
                  offset: const Offset(0, 1), // changes position of shadow
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.all(size.height * 0.012),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      InkWell(
                        splashColor: AppColor.kBackGroundColor,
                        highlightColor: AppColor.kBackGroundColor,
                        onTap: () {
                          GoRouter.of(context).push(
                            AppRouter.kPersonVisitProfileView,
                            extra: posts.id,
                          );
                        },
                        child: CircleAvatar(
                          radius: size.height * 0.028,
                          backgroundImage:
                              CachedNetworkImageProvider(posts.image),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: size.height * 0.02),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              splashColor: AppColor.kBackGroundColor,
                              highlightColor: AppColor.kBackGroundColor,
                              onTap: () {
                                GoRouter.of(context).push(
                                  AppRouter.kPersonVisitProfileView,
                                  extra: posts.id,
                                );
                              },
                              child: Text(
                                posts.name,
                                style: AppStyles.normal,
                              ),
                            ),
                            Text(
                              // '14/01/2024',
                              '${posts.date.toDate().day}/${posts.date.toDate().month}/${posts.date.toDate().year}',
                              style: AppStyles.small.copyWith(
                                fontSize: 12,
                                color: AppColor.kBlackGreyColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      if (posts.id == userTest.id)
                        IconButton(
                            onPressed: () {
                              authCubit.customeShowDialog(
                                  imgUrl: posts.childImage, context: context);
                            },
                            icon: const Icon(Icons.delete_outline)),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: size.height * 0.014,
                    ),
                    child: Container(
                      width: double.infinity,
                      height: size.height * 0.001,
                      color: AppColor.kWhiteGreyColor,
                    ),
                  ),
                  Text(
                    '${translate.name} : ${posts.childName}\n${translate.address} : ${posts.childAddress}\n${translate.age} : ${posts.childAge}\n${posts.childDetails}\n${posts.phone}',
                    style: AppStyles.small,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: size.height * 0.014,
                      bottom: size.height * 0.004,
                    ),
                    child: Container(
                      width: double.infinity,
                      height: size.height * 0.36,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          size.height * 0.007,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                          size.height * 0.007,
                        ),
                        child: CachedNetworkImage(
                          imageUrl: posts.childImage,
                          fit: BoxFit.cover,
                          placeholder: (context, url) {
                            return const Center(
                                child: CircularProgressIndicator());
                          },
                          errorWidget: (context, url, error) {
                            return const Center(
                              child: Icon(
                                Icons.error,
                                size: 30,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      context.read<TestCubit2>().showBootomSheet(
                            context: context,
                            index: index,
                            // postsId: authCubit.postsId,
                            postsId: postsId,
                          );
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: size.height * 0.01,
                      ),
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (posts.name == authCubit.userModel!.name)
                            ElevatedButton(
                              onPressed: () {
                                GoRouter.of(context).push(
                                    AppRouter.ksimilarityView,
                                    extra: posts);
                              },
                              child: Text(translate.similarty),
                            ),
                          const Spacer(),
                          Icon(
                            Icons.chat_outlined,
                            size: size.height * 0.02,
                          ),
                          SizedBox(
                            width: size.height * 0.007,
                          ),
                          Text(
                            '${numOfComments[index]}'
                            // '${authCubit.numOfComments[index]}'
                            ' ${translate.comment}',
                            style: AppStyles.small.copyWith(
                              color: AppColor.kBlackGreyColor,
                              fontSize: size.height * 0.014,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: size.height * 0.01,
                    ),
                    child: Container(
                      width: double.infinity,
                      height: size.height * 0.001,
                      color: AppColor.kWhiteGreyColor,
                    ),
                  ),
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          context.read<TestCubit2>().showBootomSheet(
                                context: context,
                                index: index,
                                // postsId: authCubit.postsId
                                postsId: postsId,
                              );
                        },
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: size.height * 0.02,
                              backgroundImage: CachedNetworkImageProvider(
                                  userTest.imageUrl ?? ''),
                              // NetworkImage(userTest.imageUrl ?? ''),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: size.height * 0.014,
                              ),
                              child: TextButton(
                                child: Text(
                                  translate.wComment,
                                  style: AppStyles.small.copyWith(
                                    color: AppColor.kBlackGreyColor,
                                  ),
                                ),
                                onPressed: () {
                                  context.read<TestCubit2>().showBootomSheet(
                                        context: context,
                                        index: index,
                                        // postsId: authCubit.postsId,
                                        postsId: postsId,
                                      );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: const Border(
                            bottom: BorderSide(width: 1.5),
                          ),
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              posts.missing
                                  ? translate.missing
                                  : translate.found,
                              style: TextStyle(
                                fontSize: 18, // Adjust the font size as needed
                                fontWeight: FontWeight
                                    .bold, // Optionally, apply bold font weight
                                color: posts.missing
                                    ? Colors.red
                                    : Colors
                                        .green, // Optionally, change text color based on condition
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
