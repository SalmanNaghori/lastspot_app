import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/network/network_exceptions.dart';
import '../../../../core/utils/result.dart';
import '../../domain/usecases/get_my_conversations_usecase.dart';
import 'conversations_state.dart';

class ConversationsCubit extends Cubit<ConversationsState> {
  final GetMyConversationsUseCase _getMyConversationsUseCase;

  ConversationsCubit({
    required GetMyConversationsUseCase getMyConversationsUseCase,
  }) : _getMyConversationsUseCase = getMyConversationsUseCase,
       super(const ConversationsInitial());

  Future<void> loadConversations({bool isRefresh = false}) async {
    if (state is ConversationsLoaded && isRefresh) {
      emit((state as ConversationsLoaded).copyWith(isRefreshing: true));
    } else {
      emit(const ConversationsLoading());
    }

    final result = await _getMyConversationsUseCase();
    switch (result) {
      case Success(value: final conversations):
        emit(ConversationsLoaded(conversations: conversations));
      case Failure(exception: final ex):
        emit(
          ConversationsError(
            message: ex.toString(),
            isNetworkError: ex is NoInternetException,
          ),
        );
    }
  }
}
