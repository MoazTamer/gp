import 'package:find_missing_test/core/utils/app_color.dart';
import 'package:find_missing_test/features/home/data/cubit/home_cubit.dart';
import 'package:find_missing_test/core/widgets/home/bottom_navigation_bar.dart';
import 'package:find_missing_test/features/home/data/cubit/test_cubit/test_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<HomeCubit>(create: (_) => HomeCubit()),
        BlocProvider<TestCubit2>(create: (_) => TestCubit2()),
      ],
      child: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) => Scaffold(
            backgroundColor: AppColor.kBackGroundColor,
            body: SafeArea(
              child: context
                  .read<HomeCubit>()
                  .nextPage(context.read<HomeCubit>().currentPage, context),
            ),
            bottomNavigationBar: const CustomBottomNavigationBar()),
      ),
    );
  }
}
