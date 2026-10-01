import 'package:lastspot_app/core/base_import.dart';

class CreateSpotAddPhotoButton extends StatelessWidget {
  final VoidCallback onTap;

  const CreateSpotAddPhotoButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100.0.dynamicW,
        margin: EdgeInsets.only(right: Dimensions.r12.dynamicW),
        decoration: BoxDecoration(
          color: context.surfaceColor,
          border: Border.all(color: context.borderColor),
          borderRadius: BorderRadius.circular(Dimensions.r12.dynamicR),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.camera_alt_outlined, color: context.primaryColor),
            SizedBox(height: Dimensions.r8.dynamicH),
            Text(
              context.loc.addPhotos,
              style: TextStyle(
                color: context.primaryColor,
                fontSize: Dimensions.r12.dynamicSP,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
