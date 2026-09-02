import 'package:equatable/equatable.dart';
import '../../data/models/app_settings_model.dart';

abstract class StartupState extends Equatable {
  const StartupState();

  @override
  List<Object?> get props => [];
}

class StartupInitial extends StartupState {}

class StartupLoading extends StartupState {}

class StartupMaintenanceMode extends StartupState {
  final String title;
  final String message;

  const StartupMaintenanceMode({required this.title, required this.message});

  @override
  List<Object?> get props => [title, message];
}

class StartupUpdateRequired extends StartupState {
  final VersionMessage messageData;
  final String storeUrl;
  final bool isForced;

  const StartupUpdateRequired({
    required this.messageData,
    required this.storeUrl,
    required this.isForced,
  });

  @override
  List<Object?> get props => [messageData, storeUrl, isForced];
}

class StartupSuccess extends StartupState {}

class StartupError extends StartupState {
  final String message;

  const StartupError({required this.message});

  @override
  List<Object?> get props => [message];
}
