import 'dart:io';

import 'package:find_missing_test/core/models/user_mode.dart';
import 'package:flutter/material.dart';

abstract class HomeRepo {
  bool validate(GlobalKey<FormState> globalKey);
  addNewMissingCild(
      GlobalKey<FormState> globalKey,
      bool missing,
      String name,
      String age,
      String address,
      String details,
      BuildContext context,
      bool isSelectImage,
      File file);
  addImageToFirebaseStorage();

  selectImage();
  Future<String> getImageUrl(String imageName);
  Future<String> upLoadImageToFirebaseStorage(File filee, String name);
  // upLoadImageToFirebaseStorage(File filee, String name);

  Future<UserModel> getdata();
}
