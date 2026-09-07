import 'package:lastspot_app/core/base_import.dart';

class ViewSpotButton extends StatelessWidget {
  final VoidCallback onTap;
  final String label;

  const ViewSpotButton({super.key, required this.onTap, required this.label});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: Dimensions.r16.dynamicW, vertical: Dimensions.r10.dynamicH),
        decoration: BoxDecoration(
          color: context.primaryColor,
          borderRadius: BorderRadius.circular(Dimensions.r12.dynamicR),
          boxShadow: [
            BoxShadow(color: context.primaryColor.withValues(alpha: 0.35), blurRadius: 8, offset: const Offset(0, 3)),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                color: AppColor.whiteColor,
                fontSize: Dimensions.r13.dynamicSP,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(width: Dimensions.r4.dynamicW),
            Icon(Icons.arrow_forward, color: AppColor.whiteColor, size: Dimensions.r14.dynamicH),
          ],
        ),
      ),
    );
  }
}
