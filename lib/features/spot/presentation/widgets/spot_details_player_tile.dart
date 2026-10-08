import 'package:lastspot_app/core/base_import.dart';
import '../../domain/entities/join_request_entity.dart';
import 'spot_host_avatar.dart';

class SpotDetailsPlayerTile extends StatelessWidget {
  final JoinRequestEntity player;

  const SpotDetailsPlayerTile({super.key, required this.player});

  @override
  Widget build(BuildContext context) => ListTile(
    contentPadding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
    leading: SpotHostAvatar(
      name: player.userProfile?.fullName ?? context.loc.player,
      photoUrl: player.userProfile?.avatarUrl,
    ),
    title: Text(player.userProfile?.fullName ?? context.loc.player),
    trailing: Icon(
      Icons.check_circle_outline_rounded,
      color: context.colorScheme.primary,
    ),
  );
}
