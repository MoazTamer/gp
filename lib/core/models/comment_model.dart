import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  final String writerCommentName;
  final String writerCommentId;
  final String writerCommentImage;
  final String comment;
  final Timestamp date;

  CommentModel({
    required this.writerCommentName,
    required this.writerCommentId,
    required this.writerCommentImage,
    required this.comment,
    required this.date,
  });

  factory CommentModel.fromJson(jsonData) {
    return CommentModel(
      writerCommentName: jsonData['writerCommentName'],
      writerCommentId: jsonData['writerCommentId'],
      writerCommentImage: jsonData['writerCommentImage'],
      comment: jsonData['comment'],
      date: jsonData['date'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'comment': comment,
      'writerCommentId': writerCommentId,
      'writerCommentName': writerCommentName,
      'writerCommentImage': writerCommentImage,
      'date': Timestamp.now(),
    };
  }
}
