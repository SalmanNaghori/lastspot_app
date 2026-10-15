import 'package:intl/intl.dart';
import '../../../../core/base_import.dart';

/// WhatsApp-style centered floating date badge separator.
class ChatDateChip extends StatelessWidget {
  final DateTime date;

  const ChatDateChip({super.key, required this.date});

  String _formatDate(BuildContext context) {
    final now = DateTime.now();
    final local = date.toLocal();
    final today = DateTime(now.year, now.month, now.day);
    final messageDate = DateTime(local.year, local.month, local.day);

    final diffDays = today.difference(messageDate).inDays;
    if (diffDays == 0) {
      return context.loc.today;
    } else if (diffDays == 1) {
      return context.loc.yesterday;
    } else if (now.year == local.year) {
      return DateFormat('d MMMM').format(local);
    } else {
      return DateFormat('d MMMM yyyy').format(local);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;

    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: colors.surfaceContainerHighest.withValues(alpha: 0.85),
          borderRadius: AppRadius.pillBorderRadius,
          border: Border.all(
            color: colors.outlineVariant.withValues(alpha: 0.4),
            width: 0.5,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColor.blackColor.withValues(alpha: 0.04),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Text(
          _formatDate(context),
          style: context.labelSmall?.copyWith(
            color: colors.onSurfaceVariant,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
