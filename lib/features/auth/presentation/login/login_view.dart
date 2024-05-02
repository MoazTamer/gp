import 'package:find_missing_test/features/auth/data/cubit/auth_cubit.dart';
import 'package:find_missing_test/features/auth/presentation/login/login_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    isDarkMode = !isDarkMode;
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<AuthCubit, AuthState>(builder: (context, state) {
          return Center(
            child: Stack(
              children: [
                AbsorbPointer(
                  absorbing: !context.read<AuthCubit>().eventOccurred,
                  child: Opacity(
                    opacity: context.read<AuthCubit>().eventOccurred ? 1 : 0.4,
                    child: const LoginBody(),
                  ),
                ),
                if (!context.read<AuthCubit>().eventOccurred)
                  const Center(child: CircularProgressIndicator()),
              ],
            ),
          );
        }),
      ),
    );
  }
}
