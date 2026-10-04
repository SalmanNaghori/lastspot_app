import 'package:lastspot_app/core/base_import.dart';
import '../../domain/entities/request_entity.dart';
import '../../domain/entities/join_request_entity.dart';
import '../bloc/spot_details_bloc.dart';

class SpotDetailsCtaButton extends StatelessWidget {
  final SpotDetailsLoaded loadedState;

  const SpotDetailsCtaButton({super.key, required this.loadedState});

  @override
  Widget build(BuildContext context) {
    final l10n = context.loc;
    final post = loadedState.post;
    final isHost = loadedState.isHost;
    final userRequest = loadedState.userJoinRequest;

    if (isHost) {
      return ElevatedButton(
        onPressed: () =>
            context.safePush(AppRoutes.manageRequestsPath(post.id)),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColor.secondaryColor,
          foregroundColor: AppColor.whiteColor,
          minimumSize: Size(double.infinity, Dimensions.r50.dynamicH),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Dimensions.r12.dynamicR),
          ),
        ),
        child: Text(
          l10n.manageMatchRequests,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      );
    }

    if (userRequest != null) {
      String text;
      Color bgColor;
      switch (userRequest.status) {
        case JoinRequestStatus.pending:
          text = l10n.pendingRequest;
          bgColor = AppColor.secondaryColor;
          break;
        case JoinRequestStatus.accepted:
          text = l10n.joined;
          bgColor = AppColor.successColor;
          break;
        case JoinRequestStatus.rejected:
          text = l10n.requestRejected;
          bgColor = AppColor.errorColor;
          break;
        case JoinRequestStatus.cancelled:
          text = l10n.requestCancelled;
          bgColor = context.textSecondary;
          break;
      }
      return ElevatedButton(
        onPressed: null,
        style: ElevatedButton.styleFrom(
          disabledBackgroundColor: bgColor.withValues(alpha: 0.5),
          disabledForegroundColor: AppColor.whiteColor,
          minimumSize: Size(double.infinity, Dimensions.r50.dynamicH),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Dimensions.r12.dynamicR),
          ),
        ),
        child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
      );
    }

    if (post.status != RequestStatus.open) {
      String text = post.status.name.toUpperCase();
      return ElevatedButton(
        onPressed: null,
        style: ElevatedButton.styleFrom(
          disabledBackgroundColor: context.textSecondary,
          disabledForegroundColor: AppColor.whiteColor,
          minimumSize: Size(double.infinity, Dimensions.r50.dynamicH),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Dimensions.r12.dynamicR),
          ),
        ),
        child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
      );
    }

    if (post.currentParticipants >= post.maxParticipants) {
      return ElevatedButton(
        onPressed: null,
        style: ElevatedButton.styleFrom(
          disabledBackgroundColor: AppColor.errorColor.withValues(alpha: 0.5),
          disabledForegroundColor: AppColor.whiteColor,
          minimumSize: Size(double.infinity, Dimensions.r50.dynamicH),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Dimensions.r12.dynamicR),
          ),
        ),
        child: Text(
          l10n.statusFull.toUpperCase(),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      );
    }

    if (post.eventDateTime.difference(DateTime.now()).inMinutes < 15) {
      return ElevatedButton(
        onPressed: null,
        style: ElevatedButton.styleFrom(
          disabledBackgroundColor: context.textSecondary,
          disabledForegroundColor: AppColor.whiteColor,
          minimumSize: Size(double.infinity, Dimensions.r50.dynamicH),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Dimensions.r12.dynamicR),
          ),
        ),
        child: Text(
          'JOINING CLOSED',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      );
    }

    return ElevatedButton(
      onPressed: () => context.read<SpotDetailsBloc>().add(
        RequestToJoinEvent(spotId: post.id),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColor.primaryColor,
        foregroundColor: AppColor.whiteColor,
        minimumSize: Size(double.infinity, Dimensions.r50.dynamicH),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimensions.r12.dynamicR),
        ),
      ),
      child: Text(
        l10n.requestToJoin,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}
