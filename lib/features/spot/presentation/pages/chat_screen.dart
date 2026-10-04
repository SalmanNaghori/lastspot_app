import '../../../../core/base_import.dart';
import 'chat_screen_mobile.dart';
import 'chat_screen_tablet.dart';

class ChatScreen extends StatelessWidget {
  final String spotId;
  const ChatScreen({super.key, required this.spotId});

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobile: ChatScreenMobile(spotId: spotId),
      tablet: ChatScreenTablet(spotId: spotId),
    );
  }
}
