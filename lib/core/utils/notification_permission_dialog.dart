import 'package:flutter/material.dart';
import '../base_import.dart';
import '../services/push_notification_service.dart';
import '../di/service_locator.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationPermissionDialog {
  NotificationPermissionDialog._();

  static Future<void> requestPermissionWithDialog(BuildContext context) async {
    final fcm = FirebaseMessaging.instance;
    final settings = await fcm.getNotificationSettings();
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      return;
    }

    if (!context.mounted) return;

    final result = await AppBottomSheet.show<bool>(
      context: context,
      isScrollControlled: false,
      builder: (context) {
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(Dimensions.r20.dynamicW),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.notifications_active_outlined,
                  size: Dimensions.r64.dynamicH,
                  color: context.primaryColor,
                ),
                SizedBox(height: Dimensions.r16.dynamicH),
                Text(
                  AppString.notificationPermissionTitle,
                  style: context.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: Dimensions.r12.dynamicH),
                Text(
                  AppString.notificationPermissionBody,
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: context.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: Dimensions.r32.dynamicH),
                AppButton.primary(
                  label: AppString.allow,
                  onPressed: () => Navigator.of(context).pop(true),
                ),
                SizedBox(height: Dimensions.r12.dynamicH),
                AppButton.text(
                  label: AppString.notNow,
                  onPressed: () => Navigator.of(context).pop(false),
                ),
                SizedBox(height: Dimensions.r12.dynamicH),
              ],
            ),
          ),
        );
      },
    );

    if (result == true) {
      await sl<PushNotificationService>().requestPermission();
    }
  }
}
