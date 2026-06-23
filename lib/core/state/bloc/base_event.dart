import 'package:equatable/equatable.dart';

/// Base event for Bloc-based features.
abstract class BaseEvent extends Equatable {
  const BaseEvent();

  @override
  List<Object?> get props => const [];
}
