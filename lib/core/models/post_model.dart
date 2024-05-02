import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find_missing_test/core/models/comment_model.dart';

class PostModel {
  final bool missing;
  final String name;
  final String id;
  final String image;
  final String phone;
  final String childImage;
  final String childName;
  final String childAddress;
  final String childAge;
  final String childDetails;
  final String dateTime;
  final Timestamp date;

  PostModel({
    required this.missing,
    required this.name,
    required this.id,
    required this.image,
    required this.phone,
    required this.childImage,
    required this.childName,
    required this.childAddress,
    required this.childAge,
    required this.childDetails,
    required this.dateTime,
    required this.date,
  });

  factory PostModel.fromJson(jsonData) {
    return PostModel(
      missing: jsonData['missing'],
      name: jsonData['name'],
      id: jsonData['id'],
      image: jsonData['imageUrl'],
      phone: jsonData['phone'],
      childImage: jsonData['childImage'],
      childName: jsonData['childName'],
      childAddress: jsonData['childAddress'],
      childAge: jsonData['childAge'],
      childDetails: jsonData['childDetails'],
      dateTime: jsonData['dateTime'],
      date: jsonData['date'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'missing': missing,
      'name': name,
      'imageUrl': image,
      'childImage': childImage,
      'childName': childName,
      'phone': phone,
      'childAddress': childAddress,
      'childAge': childAge,
      'childDetails': childDetails,
      'dateTime': dateTime,
      'date': Timestamp.now(),
    };
  }
}

// ----------------------

class NewPostModel {
  final bool missing;
  final String name;
  final String id;
  final String image;
  final String phone;
  final String childImage;
  final String childName;
  final String childAddress;
  final String childAge;
  final String childDetails;
  final String dateTime;
  final Timestamp date;
  late final List<CommentModel> commentModel;

  NewPostModel({
    required this.missing,
    required this.name,
    required this.id,
    required this.image,
    required this.phone,
    required this.childImage,
    required this.childName,
    required this.childAddress,
    required this.childAge,
    required this.childDetails,
    required this.dateTime,
    required this.date,
    required this.commentModel,
  });

  factory NewPostModel.fromJson(jsonData) {
    return NewPostModel(
      missing: jsonData['missing'],
      name: jsonData['name'],
      id: jsonData['id'],
      image: jsonData['imageUrl'],
      phone: jsonData['phone'],
      childImage: jsonData['childImage'],
      childName: jsonData['childName'],
      childAddress: jsonData['childAddress'],
      childAge: jsonData['childAge'],
      childDetails: jsonData['childDetails'],
      dateTime: jsonData['dateTime'],
      date: jsonData['date'],
      commentModel: [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'missing': missing,
      'name': name,
      'imageUrl': image,
      'childImage': childImage,
      'childName': childName,
      'phone': phone,
      'childAddress': childAddress,
      'childAge': childAge,
      'childDetails': childDetails,
      'dateTime': dateTime,
      'date': Timestamp.now(),
    };
  }
}
