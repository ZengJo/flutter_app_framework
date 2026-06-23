import 'package:equatable/equatable.dart';

/// Base state for Bloc-based features.
abstract class BaseState extends Equatable {
  const BaseState();

  @override
  List<Object?> get props => const [];
}
