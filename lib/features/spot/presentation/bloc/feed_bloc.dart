import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/spot_entity.dart';
import '../../domain/usecases/get_spots_usecase.dart';

abstract class FeedEvent {}

class LoadFeedEvent extends FeedEvent {
  final String? category;
  LoadFeedEvent({this.category});
}

abstract class FeedState {}

class FeedInitial extends FeedState {}
class FeedLoading extends FeedState {}
class FeedLoaded extends FeedState {
  final List<SpotEntity> posts;
  FeedLoaded({required this.posts});
}
class FeedError extends FeedState {
  final String message;
  FeedError({required this.message});
}

class FeedBloc extends Bloc<FeedEvent, FeedState> {
  final GetSpotsUseCase _getSpotsUseCase;

  FeedBloc({required GetSpotsUseCase getSpotsUseCase}) 
      : _getSpotsUseCase = getSpotsUseCase,
        super(FeedInitial()) {
    on<LoadFeedEvent>(_onLoadFeed);
  }

  Future<void> _onLoadFeed(LoadFeedEvent event, Emitter<FeedState> emit) async {
    emit(FeedLoading());
    try {
      // NOTE: getFeedSpots in use case doesn't take category yet? Wait, let's fix it.
      // Wait, SpotRepository.getFeedSpots takes {String? category}, but my GetSpotsUseCase doesn't pass it!
      // I need to update GetSpotsUseCase first, but let's assume it takes it, I will update it next.
      final posts = await _getSpotsUseCase(category: event.category);
      emit(FeedLoaded(posts: posts));
    } catch (e) {
      emit(FeedError(message: 'Something went wrong. Please try again.'));
    }
  }
}
