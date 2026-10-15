import 'package:lastspot_app/core/base_import.dart';
import '../bloc/conversations_cubit.dart';
import 'conversations_tab_view.dart';

class ChatsScreenMobile extends StatelessWidget {
  const ChatsScreenMobile({super.key});

  Future<void> _onRefresh(BuildContext context) async {
    context.read<ConversationsCubit>().loadConversations(isRefresh: true);
    await Future.delayed(const Duration(milliseconds: 600));
  }

  @override
  Widget build(BuildContext context) {
    final loc = context.loc;

    return Scaffold(
      backgroundColor: context.backgroundColor,
      appBar: CustomAppBar.dashboard(context: context, title: loc.navChats),
      body: SafeArea(
        top: false,
        child: RefreshIndicator(
          onRefresh: () => _onRefresh(context),
          child: const SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: ConversationsTabView(),
          ),
        ),
      ),
    );
  }
}
