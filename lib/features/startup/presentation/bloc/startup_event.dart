import 'package:equatable/equatable.dart';

abstract class StartupEvent extends Equatable {
  const StartupEvent();

  @override
  List<Object> get props => [];
}

class StartupInitialCheckRequested extends StartupEvent {}

class StartupUpdateSkipped extends StartupEvent {
  final String version;

  const StartupUpdateSkipped(this.version);

  @override
  List<Object> get props => [version];
}
