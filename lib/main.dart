import 'dart:async';

import 'package:find_missing_test/core/utils/app_color.dart';
import 'package:find_missing_test/core/utils/app_router.dart';
import 'package:find_missing_test/features/home/data/cubit/test_cubit/test_cubit.dart';
import 'package:find_missing_test/generated/l10n.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'features/auth/data/cubit/auth_cubit.dart';
import 'firebase_options.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  Fluttertoast.showToast(
    msg: "This is a toast message",
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: Colors.grey,
    textColor: Colors.white,
    fontSize: 16.0,
  );
  print(
      "Handling a background message i=====================================\n=========");
  print("Handling a background message is : ${message.data}");
  print("Handling a background message: ${message.messageId}");
  print(
      "Handling a background message i=====================================\n=========");
}

Future<String> get() async {
  SharedPreferences s = await SharedPreferences.getInstance();
  print(s.getString('lang').toString());
  return s.getString('lang').toString();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  String m = await get();

  runApp(MyApp(lang: m));
}

class MyApp extends StatelessWidget {
  final String? lang;
  const MyApp({super.key, required this.lang});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: AppColor.kBackGroundColor,
    ));
    return BlocProvider(
      create: (context) => TestCubit2(),
      child: BlocProvider(
        create: (context) => AuthCubit(),
        child: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            String l;
            if (context.read<AuthCubit>().lang == '') {
              l = lang!;
            } else {
              l = context.read<AuthCubit>().lang;
            }
            return MaterialApp.router(
              locale: Locale(l),
              routerConfig: AppRouter.router,
              debugShowCheckedModeBanner: false,
              localizationsDelegates: [
                S.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: S.delegate.supportedLocales,
            );
          },
        ),
      ),
    );
  }
}
