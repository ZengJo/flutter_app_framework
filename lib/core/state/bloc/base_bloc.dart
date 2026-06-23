import 'package:flutter_bloc/flutter_bloc.dart';

/// Base Bloc type. Extend this class when a feature uses Bloc instead of Riverpod.
abstract class BaseBloc<Event, State> extends Bloc<Event, State> {
  BaseBloc(super.initialState);
}
