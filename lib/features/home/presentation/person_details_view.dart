import 'package:cached_network_image/cached_network_image.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:find_missing_test/constants.dart';

import 'package:find_missing_test/core/models/post_model.dart';
import 'package:find_missing_test/core/models/user_mode.dart';
import 'package:find_missing_test/core/utils/app_color.dart';
import 'package:find_missing_test/core/widgets/auth/custom_text_form_field.dart';
import 'package:find_missing_test/features/auth/data/cubit/auth_cubit.dart';
import 'package:find_missing_test/features/home/presentation/widgets/missing_child_view.dart';
import 'package:find_missing_test/features/home/presentation/widgets/person_details_form.dart';
import 'package:find_missing_test/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/utils/app_styles.dart';

class PersonDetailsView extends StatelessWidget {
  final String userId;
  const PersonDetailsView({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authCubit = context.read<AuthCubit>();
    final translate = S.of(context);
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColor.kBackGroundColor,
      body: Padding(
        padding: EdgeInsets.all(size.height * 0.01),
        child: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {},
          builder: (context, state) {
            UserModel userTest = authCubit.userModel!;

            if (authCubit.i) {
              authCubit.getPostsForUsert(id: id);
              print(authCubit.postsForUser.length);
            }

            if (state is GetUserDeatailsLoadState) {
              return const Center(child: CircularProgressIndicator());
            }
            return RefreshIndicator(
              onRefresh: () async {
                authCubit.getPostsForUsert(id: authCubit.userModel!.id!);
              },
              color: AppColor.kBlackGreyColor,
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        PopupMenuButton(
                          icon: Icon(Icons.more_vert),
                          itemBuilder: (BuildContext context) {
                            return [
                              PopupMenuItem(
                                child: Text('Arabic'),
                                value: 'Arabic',
                              ),
                              PopupMenuItem(
                                child: Text('English'),
                                value: 'English',
                              ),
                            ];
                          },
                          onSelected: (value) {
                            if (value == 'Arabic') {
                              authCubit.changeLanguage(lang2: 'ar');
                            } else if (value == 'English') {
                              authCubit.changeLanguage(lang2: 'en');
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Stack(alignment: Alignment.bottomRight, children: [
                              authCubit.profileImage == null
                                  ? CachedNetworkImage(
                                      imageUrl: userTest.imageUrl ??
                                          'https://firebasestorage.googleapis.com/v0/b/find-missing-children.appspot.com/o/user%20images%2Fdefault%20user.png?alt=media&token=39a16367-b33a-4ad4-b711-b5737bfa424e',
                                      imageBuilder: (context, imageProvider) =>
                                          CircleAvatar(
                                        radius: size.height * 0.07,
                                        backgroundImage: imageProvider,
                                        backgroundColor:
                                            AppColor.kBackGroundColor,
                                      ),
                                      placeholder: (context, url) =>
                                          CircleAvatar(
                                        radius: size.height * 0.07,
                                        backgroundColor:
                                            AppColor.kBackGroundColor,
                                        child:
                                            const CircularProgressIndicator(),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          CircleAvatar(
                                        radius: size.height * 0.07,
                                        backgroundColor:
                                            AppColor.kBackGroundColor,
                                        child: const Icon(Icons.error),
                                      ),
                                    )
                                  : CircleAvatar(
                                      radius: size.height * 0.07,
                                      backgroundImage:
                                          FileImage(authCubit.profileImage!)),
                              if (authCubit.isEditProfile)
                                IconButton(
                                  onPressed: () {
                                    authCubit.getProfileImage();
                                  },
                                  icon: CircleAvatar(
                                      radius: size.height * 0.02,
                                      backgroundColor: Colors.blue,
                                      child: const Icon(
                                          Icons.camera_alt_outlined)),
                                ),
                            ]),
                            SizedBox(height: size.height * 0.02),
                            Text(userTest.name ?? '', style: AppStyles.normal),
                            Text(userTest.phone ?? '', style: AppStyles.normal),
                          ],
                        ),
                        Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: size.height * .02),
                          child: Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    authCubit.customeShowDialogLogOut(
                                        context: context);
                                  },
                                  child: Text(translate.logOut),
                                ),
                              ),
                              SizedBox(width: size.width * 0.03),
                              authCubit.isEditProfile
                                  ? ElevatedButton(
                                      onPressed: () async {
                                        authCubit.editProfile();
                                        context
                                            .read<AuthCubit>()
                                            .updateData(context: context);
                                      },
                                      child: Text(translate.update),
                                    )
                                  : ElevatedButton(
                                      onPressed: () {
                                        authCubit.editProfile();
                                      },
                                      child: Text(translate.edit),
                                    )
                            ],
                          ),
                        ),
                        FormPersonDetail(), // don't make const
                      ],
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        return ConditionalBuilder(
                          condition: authCubit.postsForUser.isNotEmpty &&
                              authCubit.userModel!.id ==
                                  authCubit.postsForUser.first.id,
                          builder: (context) {
                            List<PostModel> posts = authCubit.postsForUser;
                            return MissingChildView(
                                posts: posts[index],
                                index: index,
                                numOfComments: authCubit.numOfCommentsForUser,
                                postsId: authCubit.postsIdForUser);
                          },
                          fallback: (context) {
                            authCubit.getPostsForUsert(id: id);

                            return Container();
                          },
                        );
                      },
                      childCount: authCubit.postsForUser.length,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class FormVisitPerfileDetails extends StatelessWidget {
  final UserModel userModel;
  const FormVisitPerfileDetails({super.key, required this.userModel});

  @override
  Widget build(BuildContext context) {
    final authCubit = context.read<AuthCubit>();
    final translate = S.of(context);

    UserModel userTest = authCubit.userModel!;
    return Form(
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
    );
  }
}
