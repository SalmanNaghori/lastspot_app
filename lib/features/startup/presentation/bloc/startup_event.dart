import 'package:equatable/equatable.dart';

abstract class StartupEvent extends Equatable {
  const StartupEvent();

  @override
  List<Object> get props => [];
}

class StartupInitialCheckRequested extends StartupEvent {}
