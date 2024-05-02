import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:find_missing_test/core/models/post_model.dart';
import 'package:find_missing_test/core/utils/app_color.dart';
import 'package:find_missing_test/core/utils/app_styles.dart';
import 'package:find_missing_test/features/auth/data/cubit/auth_cubit.dart';
import 'package:find_missing_test/features/home/presentation/widgets/missing_child_view.dart';
import 'package:find_missing_test/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MissingListView extends StatelessWidget {
  const MissingListView({super.key});

  @override
  Widget build(BuildContext context) {
    final authCubit = context.read<AuthCubit>();

    if (authCubit.userModel!.id == 'id') {
      authCubit.getdataTest();
    }
    if (authCubit.posts.isEmpty) {
      authCubit.getPosts();
    }
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColor.kBackGroundColor,
      body: SafeArea(
        child: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is GetCommentsSuccessState) {
              authCubit.getPosts();
            }
          },
          builder: (context, state) {
            List<PostModel> userTest2 = authCubit.posts;
            List<PostModel> userTest = [];
            userTest.addAll(userTest2.where((element) =>
                element.childName.contains(authCubit.serchKey.toLowerCase()) ||
                element.childName.contains(authCubit.serchKey.toUpperCase()) ||
                element.childAge.contains(authCubit.serchKey)));
            return Column(
              children: [
                Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 8),
                    child: TextField(
                      controller: authCubit.searchTextEditingController,
                      onChanged: (value) {
                        authCubit.serchKey = value;
                        authCubit.re();
                      },
                      decoration: InputDecoration(
                        hintText: S.of(context).search,
                        hintStyle: AppStyles.normal
                            .copyWith(color: AppColor.kGreyColor),
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
                    )),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      authCubit.getPosts();
                    },
                    child: ListView(
                      physics: const BouncingScrollPhysics(),
                      children: [
                        ConditionalBuilder(
                          condition:
                              context.read<AuthCubit>().posts.isNotEmpty &&
                                  authCubit.userModel!.id != 'id',
                          fallback: (context) {
                            return Column(
                              children: [
                                SizedBox(
                                  height: size.height / 3,
                                ),
                                const CircularProgressIndicator(),
                              ],
                            );
                          },
                          builder: (context) => RefreshIndicator(
                            onRefresh: () async {
                              authCubit.getPosts();
                            },
                            color: AppColor.kBlackGreyColor,
                            child: SizedBox(
                              height: size.height,
                              child: ListView.builder(
                                physics: const BouncingScrollPhysics(),
                                itemCount: userTest.length,
                                itemBuilder: (context, index) {
                                  return Column(
                                    children: [
                                      MissingChildView(
                                        posts: userTest[index],
                                        index: index,
                                        numOfComments: context
                                            .read<AuthCubit>()
                                            .numOfComments,
                                        postsId: authCubit.postsId,
                                      ),
                                      if (index == userTest.length - 1)
                                        SizedBox(
                                          height: size.height / 5,
                                        ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
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
