import 'package:find_missing_test/core/models/user_mode.dart';
import 'package:find_missing_test/core/utils/app_router.dart';
import 'package:find_missing_test/core/utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ChatView extends StatelessWidget {
  final UserModel userModel;

  const ChatView({super.key, required this.userModel});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return InkWell(
      onTap: () {
        GoRouter.of(context).push(AppRouter.kChatDetailsView, extra: userModel);
      },
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: size.height * 0.028,
              backgroundImage: NetworkImage(userModel.imageUrl!),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: size.height * 0.02),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userModel.name!,
                    // 'Moaz Tamer',
                    style: AppStyles.normal,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
