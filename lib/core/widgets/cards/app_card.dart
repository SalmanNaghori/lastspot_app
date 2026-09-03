import '../../base_import.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;

  const AppCard({super.key, required this.child, this.onTap, this.padding});

  @override
  Widget build(BuildContext context) {
    Widget cardContent = padding != null
        ? Padding(padding: padding!, child: child)
        : child;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(onTap: onTap, child: cardContent),
    );
  }
}
