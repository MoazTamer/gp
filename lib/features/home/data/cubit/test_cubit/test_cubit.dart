import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find_missing_test/core/models/comment_model.dart';
import 'package:find_missing_test/core/models/post_model.dart';
import 'package:find_missing_test/features/home/presentation/widgets/comments_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'test_state.dart';

class TestCubit2 extends Cubit<TestState2> {
  TestCubit2() : super(HomeInitial());

  void showBootomSheet(
      {required BuildContext context,
      required int index,
      required List<String> postsId}) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return CommentsListView(
          postId: postsId,
          index: index,
        );
      },
    );
    await getComments(index, postsId);
  }

  List<CommentModel> comments = [];
  Future<void> getComments(int index, List<String> postsId) async {
    comments = [];
    emit(GetCommentsLoadingState2());

    await FirebaseFirestore.instance
        .collection('posts')
        .doc(postsId[index])
        .collection('comments')
        .get()
        .then((value) {
      for (var element in value.docs) {
        comments.add(CommentModel.fromJson(element.data()));
      }
      emit(GetCommentsSuccessState2());
    }).catchError((error) {
      emit(GetCommentsErrorState2(error: error));
    });
  }

  List<PostModel> postsForUser2 = [];
  List<String> postsIdForUser2 = [];
  List<int> numOfCommentsForUser2 = [];

  void getPostsForUserttt({required String id}) async {
    postsForUser2 = [];
    postsIdForUser2 = [];
    numOfCommentsForUser2 = [];
    emit(GetCommentsLoadingState0());

    await FirebaseFirestore.instance.collection('posts').get().then((value) {
      for (var element in value.docs) {
        element.reference.collection('comments').get().then((value) {
          if (id == element.data()['id']) {
            print('your id:$id');
            print('another id is :${element.data()['id']}');
            print('another id is :${element.data()['name']}');
            numOfCommentsForUser2.add(value.docs.length);
            postsForUser2.add(PostModel.fromJson(element.data()));
            postsIdForUser2.add(element.id);
          }
        }).catchError((e) {
          print('error in get Posts is $e');
        });
      }
      emit(GetCommentsSuccessState0());
    }).catchError((error) {
      emit(GetCommentsErrorState0(error: error));
    });
  }
}
