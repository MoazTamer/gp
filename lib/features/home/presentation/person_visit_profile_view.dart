import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:find_missing_test/constants.dart';
import 'package:find_missing_test/core/models/user_mode.dart';
import 'package:find_missing_test/core/utils/app_color.dart';
import 'package:find_missing_test/core/utils/app_router.dart';
import 'package:find_missing_test/core/utils/app_styles.dart';
import 'package:find_missing_test/core/widgets/auth/custom_text_form_field.dart';
import 'package:find_missing_test/features/auth/data/cubit/auth_cubit.dart';
import 'package:find_missing_test/features/home/presentation/widgets/missing_child_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../generated/l10n.dart';

class PersonVisitProfileView extends StatelessWidget {
  final String userId;
  const PersonVisitProfileView({Key? key, required this.userId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authCubit = context.read<AuthCubit>();
    final translate = S.of(context);

    authCubit.getPostsForUsert(id: userId);
    authCubit.getPostsForVisitUser(id: userId);
    authCubit.getUserById(userId: userId);

    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColor.kBackGroundColor,
      body: Padding(
        padding: EdgeInsets.all(size.height * 0.01),
        child: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {},
          builder: (context, state) {
            UserModel userTest = authCubit.vistProfile!;

            if (state is GetUserDeatailsLoadState) {
              return const Center(child: CircularProgressIndicator());
            }
            return ConditionalBuilder(
              condition: userTest.id!.length > 3,
              builder: (context) {
                return CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SafeArea(
                            child: Container(),
                          ),
                          CachedNetworkImage(
                            imageUrl: userTest.imageUrl ??
                                'https://firebasestorage.googleapis.com/v0/b/find-missing-children.appspot.com/o/user%20images%2Fdefault%20user.png?alt=media&token=39a16367-b33a-4ad4-b711-b5737bfa424e',
                            imageBuilder: (context, imageProvider) =>
                                CircleAvatar(
                              radius: size.height * 0.07,
                              backgroundImage: imageProvider,
                              backgroundColor: AppColor.kBackGroundColor,
                            ),
                            placeholder: (context, url) => CircleAvatar(
                              radius: size.height * 0.07,
                              backgroundColor: AppColor.kBackGroundColor,
                              child: const Center(
                                  child: CircularProgressIndicator()),
                            ),
                            errorWidget: (context, url, error) => CircleAvatar(
                              radius: size.height * 0.07,
                              backgroundColor: AppColor.kBackGroundColor,
                              child: Icon(Icons.error),
                            ),
                          ),
                          SizedBox(
                            height: size.height * 0.02,
                          ),
                          Text(
                            userTest.name ?? '',
                            style: AppStyles.normal,
                          ),
                          Text(
                            userTest.phone ?? '',
                            style: AppStyles.normal,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: size.height * .02),
                            child: userId != id
                                ? Row(
                                    children: [
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed: () {
                                            GoRouter.of(context).push(
                                                AppRouter.kChatDetailsView,
                                                extra: userTest);
                                          },
                                          child: Text(
                                            translate.contact,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : Row(
                                    children: [
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed: () {
                                            authCubit.userModel = UserModel(
                                              id: 'id',
                                              name: 'name',
                                              email: 'email',
                                              phone: 'phone',
                                              password: 'password',
                                              date: Timestamp.now(),
                                              imageUrl: 'imageUrl',
                                            );
                                            authCubit.posts = [];
                                            authCubit.users = [];
                                            GoRouter.of(context)
                                                .go(AppRouter.kLoginView);
                                          },
                                          child: Text(translate.logOut),
                                        ),
                                      ),
                                      SizedBox(width: size.width * 0.03),
                                      authCubit.isEditProfile
                                          ? ElevatedButton(
                                              onPressed: () async {
                                                context
                                                    .read<AuthCubit>()
                                                    .editProfile();
                                                context
                                                    .read<AuthCubit>()
                                                    .updateData(
                                                        context: context);
                                              },
                                              child: Text(translate.update),
                                            )
                                          : ElevatedButton(
                                              onPressed: () {
                                                context
                                                    .read<AuthCubit>()
                                                    .editProfile();
                                              },
                                              child: Text(translate.edit),
                                            )
                                    ],
                                  ),
                          ),
                          FormVisitPerfileDetails(userModel: userTest),
                        ],
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          return MissingChildView(
                            posts: authCubit.postsForVisitUser[index],
                            // posts: authCubit.postsForUser[index],
                            index: index,
                            numOfComments: authCubit.numOfCommentsForVisitUser,
                            postsId: authCubit.postsIdForVisitUser,
                          );
                        },
                        childCount: authCubit.postsForUser.length,
                      ),
                    ),
                  ],
                );
              },
              fallback: (context) => const Center(
                child: CircularProgressIndicator(),
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

    return authCubit.isEditProfile
        ? Form(
            key: GlobalKey(),
            child: Column(
              children: [
                if (userModel.phone != '')
                  CustomTextFormField(
                    enbale: false,
                    hintText: userModel.phone,
                    intialValue: userModel.phone ?? '',
                    type: TextInputType.phone,
                    prefixIcon: (Icons.phone_outlined),
                    min: 11,
                    max: 11,
                    controller: authCubit.updateInputPhone,
                    onChanged: (value) {},
                  ),
                if (userModel.email != '')
                  CustomTextFormField(
                    enbale: false,
                    hintText: userModel.email,
                    intialValue: userModel.email ?? '',
                    type: TextInputType.emailAddress,
                    prefixIcon: (Icons.email_outlined),
                    min: 11,
                    max: 11,
                    controller: authCubit.updateInputPhone,
                    onChanged: (value) {},
                  ),
              ],
            ),
          )
        : Container();
  }
}
