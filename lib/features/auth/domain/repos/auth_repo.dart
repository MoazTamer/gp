import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

abstract class AuthRepo {
  late ConfirmationResult confirmationResult;
  FirebaseAuth auth = FirebaseAuth.instance;

  bool validate(GlobalKey<FormState> globalKey);
  Future<String> login(GlobalKey<FormState> globalKey, String email,
      String pass, BuildContext context);
  void register(GlobalKey<FormState> globalKey, String email, String pass,
      BuildContext context);
  void sendPhoneVerification(
      GlobalKey<FormState> globalKey, String phoneNumber, BuildContext context);
  void checkVerificationCode(
      {required GlobalKey<FormState> globalKey,
      required BuildContext context,
      required String name,
      required String email,
      required String pass,
      required String phone,
      required String pin});
  Future<void> addUserToDatabase({
    required String name,
    required String email,
    required String pass,
    required String phone,
  });

  void directRegister({
    required GlobalKey<FormState> globalKey,
    required BuildContext context,
    required String name,
    required String email,
    required String pass,
    required String phone,
  });

  void updatePersonDetails(String name, String phone, String image);
  Future<void> saveUserId(String data);
  Future<String> getId();

  void testRegister(
    String email,
    String pass,
    String name,
    String phone,
    BuildContext context,
  );
}
