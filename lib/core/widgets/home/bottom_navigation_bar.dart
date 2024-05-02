import 'package:find_missing_test/core/utils/app_color.dart';
import 'package:find_missing_test/features/home/data/cubit/home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: context.read<HomeCubit>(),
      builder: (context, state) => Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColor.kBackGroundColor,
              AppColor.kBackGroundColor,
              AppColor.kBackGroundColor,
            ],
          ),
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: context.read<HomeCubit>().pages,
          currentIndex: context.read<HomeCubit>().currentPage,
          elevation: 0,
          iconSize: 28,
          unselectedItemColor: AppColor.kGreyColor,
          selectedItemColor: AppColor.kDarkGreyColor,
          onTap: (value) {
            context.read<HomeCubit>().nextPage(value, context);
          },
          backgroundColor: Colors.transparent,
        ),
      ),
    );
  }
}
