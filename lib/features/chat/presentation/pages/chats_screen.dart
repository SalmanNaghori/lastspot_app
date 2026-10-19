import 'package:lastspot_app/core/base_import.dart';
import '../bloc/conversations_cubit.dart';
import 'chats_screen_mobile.dart';
import 'chats_screen_tablet.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ConversationsCubit>.value(
      value: sl<ConversationsCubit>()..loadConversations(),
      child: const ResponsiveLayout(
        mobile: ChatsScreenMobile(),
        tablet: ChatsScreenTablet(),
      ),
    );
  }
}
