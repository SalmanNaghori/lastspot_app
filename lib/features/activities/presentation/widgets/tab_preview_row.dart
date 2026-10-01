import 'package:lastspot_app/core/base_import.dart';

class TabPreviewRow extends StatelessWidget {
  final String text;

  const TabPreviewRow({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Dimensions.r16.dynamicW,
        vertical: Dimensions.r12.dynamicH,
      ),
      decoration: BoxDecoration(
        color: context.surfaceContainerLow,
        borderRadius: BorderRadius.circular(Dimensions.r8.dynamicR),
      ),
      child: Text(
        text,
        style: context.bodySmall?.copyWith(color: context.textSecondary),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
