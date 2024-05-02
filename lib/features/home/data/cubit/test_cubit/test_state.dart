part of 'test_cubit.dart';

@immutable
sealed class TestState2 {}

final class HomeInitial extends TestState2 {}

class GetCommentsLoadingState2 extends TestState2 {}

class GetCommentsSuccessState2 extends TestState2 {}

class GetCommentsLoadingState0 extends TestState2 {}

class GetCommentsSuccessState0 extends TestState2 {}

class GetCommentsErrorState0 extends TestState2 {
  final String error;

  GetCommentsErrorState0({required this.error});
}

class GetCommentsErrorState2 extends TestState2 {
  final String error;

  GetCommentsErrorState2({required this.error});
}

final class GetPostsForOneUserLoadingStatess extends TestCubit2 {}

final class GetPostsForOneUserSuccessStatess extends TestCubit2 {}

final class GetPostsForOneUserErrorStatess extends TestCubit2 {}
