import 'package:flutter/material.dart';

import '../../../../core/widgets/responsive_layout.dart';
import 'chat_screen_mobile.dart';
import 'chat_screen_tablet.dart';
class ChatScreen extends StatelessWidget {
  final String postId;
  const ChatScreen({super.key, required this.postId});

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobile: ChatScreenMobile(postId: postId),
      tablet: ChatScreenTablet(postId: postId),
    );
  }
}
