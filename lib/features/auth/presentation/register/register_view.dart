import 'package:find_missing_test/features/auth/data/cubit/auth_cubit.dart';
import 'package:find_missing_test/features/auth/presentation/register/register_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/app_styles.dart';
import '../../../../generated/l10n.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final translate = S.of(context);

    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    isDarkMode = !isDarkMode;
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            return Center(
              child: Stack(
                children: [
                  AbsorbPointer(
                    absorbing: !context.read<AuthCubit>().eventOccurred,
                    child: Opacity(
                      opacity:
                          context.read<AuthCubit>().eventOccurred ? 1 : 0.4,
                      child: Center(
                        child: Container(
                          height: size.height,
                          width: size.width,
                          decoration: const BoxDecoration(
                            // color: isDarkMode ? const Color(0xff151f2c) : Colors.white,
                            color: Colors.white,
                          ),
                          child: ListView(
                            physics: const BouncingScrollPhysics(),
                            children: [
                              Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: size.height * 0.02),
                                    child: Text(translate.hi,
                                        style: AppStyles.normal),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: size.height * 0.015),
                                    child: Text(
                                      translate.create,
                                      style: AppStyles.header,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: size.height * 0.03),
                                    child: const RegisterForm(),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (!context.read<AuthCubit>().eventOccurred)
                    const Center(child: CircularProgressIndicator()),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
