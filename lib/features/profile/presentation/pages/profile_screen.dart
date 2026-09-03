import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:lastspot_app/core/base_import.dart';
import 'package:lastspot_app/core/di/service_locator.dart';
import 'package:lastspot_app/features/auth/presentation/bloc/profile_cubit.dart';

import 'profile_screen_mobile.dart';
import 'profile_screen_tablet.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // We fetch the profile on load
    final userId = Supabase.instance.client.auth.currentUser!.id;
    return BlocProvider(
      create: (context) => sl<ProfileCubit>()..fetchProfile(userId),
      child: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          return ResponsiveLayout(
            mobile: ProfileScreenMobile(
              state: state,
              onRefresh: () async {
                await context.read<ProfileCubit>().fetchProfile(userId);
              },
            ),
            tablet: ProfileScreenTablet(
              state: state,
              onRefresh: () async {
                await context.read<ProfileCubit>().fetchProfile(userId);
              },
            ),
          );
        },
      ),
    );
  }
}
