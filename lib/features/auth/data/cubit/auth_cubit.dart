import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:find_missing_test/constants.dart';
import 'package:find_missing_test/core/models/comment_model.dart';
import 'package:find_missing_test/core/models/message_model.dart';
import 'package:find_missing_test/core/models/post_model.dart';
import 'package:find_missing_test/core/models/similarity_model.dart';
import 'package:find_missing_test/core/models/user_mode.dart';
import 'package:find_missing_test/core/utils/app_router.dart';
import 'package:find_missing_test/core/widgets/core/show_toast.dart';
import 'package:find_missing_test/features/auth/data/repos/auth_repo_imp.dart';
import 'package:find_missing_test/features/home/data/cubit/home_cubit.dart';
import 'package:find_missing_test/features/home/data/repos/home_repo_imp.dart';
import 'package:find_missing_test/features/home/presentation/widgets/comments_list_view.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  final loginFormKey = GlobalKey<FormState>();
  final TextEditingController loginInputEmail = TextEditingController();
  final TextEditingController loginInputPass = TextEditingController();

  late String loginEmail = '';
  late String loginPass = '';

  final registerFormKey = GlobalKey<FormState>();
  final TextEditingController registerInputEmail = TextEditingController();
  final TextEditingController registerInputPass = TextEditingController();
  final TextEditingController registerInputPhone = TextEditingController();
  final TextEditingController registerInputName = TextEditingController();

  late String registerEmail = '';
  late String registerName = '';
  late String registerPhone = '';
  late String registerPass = '';

  late String pin = '';
  AuthRepoImpl authRepoImpl = AuthRepoImpl();

  //update
  final updateFormKey = GlobalKey<FormState>();
  final TextEditingController updateInputName = TextEditingController();
  final TextEditingController updateInputPhone = TextEditingController();
  late String updateName = '';
  late String updatePhone = '';

// for Pges Scroll
  int index = 0;

// for child images
  void changePage(int i) {
    index = i;
    emit(NextBage());
  }

  bool eventOccurred = true;

  @override
  void emit(AuthState state) {
    super.emit(state);
  }

  String lang = '';

  void changeLanguage({required String lang2}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (lang2 == 'ar') {
      await prefs.setString('lang', 'ar');
      lang = await prefs.getString('lang').toString();
      print(lang);
      emit(ReState());
    }
    if (lang2 == 'en') {
      await prefs.setString('lang', 'en');
      lang = await prefs.getString('lang').toString();
      print(lang);
      emit(ReState());
    }
  }

  void login(BuildContext context) async {
    String uId =
        await authRepoImpl.login(loginFormKey, loginEmail, loginPass, context);
    print('User Id ere===========$uId');
    id = uId;
  }

  void register(BuildContext context) async {
    authRepoImpl.register(
        registerFormKey, registerEmail, registerPass, context);
  }

  void directRegister(BuildContext context) {
    // authRepoImpl.directRegister(
    //     globalKey: registerFormKey,
    //     context: context,
    //     name: registerName,
    //     email: registerEmail,
    //     pass: registerPass,
    //     phone: registerPhone);

    authRepoImpl.testRegister(
      registerEmail,
      registerPass,
      registerName,
      registerPhone,
      context,
    );
  }

  void sendPhoneVerification(BuildContext context) async {
    authRepoImpl.sendPhoneVerification(registerFormKey, registerPhone, context);
  }

  void checkVerificationCode(BuildContext context) async {
    authRepoImpl.checkVerificationCode(
      globalKey: registerFormKey,
      context: context,
      email: registerEmail,
      name: registerName,
      pass: registerPass,
      phone: registerPhone,
      pin: pin,
    );
  }

