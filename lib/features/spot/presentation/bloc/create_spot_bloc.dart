import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/create_spot_usecase.dart';
import '../../../categories/domain/usecases/get_categories_usecase.dart';
import '../../../categories/domain/entities/category.dart';

abstract class CreateSpotEvent {}

class LoadCategoriesEvent extends CreateSpotEvent {}

class SubmitSpotEvent extends CreateSpotEvent {
  final String categoryId;
  final String title;
  final String? description;
  final String locationName;
  final DateTime eventDateTime;
  final int maxParticipants;
  final double pricePerPerson;
  final List<File> images;

  SubmitSpotEvent({
    required this.categoryId,
    required this.title,
    this.description,
    required this.locationName,
    required this.eventDateTime,
    required this.maxParticipants,
    required this.pricePerPerson,
    required this.images,
  });
}

abstract class CreateSpotState {}

class CreateSpotInitial extends CreateSpotState {}

class CreateSpotCategoriesLoading extends CreateSpotState {}

class CreateSpotCategoriesLoaded extends CreateSpotState {
  final List<CategoryEntity> categories;
  CreateSpotCategoriesLoaded(this.categories);
}

class CreateSpotCategoriesError extends CreateSpotState {
  final String message;
  CreateSpotCategoriesError(this.message);
}

class CreateSpotLoading extends CreateSpotState {}

class CreateSpotSuccess extends CreateSpotState {}

class CreateSpotError extends CreateSpotState {
  final String message;
  CreateSpotError({required this.message});
}

class CreateSpotBloc extends Bloc<CreateSpotEvent, CreateSpotState> {
  final CreateSpotUseCase _createSpotUseCase;
  final GetCategoriesUseCase _getCategoriesUseCase;

  List<CategoryEntity> _cachedCategories = [];

  CreateSpotBloc({
    required CreateSpotUseCase createSpotUseCase,
    required GetCategoriesUseCase getCategoriesUseCase,
  }) : _createSpotUseCase = createSpotUseCase,
       _getCategoriesUseCase = getCategoriesUseCase,
       super(CreateSpotInitial()) {
    on<LoadCategoriesEvent>(_onLoadCategories);
    on<SubmitSpotEvent>(_onSubmitSpot);
  }

  Future<void> _onLoadCategories(
    LoadCategoriesEvent event,
    Emitter<CreateSpotState> emit,
  ) async {
    emit(CreateSpotCategoriesLoading());
    try {
      final categories = await _getCategoriesUseCase();
      _cachedCategories = categories;
      emit(CreateSpotCategoriesLoaded(categories));
    } catch (e) {
      emit(CreateSpotCategoriesError('Failed to load categories.'));
    }
  }

  Future<void> _onSubmitSpot(
    SubmitSpotEvent event,
    Emitter<CreateSpotState> emit,
  ) async {
    emit(CreateSpotLoading());
    try {
      await _createSpotUseCase(
        categoryId: event.categoryId,
        title: event.title,
        description: event.description,
        locationName: event.locationName,
        eventDateTime: event.eventDateTime,
        maxParticipants: event.maxParticipants,
        pricePerPerson: event.pricePerPerson,
        images: event.images,
      );
      emit(CreateSpotSuccess());
    } catch (e) {
      print('Spot creation error: $e');
      emit(CreateSpotError(message: 'Failed to create request: $e'));
      // Restore loaded categories so UI doesn't crash on failure
      emit(CreateSpotCategoriesLoaded(_cachedCategories));
    }
  }
}
