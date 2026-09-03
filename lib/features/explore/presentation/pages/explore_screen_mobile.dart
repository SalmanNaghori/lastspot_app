import 'package:lastspot_app/core/base_import.dart';

class ExploreScreenMobile extends StatelessWidget {
  const ExploreScreenMobile({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = context.loc;

    return Scaffold(
      backgroundColor: context.backgroundColor,
      appBar: AppBar(
        title: Text(loc.navExplore),
        backgroundColor: context.backgroundColor,
        systemOverlayStyle: AppTheme.systemUiOverlayStyle(context),
      ),
      body: Center(child: Text(loc.explorePlaceholderText, style: Theme.of(context).textTheme.bodyLarge)),
    );
  }
}