// void sendEmailVerification() async {
//   try {
//     User? user = FirebaseAuth.instance.currentUser;
//
//     if (user != null && !user.emailVerified) {
//       await user.sendEmailVerification();
//
//       print('Verification email sent to ${user.email}');
//     } else {
//       print('User is null or email already verified.');
//     }
//   } on FirebaseAuthException catch (e) {
//     print('Error sending verification email: $e');
//   }
// }

  void updateData({required BuildContext context}) async {
    await uploadProfileImage(context);

    // authRepoImpl.updatePersonDetails(updateName, updatePhone, updateImage);
  }

  Uint8List? image;

  Future<String> getImageUrl(String imageName) async {
    try {
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference storageReference = storage.ref().child('images/$imageName');

      // Uint8List? mo = await storageReference.getData();
      String downloadURL = await storageReference.getDownloadURL();

      return downloadURL;
    } catch (e) {
      print('Error getting image URL: $e');
      return '';
    }
  }

  File file = File('');
  String updateImage = '';
  Future<void> uploadImage() async {
    final picker = ImagePicker();
    XFile? imageFile = await picker.pickImage(source: ImageSource.gallery);

    if (imageFile != null) {
      file = File(imageFile.path);
      List<int> imageBytes = await file.readAsBytes();
      image = Uint8List.fromList(imageBytes);
      emit(GetImageSuucess());

      try {
        String imgName = DateTime.now().minute.toString();
        FirebaseStorage storage = FirebaseStorage.instance;
        Reference storageReference = storage.ref().child('images/$imgName.jpg');

        await storageReference.putFile(file);
        print('Image uploaded successfully!');
        updateImage = await getImageUrl(imgName);
      } catch (e) {
        print('Error uploading image: $e');
      }
    }
  }

  // Edit Profile

  bool isEditProfile = false;
  editProfile() {
    isEditProfile = !isEditProfile;
    emit(EditProfile());
    print(isEditProfile);
  }

  ///////////////////////////////
  ///
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
    emit(GetUserDeatailsLoadState());
    userModel = await HomeRepoImp().getdata();
    // emit(getDeatailsSuccessState());
    // emit(GoToPage());
    emit(GetUserDeatailsSuccessState());
  }

// test Profile image
  File? profileImage;
  var picker = ImagePicker();

  Future<void> getProfileImage() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      print(pickedFile.path);
      emit(ProfileImagePickedSuccessState());
    } else {
      print('No image selected.');
      emit(ProfileImagePickedErrorState());
    }
  }

///////////
  Future<void> uploadProfileImage(BuildContext context) async {
    emit(UserUpdateLoadingState());
    profileImage ??= userModel!.imageUrl as File?;
    FirebaseStorage.instance
        .ref()
        .child('user images/${Uri.file(profileImage!.path).pathSegments.last}')
        .putFile(profileImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        print(value);

        updateImage = value;
        if (updateImage == '') {
          updateImage = userModel!.imageUrl!;
        }
        if (updateName == '') {
          updateName = userModel!.name!;
        }
        if (updatePhone == '') {
          updatePhone = userModel!.phone!;
        }
        authRepoImpl.updatePersonDetails(updateName, updatePhone, updateImage);
        getdataTest();
        showToast(
            context: context, msg: 'Data updated successfully!', done: true);

        emit(UploadProfileImageSuccessState());
      }).catchError((error) {
        showToast(
            context: context,
            msg: 'Error to updated data : $error',
            done: false);

        emit(UploadProfileImageErrorState());
      });
    }).catchError((error) {
      showToast(
          context: context, msg: 'Error to updated data : $error', done: false);

      emit(UploadProfileImageErrorState());
    });
  }

//
// Child Data
  final addChildFormKey = GlobalKey<FormState>();

  final TextEditingController addChildInputName = TextEditingController();
  final TextEditingController addChildInputAge = TextEditingController();
  final TextEditingController addChildInputAddress = TextEditingController();
  final TextEditingController addChildInputDetails = TextEditingController();

  late String childName = '';
  late String childAge = '';
  late String childAddress = '';
  late String childDetails = '';
  bool? missimg;
  String? missingClicked;

