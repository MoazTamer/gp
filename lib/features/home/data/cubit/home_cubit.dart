import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find_missing_test/core/models/user_mode.dart';
import 'package:find_missing_test/features/auth/data/cubit/auth_cubit.dart';
import 'package:find_missing_test/features/home/data/repos/home_repo_imp.dart';
import 'package:find_missing_test/features/home/presentation/widgets/add_post_test.dart';
import 'package:find_missing_test/features/home/presentation/widgets/chat_list_view.dart';
import 'package:find_missing_test/features/home/presentation/person_details_view.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../presentation/widgets/missing_list_view.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  int currentPage = 0;

  List<BottomNavigationBarItem> pages = const [
    BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: ''),
    BottomNavigationBarItem(icon: Icon(Icons.add_circle_outline), label: ''),
    BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outlined), label: ''),
    BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
  ];

  nextPage(int index, BuildContext context) {
    currentPage = index;
    if (index == 0) {
      emit(GoToPage());
      return const MissingListView();
    } else if (index == 1) {
      emit(GoToPage());
      return const AddPostTest();
    } else if (index == 2) {
      emit(GoToPage());
      return const ChatListView();
    } else {
      emit(GoToPage());
      return PersonDetailsView(
        userId: context.read<AuthCubit>().userModel!.id!,
      );
    }
  }

  pickImage(ImageSource imageSource) async {
    final ImagePicker _imagePacker = ImagePicker();
    XFile? _file = await _imagePacker.pickImage(source: imageSource);
    if (_file != null) {
      return await _file.readAsBytes();
    }
    print('No Image Selected');
  }

  Uint8List? image;

  Future<void> uploadImage() async {
    final picker = ImagePicker();
    XFile? imageFile = await picker.pickImage(source: ImageSource.gallery);

    if (imageFile != null) {
      File file = File(imageFile.path);
      List<int> imageBytes = await file.readAsBytes();
      image = Uint8List.fromList(imageBytes);
      try {
        FirebaseStorage storage = FirebaseStorage.instance;
        Reference storageReference = storage
            .ref()
            .child('images/${DateTime.now().minute.toString()}.jpg');

        await storageReference.putFile(file);
        print('Image uploaded successfully!');
      } catch (e) {
        print('Error uploading image: $e');
      }
    }
  }

  Future<Uint8List?> getImageUrl(String imageName) async {
    try {
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference storageReference = storage.ref().child('images/$imageName');

      Uint8List? downloadURL = await storageReference.getData();
      String mo = await storageReference.getDownloadURL();
      print('moaz');
      print(mo);
      print('moaz');
      return downloadURL;
    } catch (e) {
      print('Error getting image URL: $e');
      return null;
    }
  }

// getImage
  Uint8List? imageUrl;

// Moaz Tamer

  final addChildFormKey = GlobalKey<FormState>();

  final TextEditingController addChildInputName = TextEditingController();
  final TextEditingController addChildInputAge = TextEditingController();
  final TextEditingController addChildInputAddress = TextEditingController();
  final TextEditingController addChildInputDetails = TextEditingController();

  late String childName = '';
  late String childAge = '';
  late String childAddress = '';
  late String childDetails = '';

  void addNewMissingCild(BuildContext context) {
    HomeRepoImp().addNewMissingCild(
      addChildFormKey,
      true,
      childName,
      childAge,
      childAddress,
      childDetails,
      context,
      isSelectImage,
      file!,
    );
  }

  File? file;
  Uint8List? childImage;
  bool isSelectImage = false;

  Future<void> selectImage() async {
    final picker = ImagePicker();
    XFile? imageFile = await picker.pickImage(source: ImageSource.gallery);

    if (imageFile != null) {
      file = File(imageFile.path);
      List<int> imageBytes = await file!.readAsBytes();
      childImage = Uint8List.fromList(imageBytes);
      isSelectImage = true;
    }
  }

  removeImage() {
    childImage = null;
  }

  UserModel? userModel = UserModel(
    id: 'id',
    name: 'name',
    email: 'email',
    phone: 'phone',
    password: 'password',
    date: Timestamp.now(),
    imageUrl: '',
  );

  getdataTest() async {
    userModel = await HomeRepoImp().getdata();
  }
}
