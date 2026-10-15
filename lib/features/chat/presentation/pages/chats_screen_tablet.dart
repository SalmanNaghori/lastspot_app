import 'package:lastspot_app/core/base_import.dart';
import '../bloc/conversations_cubit.dart';
import 'conversations_tab_view.dart';

class ChatsScreenTablet extends StatelessWidget {
  const ChatsScreenTablet({super.key});

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
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 850),
            margin: EdgeInsets.all(Dimensions.r24.dynamicW),
            decoration: BoxDecoration(
              color: context.colorScheme.surface,
              borderRadius: BorderRadius.circular(Dimensions.r20.dynamicR),
              border: Border.all(
                color: AppColor.helpCardBorderColor,
                width: 0.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColor.blackColor.withValues(alpha: 0.04),
                  blurRadius: Dimensions.r20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(Dimensions.r20.dynamicR),
              child: RefreshIndicator(
                onRefresh: () => _onRefresh(context),
                child: const SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: ConversationsTabView(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
