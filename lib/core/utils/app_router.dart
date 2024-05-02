import 'package:find_missing_test/core/models/post_model.dart';
import 'package:find_missing_test/core/models/user_mode.dart';
import 'package:find_missing_test/features/home/presentation/widgets/chat_details_view.dart';
import 'package:find_missing_test/features/home/presentation/home_view.dart';
import 'package:find_missing_test/features/home/presentation/widgets/missing_list_view.dart';
import 'package:find_missing_test/features/home/presentation/person_visit_profile_view.dart';
import 'package:find_missing_test/features/home/presentation/similartity_view.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/login/login_view.dart';
import '../../features/auth/presentation/register/register_view.dart';
import '../../features/auth/presentation/register/verification_view.dart';
import '../../features/home/presentation/widgets/child_view.dart';

abstract class AppRouter {
  static const kLoginView = '/';
  static const kRegisterView = '/register';
  static const kVerificationView = '/VerificationView';
  static const kHomeView = '/homeView';
  static const kMissingListView = '/MissingListView';
  static const kChildView = '/ChildView';
  static const kChatDetailsView = '/ChatDetailsView';
  static const kPersonVisitProfileView = '/PersonVisitProfileView';
  static const ksimilarityView = '/similarityView';

  static final router = GoRouter(
    routes: [
      GoRoute(
        path: kLoginView,
        builder: (context, state) => const LoginView(),
      ),
      GoRoute(
        path: kRegisterView,
        builder: (context, state) => const RegisterView(),
      ),
      GoRoute(
        path: kHomeView,
        builder: (context, state) => const HomeView(),
      ),
      GoRoute(
        path: kMissingListView,
        builder: (context, state) => const MissingListView(),
      ),
      GoRoute(
        path: kChildView,
        builder: (context, state) => const ChildView(),
      ),
      GoRoute(
        path: kChatDetailsView,
        builder: (context, state) =>
            ChatDetailsView(userModel: state.extra as UserModel),
      ),
      GoRoute(
        path: kPersonVisitProfileView,
        builder: (context, state) => PersonVisitProfileView(
          userId: state.extra as String,
        ),
      ),
      GoRoute(
        path: ksimilarityView,
        builder: (context, state) => SimilartyListView(
          post: state.extra as PostModel,
        ),
      ),
      GoRoute(
        path: kVerificationView,
        builder: (context, state) => const VerificationView(),
      ),
    ],
  );
}
