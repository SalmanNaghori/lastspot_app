import 'package:lastspot_app/core/base_import.dart';
import '../../domain/entities/request_image_entity.dart';

class CreateSpotExistingImage extends StatelessWidget {
  final RequestImageEntity image;

  const CreateSpotExistingImage({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 130.0.dynamicW,
          height: double.infinity,
          margin: EdgeInsets.only(right: Dimensions.r12.dynamicW),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.r12.dynamicR),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(Dimensions.r12.dynamicR),
            child: AppCachedNetworkImage(
              imageUrl: image.storagePath,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: -8,
          right: 4,
          child: GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(context.loc.deleteImageNotSupported)),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: context.surfaceColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Icon(Icons.close, size: 16, color: context.textPrimary),
            ),
          ),
        ),
      ],
    );
  }
}
