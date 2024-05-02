import 'package:cached_network_image/cached_network_image.dart';
import 'package:find_missing_test/features/home/data/cubit/home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/widgets/auth/custom_text_form_field.dart';
import 'widgets/add_post_form.dart';

class Test extends StatelessWidget {
  const Test({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(
            size.height * 0.023,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: size.height * 0.028,
                    backgroundImage:
                        const CachedNetworkImageProvider('assets/moaz.jpg'),
                  ),
                  SizedBox(
                    width: size.height * 0.02,
                  ),
                  Expanded(
                    child: Text(
                      'Moaz Tamer',
                      style: TextStyle(
                        height: 1.4,
                      ),
                    ),
                  ),
                  TextButton(
                      onPressed: () {
                        context.read<HomeCubit>().addNewMissingCild(context);
                      },
                      child: Text('Post'))
                ],
              ),
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    AddPostForm(),
                    CustomTextFormField(
                      lines: null,
                      hintText: 'Enter Child Details ...',
                      type: TextInputType.name,
                      prefixIcon: (Icons.book_outlined),
                      min: 6,
                      max: 120,
                      controller:
                          context.read<HomeCubit>().addChildInputDetails,
                      onChanged: (value) {
                        context.read<HomeCubit>().childDetails = value!;
                      },
                    ),
                    BlocBuilder<HomeCubit, HomeState>(
                        builder: (context, state) {
                      return Column(
                        children: [
                          if (context.read<HomeCubit>().childImage != null)
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
                                      image: MemoryImage(context
                                          .read<HomeCubit>()
                                          .childImage!),
                                      // image: AssetImage('assets/moaz.jpg'),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: CircleAvatar(
                                    radius: 20.0,
                                    child: Icon(
                                      Icons.close,
                                      size: 16.0,
                                    ),
                                  ),
                                  onPressed: () {
                                    context.read<HomeCubit>().removeImage();
                                    // SocialCubit.get(context).removePostImage();
                                  },
                                ),
                              ],
                            )
                        ],
                      );
                    }),
                    Row(
                      children: [
                        TextButton(
                          onPressed: () {
                            context.read<HomeCubit>().selectImage();
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_a_photo_outlined,
                              ),
                              SizedBox(
                                width: 6.0,
                              ),
                              Text(
                                'Add Child Photo',
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
        ),
      ),
    );
  }
}
