part of 'initialize_cubit.dart'; // Will be created next

abstract class InitializeState extends Equatable {
  const InitializeState();

  @override
  List<Object?> get props => [];
}

class InitializeInitial extends InitializeState {}

class InitializeLoading extends InitializeState {
  final String message;
  const InitializeLoading({this.message = 'Initializing...'});

  @override
  List<Object?> get props => [message];
}

class InitializeStateUnregistered extends InitializeState {}

class InitializeStateRegistered extends InitializeState {}

// User is authenticated and essential app data is ready
class InitializeSuccessAuthenticated extends InitializeState {
  final String? userId; // Optional: pass some initial user data
  const InitializeSuccessAuthenticated({this.userId});

  @override
  List<Object?> get props => [userId];
}

// User is not authenticated or needs to go through an onboarding flow
class InitializeSuccessUnauthenticated extends InitializeState {}

// If something critical fails during initialization
class InitializeError extends InitializeState {
  final String errorMessage;
  const InitializeError(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}