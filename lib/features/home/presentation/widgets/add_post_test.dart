import 'package:cached_network_image/cached_network_image.dart';
import 'package:find_missing_test/core/models/user_mode.dart';
import 'package:find_missing_test/core/utils/app_color.dart';
import 'package:find_missing_test/features/auth/data/cubit/auth_cubit.dart';
import 'package:find_missing_test/features/home/presentation/widgets/add_post_form.dart';
import 'package:find_missing_test/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddPostTest extends StatelessWidget {
  const AddPostTest({super.key});

  @override
  Widget build(BuildContext context) {
    final authCubit = context.read<AuthCubit>();
    final translate = S.of(context);

    authCubit.getdataTest();
    UserModel userTest = authCubit.userModel!;

    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(
            size.height * 0.023,
          ),
          child: BlocBuilder<AuthCubit, AuthState>(builder: (context, state) {
            return AbsorbPointer(
              absorbing: !context.read<AuthCubit>().eventOccurred,
              child: Opacity(
                opacity: context.read<AuthCubit>().eventOccurred ? 1 : 0.4,
                child: Stack(
                  children: [
                    Column(
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: size.height * 0.028,
                              backgroundImage: CachedNetworkImageProvider(
                                  userTest.imageUrl ?? ''),
                            ),
                            SizedBox(
                              width: size.height * 0.02,
                            ),
                            Expanded(
                              child: Text(
                                userTest.name ?? '',
                                // 'Moaz Tamer',
                                style: const TextStyle(
                                  height: 1.4,
                                ),
                              ),
                            ),
                            ElevatedButton(
                              child: Text(translate.post),
                              onPressed: () {
                                authCubit.posts = [];
                                authCubit.uploadPostImage(
                                  context: context,
                                );
                              },
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: size.height * 0.014),
                          child: Container(
                            width: double.infinity,
                            height: size.height * 0.001,
                            color: AppColor.kWhiteGreyColor,
                          ),
                        ),
                        Expanded(
                          child: ListView(
                            physics: const BouncingScrollPhysics(),
                            children: [
                              AddPostForm(),
                              Column(
                                children: [
                                  if (authCubit.postImage != null)
                                    Stack(
                                      alignment: AlignmentDirectional.topEnd,
                                      children: [
                                        Container(
                                          height: size.height * 0.3,
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              6.0,
                                            ),
                                            image: DecorationImage(
                                              image: FileImage(
                                                  authCubit.postImage!),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          icon: const CircleAvatar(
                                            radius: 20.0,
                                            child: Icon(
                                              Icons.close,
                                              size: 16.0,
                                            ),
                                          ),
                                          onPressed: () {
                                            authCubit.removePostImage();
                                          },
                                        ),
                                      ],
                                    )
                                ],
                              ),
                              Row(
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      authCubit.getPostImage();
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.add_a_photo_outlined,
                                        ),
                                        SizedBox(
                                          width: 6.0,
                                        ),
                                        Text(
                                          translate.addPhoto,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    if (!context.read<AuthCubit>().eventOccurred)
                      const Center(
                        child: CircularProgressIndicator(),
                      ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
