import 'package:lastspot_app/core/base_import.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../auth/presentation/bloc/profile_cubit.dart';
import 'explore_screen_mobile.dart';
import 'explore_screen_tablet.dart';

class ExploreScreen extends StatelessWidget {
  final String? initialCategoryId;

  const ExploreScreen({super.key, this.initialCategoryId});

  @override
  Widget build(BuildContext context) {
    final userId = Supabase.instance.client.auth.currentUser!.id;
    return BlocProvider(
      create: (context) => sl<ProfileCubit>()..fetchProfile(userId),
      child: ResponsiveLayout(
        mobile: ExploreScreenMobile(initialCategoryId: initialCategoryId),
        tablet: ExploreScreenTablet(initialCategoryId: initialCategoryId),
      ),
    );
  }
}
