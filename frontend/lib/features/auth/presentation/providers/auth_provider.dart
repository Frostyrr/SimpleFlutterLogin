import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Represents the authentication state of the application.
class AuthState {
  final bool isLoading;
  final String? errorMessage;
  final bool isAuthenticated;

  const AuthState({
    this.isLoading = false,
    this.errorMessage,
    this.isAuthenticated = false,
  });

  /// Helper method to create a copy of the current state with modified fields.
  AuthState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool? isAuthenticated,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    );
  }
}

/// Notifier that manages authentication state and business logic.
class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() {
    // Initial state when the provider is first read
    return const AuthState();
  }

  /// Simulates a login attempt.
  Future<void> login(String email, String password) async {
    // Basic client-side validation
    if (email.trim().isEmpty || password.trim().isEmpty) {
      state = state.copyWith(
        errorMessage: 'Please enter both email and password.',
      );
      return;
    }

    // Set loading state and clear any existing errors
    state = state.copyWith(isLoading: true, errorMessage: null);

    // Simulate network delay for learning/practice purposes
    await Future.delayed(const Duration(seconds: 2));

    // Dummy authentication check
    if (email.trim() == 'test@example.com' && password == 'password123') {
      state = state.copyWith(
        isLoading: false,
        isAuthenticated: true,
        errorMessage: null,
      );
    } else {
      state = state.copyWith(
        isLoading: false,
        isAuthenticated: false,
        errorMessage:
            'Invalid email or password. Try test@example.com / password123',
      );
    }
  }

  /// Resets authentication state (e.g., logout).
  void logout() {
    state = const AuthState();
  }
}

/// Global provider accessible across the app.
final authProvider = NotifierProvider<AuthNotifier, AuthState>(() {
  return AuthNotifier();
});
