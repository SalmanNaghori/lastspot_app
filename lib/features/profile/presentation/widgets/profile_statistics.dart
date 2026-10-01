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
    final loc = context.loc;

    return Container(
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(Dimensions.r16),
        border: Border.all(
          color: context.colorScheme.outlineVariant,
          width: 0.5,
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: Dimensions.r16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _StatItem(count: createdCount, label: loc.statCreated),
          Container(
            width: 1,
            height: 40,
            color: context.colorScheme.outlineVariant,
          ),
          _StatItem(count: joinedCount, label: loc.statJoined),
          Container(
            width: 1,
            height: 40,
            color: context.colorScheme.outlineVariant,
          ),
          _StatItem(count: completedCount, label: loc.statCompleted),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final int count;
  final String label;

  const _StatItem({required this.count, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          count.toString(),
          style: context.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: context.labelMedium?.copyWith(
            color: context.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
