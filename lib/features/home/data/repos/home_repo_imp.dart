import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find_missing_test/constants.dart';
import 'package:find_missing_test/core/models/user_mode.dart';
import 'package:find_missing_test/core/utils/app_Strings.dart';
import 'package:find_missing_test/core/widgets/core/show_toast.dart';
import 'package:find_missing_test/features/home/domain/repos/home_repo.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../cubit/home_cubit.dart';

class HomeRepoImp extends HomeRepo {
  @override
  bool validate(GlobalKey<FormState> globalKey) {
    if (globalKey.currentState!.validate()) {
      return true;
    } else {
      return false;
    }
  }

  @override
  addNewMissingCild(
      GlobalKey<FormState> globalKey,
      bool missing,
      String name,
      String age,
      String address,
      String details,
      BuildContext context,
      bool isSelectImage,
      File file) async {
    if (validate(globalKey)) {
      if (isSelectImage) {
        try {
          String imageName = await upLoadImageToFirebaseStorage(file, name);
          String imageUrl = await getImageUrl(imageName);
          FirebaseFirestore.instance
              .collection(AppStrings.missingChildrensCollection)
              .add({
            'missing': missing,
            'Name': name,
            'Age': age,
            'Address': address,
            'details': details,
            'timestamp': Timestamp.now(),
            'image name': imageName,
            'image url': imageUrl,
          }).then((value) {
            print('Data added successfully!');
            showToast(context: context, msg: 'Successfully!', done: true);

            context.read<HomeCubit>().nextPage(0, context);
          }).catchError((error) {
            showToast(
                context: context, msg: 'Failed to add: $error', done: false);
          });
        } catch (e) {
          showToast(context: context, msg: e.toString(), done: false);
        }
      } else {
        showToast(
            context: context, msg: 'Please Choose Child Image', done: false);
      }
    }
  }

  @override
  addImageToFirebaseStorage() {}

  // dont Use
  @override
  Future<Uint8List> selectImage() async {
    // dont Use
    final picker = ImagePicker();
    XFile? imageFile = await picker.pickImage(source: ImageSource.gallery);

    File file = File(imageFile!.path);
    List<int> imageBytes = await file.readAsBytes();

    return Uint8List.fromList(imageBytes);
  }

  @override
  Future<String> upLoadImageToFirebaseStorage(File filee, String name) async {
    String imageName =
        '${AppStrings.missingChildrensImages}/$name${DateTime.now().minute.toString()}.jpg';
    try {
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference storageReference = storage.ref().child(imageName);

      await storageReference.putFile(filee);
      print('Image uploaded successfully!');
      return '$name${DateTime.now().minute.toString()}.jpg';
    } catch (e) {
      print('Error uploading image: $e');
      return '';
    }
  }

  @override
  Future<String> getImageUrl(String imageName) async {
    try {
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference storageReference = storage
          .ref()
          .child('${AppStrings.missingChildrensImages}/$imageName');

      String downloadURL = await storageReference.getDownloadURL();

      return downloadURL;
    } catch (e) {
      print('Error getting image URL: $e');
      return '';
    }
  }

  // @override
  // Future<List<UserModel>> getdata() async {
  //   print('starthere============');
  //   List<UserModel>? users = [];

  //   await FirebaseFirestore.instance
  //       // .collection('test')
  //       .collection(AppStrings.users)
  //       .get()
  //       .then((QuerySnapshot querySnapshot) {
  //     int len = querySnapshot.size;
  //     for (int i = 0; i < len; i++) {
  //       print(UserModel.fromJson(querySnapshot.docs[i]).name);
  //       users!.add(UserModel.fromJson(querySnapshot.docs[i]));
  //       print(users.length);
  //     }

  //     print('============');
  //     print(users.length);
  //   });

  //   return users;
  // }
  UserModel? user;

  @override
  Future<UserModel> getdata() async {
    // List<UserModel>? users = [];

    await FirebaseFirestore.instance
        // .collection(AppStrings.users)
        .collection('moaz')
        .doc(id)
        // .where('id', isEqualTo: id)
        .get()
        .then((value) {
      print(UserModel.fromJson(value).name);
      user = UserModel.fromJson(value);
    });

    return user!;
  }

//--------------------------------

  // var m;
  // FirebaseFirestore.instance
  //     .collection(AppStrings.users)
  //     .get()
  //     .then((QuerySnapshot querySnapshot) {
  //   querySnapshot.docs.forEach((doc) {
  //     // print(doc['name']);
  //     m = doc['name'];
  //   });
  // });
  // print(m);
  // return m;
}
