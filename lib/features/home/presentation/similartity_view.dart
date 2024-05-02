import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:find_missing_test/core/models/post_model.dart';
import 'package:find_missing_test/core/utils/app_color.dart';
import 'package:find_missing_test/core/utils/app_styles.dart';
import 'package:find_missing_test/features/auth/data/cubit/auth_cubit.dart';
import 'package:find_missing_test/features/home/presentation/widgets/missing_child_view.dart';
import 'package:find_missing_test/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SimilartyListView extends StatelessWidget {
  // final String imgUrl;
  final PostModel post;

  const SimilartyListView({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authCubit = context.read<AuthCubit>();
    authCubit.fetchData(imgUrl: post.childImage, context: context, post: post);

    return Scaffold(
      backgroundColor: AppColor.kBackGroundColor,
      body: SafeArea(
        child: BlocBuilder<AuthCubit, AuthState>(
          // listener: (context, state) {
          //   if (state is GetCommentsSuccessState) {
          //     authCubit.getPostsForSimilarity();
          //   }
          // },
          builder: (context, state) {
            Size size = MediaQuery.of(context).size;
            List<PostModel> userTest = authCubit.postsForSimilarity
                .where((element) =>
                    element.childName
                        .toLowerCase()
                        .contains(authCubit.serchKey.toLowerCase()) ||
                    element.childAge.contains(authCubit.serchKey))
                .toList();

            return Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
                  child: TextField(
                    controller: authCubit.searchTextEditingController,
                    onChanged: (value) {
                      authCubit.serchKey = value;
                      authCubit.re();
                    },
                    decoration: InputDecoration(
                      hintText: S.of(context).search,
                      hintStyle:
                          AppStyles.normal.copyWith(color: AppColor.kGreyColor),
                      filled: true,
                      fillColor: AppColor.kWhiteGreyColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(36),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.all(12.0),
                      suffixIcon: Icon(
                        Icons.search_outlined,
                        size: size.height * 0.03,
                        color: AppColor.kBlackGreyColor,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      print(authCubit.modelApi.numberOfSimilarImages!);
                      if (authCubit.modelApi.numberOfSimilarImages! > 0) {
                        authCubit.getPostsForSimilarity();
                      }
                    },
                    child: ConditionalBuilder(
                      condition: userTest.isNotEmpty &&
                          authCubit.userModel!.id != 'id',
                      fallback: (context) =>
                          const Center(child: CircularProgressIndicator()),
                      builder: (context) => ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: userTest.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              MissingChildView(
                                posts: userTest[index],
                                index: index,
                                numOfComments:
                                    authCubit.numOfCommentsForSimilarity,
                                postsId: authCubit.postsIdForSimilarity,
                              ),
                              if (index == userTest.length - 1)
                                SizedBox(height: size.height / 5),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
