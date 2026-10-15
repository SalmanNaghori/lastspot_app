import '../../../../core/base_import.dart';
import '../../../spot/domain/entities/join_request_entity.dart';
import '../../../spot/domain/entities/request_entity.dart';
import 'group_info_screen_mobile.dart';

/// Tablet view for Group Info screen.
class GroupInfoScreenTablet extends StatelessWidget {
  final RequestEntity post;
  final List<JoinRequestEntity> confirmedPlayers;
  final String? currentUserId;
  final VoidCallback onBack;

  const GroupInfoScreenTablet({
    super.key,
    required this.post,
    required this.confirmedPlayers,
    this.currentUserId,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: context.backgroundColor,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: Dimensions.detailsMaxWidth,
          ),
          child: GroupInfoScreenMobile(
            post: post,
            confirmedPlayers: confirmedPlayers,
            currentUserId: currentUserId,
            onBack: onBack,
          ),
        ),
      ),
    );
  }
}
