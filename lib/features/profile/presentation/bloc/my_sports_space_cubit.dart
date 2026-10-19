import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/network/network_exceptions.dart';
import '../../../auth/domain/entities/user_profile.dart';
import '../../../auth/domain/repositories/auth_repository.dart';
import '../../../auth/domain/usecases/get_profile_usecase.dart';
import '../../../spot/domain/entities/request_entity.dart';
import '../../../spot/domain/repositories/spot_repository.dart';
import 'my_sports_space_state.dart';

class MySportsSpaceCubit extends Cubit<MySportsSpaceState> {
  final GetProfileUseCase _getProfileUseCase;
  final SpotRepository _spotRepository;
  final AuthRepository _authRepository;

  MySportsSpaceCubit({
    required GetProfileUseCase getProfileUseCase,
    required SpotRepository spotRepository,
    required AuthRepository authRepository,
  }) : _getProfileUseCase = getProfileUseCase,
       _spotRepository = spotRepository,
       _authRepository = authRepository,
       super(const MySportsSpaceInitial());

  Future<void> loadDashboard({bool isRefresh = false}) async {
    final userId = _authRepository.getCurrentUserId();
    if (userId == null) {
      emit(const MySportsSpaceError(message: 'User session not found'));
      return;
    }

    if (state is MySportsSpaceLoaded && isRefresh) {
      emit((state as MySportsSpaceLoaded).copyWith(isRefreshing: true));
    } else {
      emit(const MySportsSpaceLoading());
    }

    try {
      final results = await Future.wait([
        _getProfileUseCase(userId),
        _spotRepository.getUserActivities(),
        _spotRepository.getSentJoinRequests(),
      ]);

      final profile =
          results[0] as UserProfile? ??
          UserProfile(id: userId, createdAt: DateTime.now());
      final allActivities = results[1] as List<RequestEntity>;
      final sentRequests = results[2] as List<dynamic>;

      final now = DateTime.now();

      final hostedActivities = allActivities
          .where((a) => a.userId == userId)
          .toList();

      final joinedActivities = allActivities
          .where((a) => a.userId != userId)
          .toList();

      final upcomingActivities = allActivities.where((a) {
        final isFuture = a.eventDateTime.isAfter(now);
        final isActive =
            a.status != RequestStatus.cancelled &&
            a.status != RequestStatus.expired;
        return isFuture && isActive;
      }).toList();

      final completedActivities = allActivities.where((a) {
        return a.status == RequestStatus.completed;
      }).toList();

      final data = MySportsSpaceData(
        profile: profile,
        allActivities: allActivities,
        sentRequests: sentRequests.cast(),
        hostedCount: hostedActivities.length,
        joinedCount: joinedActivities.length,
        upcomingCount: upcomingActivities.length,
        completedCount: completedActivities.length,
        upcomingActivities: upcomingActivities,
        hostedActivities: hostedActivities,
        joinedActivities: joinedActivities,
        completedActivities: completedActivities,
        pastActivities: completedActivities,
      );

      emit(MySportsSpaceLoaded(data: data));
    } catch (e) {
      emit(
        MySportsSpaceError(
          message: e.toString(),
          isNetworkError: e is NoInternetException,
        ),
      );
    }
  }
}
