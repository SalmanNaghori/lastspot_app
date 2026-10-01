import 'package:lastspot_app/core/base_import.dart';
import '../bloc/spot_details_bloc.dart';

class SpotDetailsMenuSheet extends StatelessWidget {
  final SpotDetailsLoaded loadedState;

  const SpotDetailsMenuSheet({super.key, required this.loadedState});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(Icons.share, color: context.textPrimary),
            title: Text(context.loc.share, style: context.bodyMedium),
            onTap: () {
              context.pop();
              // Implement share
            },
          ),
          if (loadedState.isHost) ...[
            ListTile(
              leading: Icon(Icons.edit, color: context.textPrimary),
              title: Text(context.loc.edit, style: context.bodyMedium),
              onTap: () {
                context.pop();
                context.safePush(AppRoutes.editSpot, extra: loadedState.post);
              },
            ),
            ListTile(
              leading: Icon(Icons.cancel, color: AppColor.errorColor),
              title: Text(
                context.loc.cancelActivity,
                style: context.bodyMedium?.copyWith(color: AppColor.errorColor),
              ),
              onTap: () {
                context.pop();
                // Implement cancel activity logic
              },
            ),
            ListTile(
              leading: Icon(Icons.close, color: context.textPrimary),
              title: Text(context.loc.closeActivity, style: context.bodyMedium),
              onTap: () {
                context.pop();
                // Implement close logic
              },
            ),
          ],
          if (!loadedState.isHost) ...[
            ListTile(
              leading: Icon(Icons.report, color: AppColor.errorColor),
              title: Text(
                context.loc.reportActivityAction,
                style: context.bodyMedium?.copyWith(color: AppColor.errorColor),
              ),
              onTap: () {
                context.pop();
                // Implement report logic
              },
            ),
          ],
        ],
      ),
    );
  }
}
