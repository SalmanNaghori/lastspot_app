import 'package:lastspot_app/core/base_import.dart';
import '../../domain/entities/city_entity.dart';

/// A city choice that keeps the database-backed city ID as its identity.
class CityListTile extends StatelessWidget {
  final CityEntity city;
  final bool isSelected;
  final VoidCallback onTap;

  const CityListTile({
    super.key,
    required this.city,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(Dimensions.r12.dynamicR),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: Dimensions.r12.dynamicW,
            vertical: Dimensions.r10.dynamicH,
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? context.primaryColor.withValues(
                    alpha: context.isDarkMode ? 0.16 : 0.08,
                  )
                : Colors.transparent,
            borderRadius: BorderRadius.circular(Dimensions.r12.dynamicR),
            border: Border.all(
              color: isSelected
                  ? context.primaryColor.withValues(alpha: 0.5)
                  : Colors.transparent,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: Dimensions.r32.dynamicW,
                height: Dimensions.r32.dynamicH,
                decoration: BoxDecoration(
                  color: isSelected
                      ? context.primaryColor.withValues(alpha: 0.15)
                      : context.surfaceColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.location_on_rounded,
                  size: Dimensions.r16.dynamicH,
                  color: isSelected
                      ? context.primaryColor
                      : context.textSecondary,
                ),
              ),
              SizedBox(width: Dimensions.r12.dynamicW),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      city.formattedName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: Dimensions.r15.dynamicSP,
                        fontWeight: isSelected
                            ? FontWeight.w800
                            : FontWeight.w600,
                        color: isSelected
                            ? context.primaryColor
                            : context.textPrimary,
                      ),
                    ),
                    if (city.formattedState?.isNotEmpty == true)
                      Text(
                        city.formattedState!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: Dimensions.r12.dynamicSP,
                          color: context.textSecondary,
                        ),
                      ),
                  ],
                ),
              ),
              if (isSelected)
                Container(
                  padding: EdgeInsets.all(Dimensions.r4.dynamicW),
                  decoration: BoxDecoration(
                    color: context.primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check,
                    size: Dimensions.r12.dynamicH,
                    color: AppColor.whiteColor,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
