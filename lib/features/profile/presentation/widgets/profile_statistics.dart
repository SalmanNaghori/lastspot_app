import 'package:lastspot_app/core/base_import.dart';

class ProfileStatistics extends StatelessWidget {
  final int createdCount;
  final int joinedCount;
  final int completedCount;

  const ProfileStatistics({
    super.key,
    required this.createdCount,
    required this.joinedCount,
    required this.completedCount,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = context.loc;

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(Dimensions.r16),
        border: Border.all(color: theme.colorScheme.outlineVariant, width: 0.5),
      ),
      padding: const EdgeInsets.symmetric(vertical: Dimensions.r16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStat(theme, count: createdCount, label: loc.statCreated),
          Container(
            width: 1,
            height: 40,
            color: theme.colorScheme.outlineVariant,
          ),
          _buildStat(theme, count: joinedCount, label: loc.statJoined),
          Container(
            width: 1,
            height: 40,
            color: theme.colorScheme.outlineVariant,
          ),
          _buildStat(theme, count: completedCount, label: loc.statCompleted),
        ],
      ),
    );
  }

  Widget _buildStat(
    ThemeData theme, {
    required int count,
    required String label,
  }) {
    return Column(
      children: [
        Text(
          count.toString(),
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: theme.textTheme.labelMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
