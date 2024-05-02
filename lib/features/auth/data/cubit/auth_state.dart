part of 'auth_cubit.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class NextBage extends AuthState {}

class GetUserDeatailsLoadState extends AuthState {}

class GetUserDeatailsSuccessState extends AuthState {}

class EditProfile extends AuthState {}

class GetImageSuucess extends AuthState {}

class ProfileImagePickedSuccessState extends AuthState {}

class ProfileImagePickedErrorState extends AuthState {}

class UploadProfileImageErrorState extends AuthState {}

class UserUpdateLoadingState extends AuthState {}

class UploadProfileImageSuccessState extends AuthState {}

// create post

class CreatePostLoadingState extends AuthState {}

class CreatePostSuccessState extends AuthState {}

class CreatePostErrorState extends AuthState {}

class PostImagePickedSuccessState extends AuthState {}

class PostImagePickedErrorState extends AuthState {}

class SocialRemovePostImageState extends AuthState {}

class GetPostsSuccessState extends AuthState {}

class GetPostsErorrState extends AuthState {}

class GetPostsForUserSuccessState extends AuthState {}

class GetPostsForUserErorrState extends AuthState {}

class ChooseImage extends AuthState {}

class GetCommentsSuccessState extends AuthState {}

class GetCommentsLoadingState extends AuthState {}

class GetCommentsErorrState extends AuthState {
  final String error;

  GetCommentsErorrState(this.error);
}

class CreateCommentLoadingState extends AuthState {}

class CreateCommentSuccessState extends AuthState {}

class CreateCommentErrorState extends AuthState {
  final String error;

  CreateCommentErrorState(this.error);
}

class WriteComment extends AuthState {}

class GetAllUserLoadingState extends AuthState {}

class GetAllUserSuuccessState extends AuthState {}

class GetAllUserErrorState extends AuthState {
  final String error;
  GetAllUserErrorState(this.error);
}

class SendMessageSuuccessState extends AuthState {}

class SendMessaeErrorState extends AuthState {
  final String error;
  SendMessaeErrorState(this.error);
}

class GetMessageSuuccessState extends AuthState {}

class GetUserByIdLoadingState extends AuthState {}

class GetUserByIdSuuccessState extends AuthState {}

class GetPostsForUserLoadingState extends AuthState {}

class GetApiDataSuuccessState extends AuthState {}

class GetApiDataLoadingState extends AuthState {}

class ReState extends AuthState {}

class Loading extends AuthState {}
