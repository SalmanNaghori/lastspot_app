import 'package:lastspot_app/core/base_import.dart';
import '../../domain/policies/spot_participation_policy.dart';
import '../bloc/spot_details_bloc.dart';

enum SpotDetailsMenuAction { copy, edit, report }

class SpotDetailsMenuSheet extends StatelessWidget {
  final SpotDetailsLoaded loadedState;

  const SpotDetailsMenuSheet({super.key, required this.loadedState});

  @override
  Widget build(BuildContext context) {
    final loc = context.loc;
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.sm,
        0,
        AppSpacing.sm,
        AppSpacing.md,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Text(loc.detailsMenu, style: context.titleLarge),
          ),
          ListTile(
            leading: const Icon(Icons.copy_all_outlined),
            title: Text(loc.detailsCopy),
            onTap: () => Navigator.of(context).pop(SpotDetailsMenuAction.copy),
          ),
          if (SpotParticipationPolicy.canEdit(
            loadedState.post,
            isHost: loadedState.isHost,
          ))
            ListTile(
              leading: const Icon(Icons.edit_outlined),
              title: Text(loc.edit),
              onTap: () =>
                  Navigator.of(context).pop(SpotDetailsMenuAction.edit),
            ),
          if (!loadedState.isHost)
            ListTile(
              leading: Icon(
                Icons.flag_outlined,
                color: context.colorScheme.error,
              ),
              title: Text(loc.reportActivityAction),
              onTap: () =>
                  Navigator.of(context).pop(SpotDetailsMenuAction.report),
            ),
        ],
      ),
    );
  }
}
