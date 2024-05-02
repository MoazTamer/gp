import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find_missing_test/constants.dart';
import 'package:find_missing_test/core/models/user_mode.dart';
import 'package:find_missing_test/core/widgets/core/show_toast.dart';
import 'package:find_missing_test/features/auth/data/cubit/auth_cubit.dart';
import 'package:find_missing_test/features/auth/domain/repos/auth_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/utils/app_router.dart';

class AuthRepoImpl extends AuthRepo {
  @override
  void checkVerificationCode(
      {required GlobalKey<FormState> globalKey,
      required BuildContext context,
      required String name,
      required String email,
      required String pass,
      required String phone,
      required String pin}) async {
    try {
      UserCredential userCredential = await confirmationResult.confirm(pin);
      addUserToDatabase(name: name, email: email, pass: pass, phone: phone);
      register(globalKey, email, pass, context);
      await addUserToDatabase(
          name: name, email: email, pass: pass, phone: phone);
      // GoRouter.of(context).push(AppRouter.kHomeView);
    } on FirebaseAuthException catch (e) {
      showToast(context: context, msg: e.toString(), done: false);
    }
  }

  @override
  Future<String> login(GlobalKey<FormState> globalKey, String email,
      String pass, BuildContext context) async {
    if (validate(globalKey)) {
      context.read<AuthCubit>().eventOccurred = false;
      context.read<AuthCubit>().emit(Loading());
      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: pass,
        );
        context.read<AuthCubit>().eventOccurred = true;
        context.read<AuthCubit>().emit(Loading());
        context.read<AuthCubit>().eventOccurred = true;
        // SharedPreferences prefs = await SharedPreferences.getInstance();
        // prefs.setString('userEmail', email);
        // prefs.setString('userPass', pass);

        print('Login Successfully');
        GoRouter.of(context).go(AppRouter.kHomeView);
        saveUserId(userCredential.user!.uid);
        getId();
        return userCredential.user!.uid;
      } on FirebaseAuthException catch (e) {
        context.read<AuthCubit>().eventOccurred = true;
        context.read<AuthCubit>().emit(Loading());

        showToast(context: context, msg: e.toString(), done: false);
      }
    }
    return '';
  }

  @override
  void register(GlobalKey<FormState> globalKey, String email, String pass,
      BuildContext context) async {
    if (validate(globalKey)) {
      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: pass,
        );

        GoRouter.of(context).push(AppRouter.kHomeView);
      } on FirebaseAuthException catch (e) {
        showToast(context: context, msg: e.toString(), done: false);
      }
    }
  }

  @override
  void sendPhoneVerification(GlobalKey<FormState> globalKey, String phoneNumber,
      BuildContext context) async {
    if (validate(globalKey)) {
      try {
        confirmationResult = await auth.signInWithPhoneNumber(
          '+2$phoneNumber',
          // RecaptchaVerifier(
          //   container: 'recaptcha',
          //   size: RecaptchaVerifierSize.compact,
          //   theme: RecaptchaVerifierTheme.dark,
          //   auth: RecaptchaVerifier(auth: auth),
          // ),
        );
        GoRouter.of(context).push(AppRouter.kVerificationView);
      } on FirebaseAuthException catch (e) {
        showToast(context: context, msg: e.toString(), done: false);
      }
    }
  }

  @override
  bool validate(GlobalKey<FormState> globalKey) {
    if (globalKey.currentState!.validate()) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<void> addUserToDatabase(
      {required String name,
      required String email,
      required String pass,
      required String phone}) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    var user = <String, dynamic>{
      "name": name,
      "email": email,
      "phone": phone,
      "password": pass,
      "date": Timestamp.now(),
    };

    db.collection("users").add(user).then((documentSnapshot) {
      print("Added Data with ID: ${documentSnapshot.id}");

      id = documentSnapshot.id;
      saveUserId(id);
      user = <String, dynamic>{
        "id": documentSnapshot.id,
        "name": name,
        "email": email,
        "phone": phone,
        "password": pass,
        "date": Timestamp.now(),
      };
      db
          .collection("users")
          .doc(documentSnapshot.id)
          .set(user)
          .onError((e, _) => print("Error writing document: $e"));
    });
  }

  @override
  void directRegister({
    required GlobalKey<FormState> globalKey,
    required BuildContext context,
    required String name,
    required String email,
    required String pass,
    required String phone,
  }) {
    if (validate(globalKey)) {
      register(globalKey, email, pass, context);
      addUserToDatabase(name: name, email: email, pass: pass, phone: phone);
    }
  }

  @override
  void updatePersonDetails(
    String name,
    String phone,
    String image,
  ) async {
    try {
      String id = await getId();
      // Reference to the document you want to update
      DocumentReference documentRef =
          FirebaseFirestore.instance.collection('moaz').doc(id);

      // Update specific fields in the document
      await documentRef.update({
        'name': name,
        'phone': phone,
        'imageUrl': image,
      });

      print('Data updated successfully!');
    } catch (e) {
      print('Error updating data: $e');
    }
  }

  @override
  Future<void> saveUserId(String userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('usertest', userId);

    //////
    String? userUId = prefs.getString('usertest');
    id = userUId ?? '';
  }

  @override
  Future<String> getId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('usertest');
    id = userId ?? '';
    return userId!;
  }

  @override
  void testRegister(
    String email,
    String pass,
    String name,
    String phone,
    BuildContext context,
  ) async {
    if (validate(context.read<AuthCubit>().registerFormKey)) {
      try {
        context.read<AuthCubit>().eventOccurred = false;
        context.read<AuthCubit>().emit(Loading());
        print('Start Register');
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: pass,
        );
        print('End Register');

        String userId = userCredential.user!.uid;
        await saveUserId(userId);
        print(await getId());
        print('Start Store Data');

        FirebaseFirestore db = FirebaseFirestore.instance;

        UserModel userModel = UserModel(
          id: userId,
          name: name,
          email: email,
          phone: phone,
          password: pass,
          date: Timestamp.now(),
          imageUrl:
              'https://firebasestorage.googleapis.com/v0/b/find-missing-children.appspot.com/o/user%20images%2Fdefault%20user.png?alt=media&token=39a16367-b33a-4ad4-b711-b5737bfa424e',
        );

        db
            .collection("moaz")
            .doc(userId)
            // .set(user)
            .set(userModel.toMap())
            .onError((e, _) => print("Error writing document: $e"));
        print('End Store Data');
        GoRouter.of(context).push(AppRouter.kHomeView);
      } catch (e) {
        context.read<AuthCubit>().eventOccurred = true;
        context.read<AuthCubit>().emit(Loading());
        showToast(
            context: context,
            msg: 'Error in Register: ${e.toString()}',
            done: false);
        print('Error is in register: $e');
      }
    }
  }
}
