import 'package:lastspot_app/core/base_import.dart';
import 'package:lastspot_app/core/widgets/app_cached_network_image.dart';

class SpotHostAvatar extends StatelessWidget {
  final String name;
  final String? photoUrl;

  const SpotHostAvatar({super.key, required this.name, this.photoUrl});

  String get _initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  @override
  Widget build(BuildContext context) {
    final hasPhoto = photoUrl != null && photoUrl!.trim().isNotEmpty;

    return CircleAvatar(
      radius: Dimensions.r20.dynamicR,
      backgroundColor: context.primaryColor,
      child: hasPhoto
          ? AppCachedNetworkImage(
              imageUrl: photoUrl!.replaceAll('/svg?', '/png?'),
              isCircle: true,
              width: Dimensions.r20.dynamicR * 2,
              height: Dimensions.r20.dynamicR * 2,
              memCacheWidth: 120,
              memCacheHeight: 120,
              errorWidget: Center(
                child: Text(
                  _initials,
                  style: TextStyle(
                    color: AppColor.whiteColor,
                    fontSize: Dimensions.r13.dynamicSP,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            )
          : Text(
              _initials,
              style: TextStyle(
                color: AppColor.whiteColor,
                fontSize: Dimensions.r13.dynamicSP,
                fontWeight: FontWeight.w700,
              ),
            ),
    );
  }
}
