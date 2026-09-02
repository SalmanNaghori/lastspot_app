import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_categories_usecase.dart';
import 'category_event.dart';
import 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final GetCategoriesUseCase _getCategoriesUseCase;

  CategoryBloc({required GetCategoriesUseCase getCategoriesUseCase})
      : _getCategoriesUseCase = getCategoriesUseCase,
        super(CategoryInitial()) {
    on<LoadCategoriesEvent>(_onLoadCategories);
  }

  Future<void> _onLoadCategories(
      LoadCategoriesEvent event, Emitter<CategoryState> emit) async {
    emit(CategoryLoading());
    try {
      final categories = await _getCategoriesUseCase();
      emit(CategoryLoaded(categories));
    } catch (e, st) {
      log('Error loading categories', name: 'CategoryBloc', error: e, stackTrace: st);
      emit(const CategoryError('Failed to load categories'));
    }
  }
}
