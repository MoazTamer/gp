import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String? senderId;
  final String? receiverId;
  final Timestamp? date;
  final String? message;

  MessageModel({
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.date,
  });

  factory MessageModel.fromJson(jsonData) {
    return MessageModel(
      message: jsonData['message'],
      senderId: jsonData['senderId'],
      receiverId: jsonData['receiverId'],
      date: jsonData['date'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'message': message,
      'senderId': senderId,
      'receiverId': receiverId,
      'date': Timestamp.now(),
    };
  }
}
