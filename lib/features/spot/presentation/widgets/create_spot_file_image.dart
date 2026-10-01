import 'dart:io';
import 'package:lastspot_app/core/base_import.dart';

class CreateSpotFileImage extends StatelessWidget {
  final File file;
  final VoidCallback onRemove;

  const CreateSpotFileImage({
    super.key,
    required this.file,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 130.0.dynamicW,
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
            image: DecorationImage(image: FileImage(file), fit: BoxFit.cover),
          ),
        ),
        Positioned(
          top: -8,
          right: 4,
          child: GestureDetector(
            onTap: onRemove,
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
