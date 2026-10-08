import 'package:lastspot_app/core/base_import.dart';

class SpotHostAvatar extends StatelessWidget {
  final String name;
  final String? photoUrl;

  const SpotHostAvatar({super.key, required this.name, this.photoUrl});

  String get _initials {
    final parts = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .toList();
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts[1][0]}'.toUpperCase();
    }
    return parts.isNotEmpty ? parts.first[0].toUpperCase() : '?';
  }

  @override
  Widget build(BuildContext context) {
    final hasPhoto = photoUrl != null && photoUrl!.trim().isNotEmpty;

    return CircleAvatar(
      radius: Dimensions.r20,
      backgroundColor: context.primaryColor,
      child: hasPhoto
          ? AppCachedNetworkImage(
              imageUrl: photoUrl!.replaceAll('/svg?', '/png?'),
              isCircle: true,
              width: Dimensions.r20 * 2,
              height: Dimensions.r20 * 2,
              memCacheWidth: 120,
              memCacheHeight: 120,
              errorWidget: Center(
                child: Text(
                  _initials,
                  style: TextStyle(
                    color: AppColor.whiteColor,
                    fontSize: Dimensions.r13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            )
          : Text(
              _initials,
              style: TextStyle(
                color: AppColor.whiteColor,
                fontSize: Dimensions.r13,
                fontWeight: FontWeight.w700,
              ),
            ),
    );
  }
}
