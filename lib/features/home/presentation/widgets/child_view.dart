import 'package:find_missing_test/core/utils/app_styles.dart';
import 'package:find_missing_test/core/widgets/home/custom_app_bar.dart';
import 'package:find_missing_test/features/auth/data/cubit/auth_cubit.dart';
import 'package:find_missing_test/features/home/presentation/widgets/child_view_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/app_color.dart';

class ChildView extends StatelessWidget {
  const ChildView({super.key});

  @override
  Widget build(BuildContext context) {
    final authCubit = context.read<AuthCubit>();

    return Scaffold(
      backgroundColor: AppColor.kBackGroundColor,
      body: Column(
        children: [
          const CustomAppBar(title: 'Profile'),
          Expanded(
            flex: 3,
            child: Column(
              children: [
                Expanded(
                  // flex: 3,
                  child: PageView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: authCubit.loginPass.length,
                    onPageChanged: (value) {
                      authCubit.changePage(value);
                    },
                    itemBuilder: (context, index) => Stack(
                      alignment: AlignmentDirectional.bottomStart,
                      children: [
                        Image.asset(
                            height: MediaQuery.of(context).size.height / 1.5,
                            width: MediaQuery.of(context).size.width,
                            fit: BoxFit.fill,
                            'assets/moaz.jpg'),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Moaz Tamer',
                                style: AppStyles.appBar,
                              ),
                              Text(
                                'Age: 21',
                                style: AppStyles.appBar,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                  color: AppColor.kProfileColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(36),
                      topRight: Radius.circular(36))),
              child: const ChildViewDetails(),
            ),
          ),
        ],
      ),
    );
  }
}
