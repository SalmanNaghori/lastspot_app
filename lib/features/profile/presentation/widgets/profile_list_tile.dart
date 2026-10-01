import 'package:lastspot_app/core/base_import.dart';

class ProfileListTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const ProfileListTile({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: context.colorScheme.onSurface),
      title: Text(title, style: context.bodyLarge),
      trailing: Icon(
        Icons.chevron_right,
        color: context.colorScheme.onSurfaceVariant,
      ),
      onTap: onTap,
    );
  }
}