// test Create Post image
  File? postImage;

  Future<void> getPostImage() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      postImage = File(pickedFile.path);
      emit(PostImagePickedSuccessState());
    } else {
      print('No image selected.');
      emit(PostImagePickedErrorState());
    }
  }

  void removePostImage() {
    postImage = null;
    emit(SocialRemovePostImageState());
  }

  void uploadPostImage({
    required BuildContext context,
  }) {
    context.read<AuthCubit>().eventOccurred = false;

    if (addChildFormKey.currentState!.validate()) {
      if (postImage != null) {
        emit(CreatePostLoadingState());

        FirebaseStorage.instance
            .ref()
            .child('posts/${Uri.file(postImage!.path).pathSegments.last}')
            .putFile(postImage!)
            .then((value) {
          value.ref.getDownloadURL().then((value) async {
            print(value);
            await createPost(
              context: context,
              postImage: value,
            );
            context.read<AuthCubit>().eventOccurred = true;
            postImage = null;
            missimg = null;
          }).catchError((error) {
            context.read<AuthCubit>().eventOccurred = true;

            emit(CreatePostErrorState());
          });
        }).catchError((error) {
          context.read<AuthCubit>().eventOccurred = true;

          emit(CreatePostErrorState());
        });
      } else {
        emit(ChooseImage());
        getPostImage();
      }
    }
  }

  Future<void> createPost({
    required BuildContext context,
    required String postImage,
  }) async {
    if (missimg != null) {
      context.read<AuthCubit>().eventOccurred = false;

      emit(CreatePostLoadingState());

      PostModel model = PostModel(
        name: userModel!.name ?? '',
        phone: userModel!.phone ?? '',
        image: userModel!.imageUrl ?? '',
        id: userModel!.id ?? '',
        dateTime: DateTime.now().toString(),
        childAddress: childAddress,
        childAge: childAge,
        childDetails: childDetails,
        childImage: postImage,
        childName: childName,
        date: Timestamp.now(),
        missing: missimg!,
      );

      await FirebaseFirestore.instance
          .collection('posts')
          .add(model.toMap())
          .then((value) {
        context.read<AuthCubit>().eventOccurred = true;
        emit(CreatePostSuccessState());
        getPosts();

        context.read<HomeCubit>().currentPage = 0;
      }).catchError((error) {
        context.read<AuthCubit>().eventOccurred = true;
        emit(CreatePostErrorState());
      });
    }
    if (missimg == null) {
      context.read<AuthCubit>().eventOccurred = true;

      Fluttertoast.showToast(
          msg: "Please choose 'missing' or 'no'",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  List<String> postsImgUrl = [];
  List<PostModel> posts = [];
  List<String> postsId = [];
  List<int> numOfComments = [];

  final TextEditingController searchTextEditingController =
      TextEditingController();
  String serchKey = '';
  void re() async {
    emit(ReState());
  }

  void getPosts() async {
    postsImgUrl = [];
    posts = [];
    postsId = [];
    numOfComments = [];
    await FirebaseFirestore.instance.collection('posts').get().then((value) {
      for (var element in value.docs) {
        // posts.add(PostModel.fromJson(element.data()));
        // postsId.add(element.id);
        element.reference.collection('comments').get().then((value) {
          numOfComments.add(value.docs.length);
          posts.add(PostModel.fromJson(element.data()));
          postsId.add(element.id);
          postsImgUrl.add(PostModel.fromJson(element.data()).childImage);

          emit(GetPostsSuccessState());
        }).catchError((e) {
          print('error in get Posts is $e');
        });
      }
      emit(GetPostsSuccessState());
    }).catchError((error) {
      emit(GetPostsErorrState());
    });
  }

// comments
  final TextEditingController inputComment = TextEditingController();
  late String yourComment = '';

  void createComment(String postId) async {
    emit(CreateCommentLoadingState());
    int randomNumber = Random().nextInt(10000 * Random().nextInt(1000));
    CommentModel commentModel = CommentModel(
      writerCommentName: userModel!.name!,
      comment: yourComment,
      date: Timestamp.now(),
      writerCommentId: userModel!.id!,
      writerCommentImage: userModel!.imageUrl!,
    );
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .doc('$randomNumber-${userModel!.id}')
        .set(commentModel.toMap())
        .then((value) {
      getPosts();
      emit(CreateCommentSuccessState());
    }).catchError((e) {
      emit(CreateCommentErrorState(e.toString()));
    });
  }

  void tsetBootomSheet(
      {required BuildContext context,
      required int index,
      required List<String> postsId}) async {
    await getComments(index: index, postsId: postsId);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext contextm) {
        return CommentsListView(
          postId: postsId,
          index: index,
        );
      },
    );
  }

  List<CommentModel> comments = [];
  Future<void> getComments({required int index, required List postsId}) async {
    comments = [];
    emit(GetCommentsLoadingState());
    print('========================');
    print('index is $index');

    await FirebaseFirestore.instance
        .collection('posts')
        .doc(postsId[index])
        .collection('comments')
        .get()
        .then((value) {
      for (var element in value.docs) {
        comments.add(CommentModel.fromJson(element.data()));
      }
      print('========================');
      print(comments.first.comment);
      print(comments.length);
      emit(GetCommentsSuccessState());
    }).catchError((error) {
      emit(GetCommentsErorrState(error.toString()));
    });
  }

  void writeComment() {
    if (yourComment.isNotEmpty) {
      emit(WriteComment());
    }
    if (yourComment.isEmpty) {
      emit(WriteComment());
    }
  }

  List<UserModel> users = [];
  getAllUsers() async {
    if (users.isEmpty) {
      emit(GetAllUserLoadingState());

      await FirebaseFirestore.instance.collection('moaz').get().then((value) {
        for (var element in value.docs) {
          if (element.data()['id'] != userModel!.id) {
            users.add(UserModel.fromJson(element));
          }
        }
        emit(GetAllUserSuuccessState());
      }).catchError((error) {
        emit(GetAllUserErrorState(error.toString()));
      });
    }
  }

  TextEditingController messageController = TextEditingController();
  Future<void> sendMessage(
      {required String recieverId, required String message}) async {
    MessageModel messageModel = MessageModel(
      senderId: userModel!.id,
      receiverId: recieverId,
      message: message,
      date: Timestamp.now(),
    );
    if (message.isNotEmpty) {
      await FirebaseFirestore.instance
          .collection('moaz')
          .doc(userModel!.id)
          .collection('chats')
          .doc(recieverId)
          .collection('messages')
          .add(messageModel.toMap())
          .then((value) {
        emit(SendMessageSuuccessState());
      }).catchError((error) {
        emit(SendMessaeErrorState(error.toString()));
      });

      await FirebaseFirestore.instance
          .collection('moaz')
          .doc(recieverId)
          .collection('chats')
          .doc(userModel!.id)
          .collection('messages')
          .add(messageModel.toMap())
          .then((value) {
        emit(SendMessageSuuccessState());
      }).catchError((error) {
        emit(SendMessaeErrorState(error.toString()));
      });
    }
  }

  List<MessageModel> messages = [];

  void getMessages({required String receiverId}) {
    FirebaseFirestore.instance
        .collection('moaz')
        .doc(userModel!.id)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .orderBy('date')
        .snapshots()
        .listen((event) {
      messages = [];

      for (var element in event.docs) {
        messages.add(MessageModel.fromJson(element.data()));
      }
      // messages = messages.reversed.toList();
      emit(GetMessageSuuccessState());
    });
  }

  List<PostModel> postsForUser = [];
  bool i = true;
  List<String> postsIdForUser = [];
  List<int> numOfCommentsForUser = [];

  void getPostsForUsert({required String id}) async {
    i = false;
    print('Start');
    postsForUser = [];
    postsIdForUser = [];
    numOfCommentsForUser = [];
    emit(GetPostsForUserLoadingState());

    await FirebaseFirestore.instance.collection('posts').get().then((value) {
      postsForUser = [];
      postsIdForUser = [];
      numOfCommentsForUser = [];

      for (var element in value.docs) {
        element.reference.collection('comments').get().then((value) {
          if (id == element.data()['id']) {
            postsForUser.add(PostModel.fromJson(element.data()));
            postsIdForUser.add(element.id);
            numOfCommentsForUser.add(value.docs.length);
            emit(GetPostsForUserSuccessState());
          }
        }).catchError((e) {
          print('error in get Posts is $e');
        });
      }
      i = false;
      print('end');

      emit(GetPostsForUserSuccessState());
    }).catchError((error) {
      emit(GetPostsForUserErorrState());
    });
  }

  UserModel? vistProfile = UserModel(
      id: 'id',
      name: 'name',
      email: 'email',
      phone: 'phone',
      password: 'password',
      date: Timestamp.now(),
      imageUrl: 'imageUrl');

  Future<void> getUserById({required String userId}) async {
    emit(GetUserByIdLoadingState());

    await FirebaseFirestore.instance
        .collection('moaz')
        .doc(userId)
        .get()
        .then((value) {
      vistProfile = UserModel.fromJson(value);
      emit(GetUserByIdSuuccessState());
    }).catchError((e) {
      print('error is: $e');
    });
  }

  List<PostModel> postsForVisitUser = [];
  List<String> postsIdForVisitUser = [];
  List<int> numOfCommentsForVisitUser = [];

  void getPostsForVisitUser({required String id}) async {
    postsForVisitUser = [];
    postsIdForVisitUser = [];
    numOfCommentsForVisitUser = [];

    await FirebaseFirestore.instance.collection('posts').get().then((value) {
      postsForVisitUser = [];
      postsIdForVisitUser = [];
      numOfCommentsForVisitUser = [];

      for (var element in value.docs) {
        element.reference.collection('comments').get().then((value) {
          if (id == element.data()['id']) {
            numOfCommentsForVisitUser.add(value.docs.length);
            postsForVisitUser.add(PostModel.fromJson(element.data()));
            postsIdForVisitUser.add(element.id);

            emit(GetPostsForUserSuccessState());
          }
        }).catchError((e) {
          print('error in get Posts is $e');
        });
      }

      emit(GetPostsForUserSuccessState());
    }).catchError((error) {
      emit(GetPostsForUserErorrState());
    });
  }

//api

  SimilarImagesModel modelApi = SimilarImagesModel(
    numberOfSimilarImages: 0,
    similarImages: [],
  );

  Future<void> fetchData(
      {required String imgUrl,
      required BuildContext context,
      required PostModel post}) async {
    postsForSimilarity = [];
    emit(GetApiDataLoadingState());
    print('start Api');

    Dio dio = Dio();
    try {
      const String url = 'https://moaztamer.pythonanywhere.com/';
      final response = await dio.post(
        url,
        data: jsonEncode({
          'imgUrl': imgUrl,
          'images': postsImgUrl,
        }),
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
      if (response.statusCode == 200) {
        print('Response data: ${response.data}');
        modelApi = SimilarImagesModel.fromJson(response.data);
        if (modelApi.numberOfSimilarImages! > 0) {
          await getPostsForSimilarity();
          showToast(
              context: context,
              msg: 'Similar Posts For this image',
              done: true);
        }
      } else {
        print('Error - Status Code: ${response.statusCode}');
        showToast(
            context: context,
            msg: 'Error - Status Code: ${response.statusCode}',
            done: false);
      }
    } catch (error) {
      getPostsForName(post: post);
      print('Dio Error: $error');
      showToast(
          context: context,
          msg: 'Error: in get Similarty between Simialr images',
          done: false);
    }
    print('End Api');
  }

  List<PostModel> postsForSimilarity = [];
  List<String> postsIdForSimilarity = [];
  List<int> numOfCommentsForSimilarity = [];

  // void getPostsForSimilarity({required SimilarImagesModel imgUrlList}) async {
  Future<void> getPostsForSimilarity() async {
    postsForSimilarity = [];
    postsIdForSimilarity = [];
    numOfCommentsForSimilarity = [];

    emit(GetApiDataLoadingState());

    await FirebaseFirestore.instance.collection('posts').get().then((value) {
      for (var element in value.docs) {
        element.reference.collection('comments').get().then((value) {
          // ملهاش لزمه
          for (var i = 0; i < modelApi.numberOfSimilarImages!; i++) {
            String imgUrl = modelApi.similarImages![i];

            if (imgUrl == element.data()['childImage']) {
              numOfCommentsForSimilarity.add(value.docs.length);
              postsForSimilarity.add(PostModel.fromJson(element.data()));
              postsIdForSimilarity.add(element.id);
              emit(GetApiDataSuuccessState());
            }
          }
        }).catchError((e) {
          print('error in get Posts is $e');
        });
      }
      emit(GetApiDataSuuccessState());
    }).catchError((error) {
      emit(GetPostsErorrState());
    });
  }

  // get similarty post between names
  Future<void> getPostsForName({required PostModel post}) async {
    postsForSimilarity = [];
    postsIdForSimilarity = [];
    numOfCommentsForSimilarity = [];

    emit(GetApiDataLoadingState());

    await FirebaseFirestore.instance.collection('posts').get().then((value) {
      for (var element in value.docs) {
        element.reference.collection('comments').get().then((value) {
          if ((post.childName == element.data()['childName']) ||
              (post.childAge == element.data()['childAge'])) {
            numOfCommentsForSimilarity.add(value.docs.length);
            postsForSimilarity.add(PostModel.fromJson(element.data()));
            postsIdForSimilarity.add(element.id);
            emit(GetApiDataSuuccessState());
          }
        }).catchError((e) {
          print('error in get Posts is $e');
        });
      }
      emit(GetApiDataSuuccessState());
    }).catchError((error) {
      emit(GetPostsErorrState());
    });
  }

// delete post
  void deleteDocumentByFields(
      {required String imgUrl, required BuildContext context}) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('posts')
        .where(
          'childImage',
          isEqualTo: imgUrl,
        )
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      for (DocumentSnapshot documentSnapshot in querySnapshot.docs) {
        try {
          await documentSnapshot.reference.delete();
          print('Post removed successfully');
          getPosts();

          showToast(
              context: context, msg: 'Post removed successfully', done: true);
        } catch (e) {
          print('Error removing document: $e');
          showToast(
              context: context,
              msg: 'Error removing document: $e',
              done: false);
        }
      }
    } else {
      print('No documents found matching the specified fields');
    }
  }

// Are you sure delete post
  void customeShowDialog(
      {required String imgUrl, required BuildContext context}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmation'),
          content: const Text('Are you sure you want to delete this post?'),
          actions: [
            MaterialButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            MaterialButton(
              child: const Text('Yes'),
              onPressed: () {
                deleteDocumentByFields(context: context, imgUrl: imgUrl);
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

// Are you sure LogOut
  void customeShowDialogLogOut({required BuildContext context}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmation'),
          content: const Text('Are you sure you want to Log out!'),
          actions: [
            MaterialButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            MaterialButton(
              child: const Text('Yes'),
              onPressed: () {
                userModel = UserModel(
                  id: 'id',
                  name: 'name',
                  email: 'email',
                  phone: 'phone',
                  password: 'password',
                  date: Timestamp.now(),
                  imageUrl: 'imageUrl',
                );
                posts = [];
                users = [];
                GoRouter.of(context).go(AppRouter.kLoginView);
              },
            ),
          ],
        );
      },
    );
  }
}
