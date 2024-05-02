import 'package:dots_indicator/dots_indicator.dart';
import 'package:find_missing_test/core/utils/app_color.dart';
import 'package:find_missing_test/core/utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../auth/data/cubit/auth_cubit.dart';

class ChildViewDetails extends StatelessWidget {
  const ChildViewDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final authCubit = context.read<AuthCubit>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BlocBuilder<AuthCubit, AuthState>(
                builder: (context, state) {
                  return DotsIndicator(
                    dotsCount:
                        6, // Set the number of dots based on the number of pages
                    // dotsCount: authCubit.loginPass.length, // Set the number of dots based on the number of pages
                    position: authCubit.index,
                    decorator: const DotsDecorator(
                      color: Colors.grey, // Inactive dot color
                      activeColor: AppColor.kPrimaryColor, // Active dot color
                    ),
                  );
                },
              ),
            ],
          ),
          Expanded(
            child: ListView(
              children: [
                Row(
                  children: [
                    Text(
                      'Gender: ',
                      style:
                          AppStyles.input.copyWith(color: AppColor.kBlackColor),
                    ),
                    Text(
                      'Male',
                      style: AppStyles.input,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'Address: ',
                      style:
                          AppStyles.input.copyWith(color: AppColor.kBlackColor),
                    ),
                    Expanded(
                        child: Text(
                      'Cairo',
                      maxLines: 1,
                      overflow: TextOverflow.clip,
                      style: AppStyles.input,
                    )),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'Contact: ',
                      style:
                          AppStyles.input.copyWith(color: AppColor.kBlackColor),
                    ),
                    Text(
                      '01016797809',
                      style: AppStyles.input,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'Date Of Birth: ',
                      style:
                          AppStyles.input.copyWith(color: AppColor.kBlackColor),
                    ),
                    Text(
                      '14-8-2002',
                      style: AppStyles.input,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
