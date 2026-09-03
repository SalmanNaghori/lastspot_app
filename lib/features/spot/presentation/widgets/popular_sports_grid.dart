import 'package:lastspot_app/core/base_import.dart';

class PopularSportsGrid extends StatelessWidget {
  final ValueChanged<String> onSportTap;

  const PopularSportsGrid({super.key, required this.onSportTap});

  static const List<_PopularSport> _sports = [
    _PopularSport(
      name: 'Cricket',
      icon: Icons.sports_cricket,
      bgColor: Color(0xFFD1FAE5),
      iconColor: Color(0xFF059669),
    ),
    _PopularSport(
      name: 'Football',
      icon: Icons.sports_soccer,
      bgColor: Color(0xFFDBEAFE),
      iconColor: Color(0xFF2563EB),
    ),
    _PopularSport(
      name: 'Badminton',
      icon: Icons.sports_tennis,
      bgColor: Color(0xFFFFEDD5),
      iconColor: Color(0xFFF97316),
    ),
    _PopularSport(
      name: 'Tennis',
      icon: Icons.sports_tennis,
      bgColor: Color(0xFFEDE9FE),
      iconColor: Color(0xFF7C3AED),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Dimensions.r64.dynamicH * 1.55,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: Dimensions.r16.dynamicW),
        itemCount: _sports.length,
        separatorBuilder: (_, _) => SizedBox(width: Dimensions.r12.dynamicW),
        itemBuilder: (context, index) {
          final sport = _sports[index];
          return _PopularSportCard(
            sport: sport,
            onTap: () => onSportTap(sport.name),
          );
        },
      ),
    );
  }
}

class _PopularSportCard extends StatelessWidget {
  final _PopularSport sport;
  final VoidCallback onTap;

  const _PopularSportCard({required this.sport, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: Dimensions.r48.dynamicW * 1.67,
        decoration: BoxDecoration(
          color: sport.bgColor,
          borderRadius: BorderRadius.circular(Dimensions.r16.dynamicR),
          border: Border.all(
            color: sport.iconColor.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(Dimensions.r10.dynamicW),
              decoration: BoxDecoration(
                color: sport.iconColor.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                sport.icon,
                size: Dimensions.r24.dynamicH,
                color: sport.iconColor,
              ),
            ),
            SizedBox(height: Dimensions.r6.dynamicH),
            Text(
              sport.name,
              style: TextStyle(
                fontSize: Dimensions.r12.dynamicSP,
                fontWeight: FontWeight.w600,
                color: AppColor.textPrimaryLight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PopularSport {
  final String name;
  final IconData icon;
  final Color bgColor;
  final Color iconColor;

  const _PopularSport({
    required this.name,
    required this.icon,
    required this.bgColor,
    required this.iconColor,
  });
}
