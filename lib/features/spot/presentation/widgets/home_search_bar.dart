import 'package:lastspot_app/core/base_import.dart';

class HomeSearchBar extends StatelessWidget {
  final VoidCallback? onFilterTap;
  final ValueChanged<String>? onChanged;

  const HomeSearchBar({super.key, this.onFilterTap, this.onChanged});

  @override
  Widget build(BuildContext context) {
    final loc = context.loc;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Dimensions.r16.dynamicW),
      child: Container(
        height: Dimensions.r24.dynamicH * 2.0,
        decoration: BoxDecoration(
          color: context.surfaceColor,
          borderRadius: BorderRadius.circular(Dimensions.r12.dynamicR),
          border: Border.all(color: context.borderColor, width: 1),
          boxShadow: [
            BoxShadow(
              color: AppColor.blackColor.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: TextField(
          onChanged: onChanged,
          style: TextStyle(
            fontSize: Dimensions.r14.dynamicSP,
            color: context.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: loc.searchHint,
            hintStyle: TextStyle(
              fontSize: Dimensions.r14.dynamicSP,
              color: context.textTertiary,
            ),
            prefixIcon: Icon(
              Icons.search,
              color: context.textSecondary,
              size: Dimensions.r20.dynamicH,
            ),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(
              vertical: Dimensions.r14.dynamicH,
            ),
          ),
        ),
      ),
    );
  }
}
