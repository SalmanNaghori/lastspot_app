import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_color.dart';
import '../../../../core/constants/dimensions.dart';

class ChatScreenMobile extends StatelessWidget {
  final String postId;
  const ChatScreenMobile({super.key, required this.postId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: const Text('Match Group Chat', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.chat_bubble_outline, size: Dimensions.r48.dynamicH, color: context.textSecondary),
                  SizedBox(height: Dimensions.r16.dynamicH),
                  Text(
                    'Chat coming soon!',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(color: context.textSecondary),
                  ),
                  SizedBox(height: Dimensions.r8.dynamicH),
                  Text(
                    'Realtime messaging will be available here.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: context.textSecondary),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(Dimensions.r16.dynamicW),
            decoration: BoxDecoration(
              color: context.surfaceColor,
              border: Border(top: BorderSide(color: context.borderColor)),
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      enabled: false,
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        filled: true,
                        fillColor: context.backgroundColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(Dimensions.r20.dynamicR),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: Dimensions.r16.dynamicW,
                          vertical: Dimensions.r8.dynamicH,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: Dimensions.r8.dynamicW),
                  CircleAvatar(
                    backgroundColor: AppColor.primaryColor,
                    child: IconButton(
                      icon: const Icon(Icons.send, color: AppColor.whiteColor),
                      onPressed: null,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
