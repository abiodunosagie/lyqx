// lib/viewmodel/auth_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/repositories/auth_repository.dart';
import '../data/model/user_model.dart';

@injectable
class AuthCubit extends Cubit<AuthState> {
  final AuthRepository repo;

  AuthCubit(this.repo) : super(AuthState.initial());

  Future<bool> login(User user) async {
    try {
      emit(state.copyWith(isLoading: true));

      final loggedIn = await repo.login(user);

      if (loggedIn) {
        // Save username to SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('username', user.username);

        // Update state with username and logged in status
        emit(AuthState(
          isLoggedIn: true,
          username: user.username,
          isLoading: false,
        ));
      } else {
        emit(AuthState(
          isLoggedIn: false,
          username: '',
          isLoading: false,
        ));
      }

      return loggedIn;
    } catch (e) {
      emit(AuthState(
        isLoggedIn: false,
        username: '',
        isLoading: false,
        error: e.toString(),
      ));
      return false;
    }
  }

  Future<void> logout() async {
    try {
      emit(state.copyWith(isLoading: true));

      // Clear username from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('username');

      // Update state
      emit(AuthState(
        isLoggedIn: false,
        username: '',
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  // Load saved username on app start
  Future<void> loadSavedUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedUsername = prefs.getString('username') ?? '';

      if (savedUsername.isNotEmpty) {
        emit(AuthState(
          isLoggedIn: true,
          username: savedUsername,
          isLoading: false,
        ));
      } else {
        emit(AuthState.initial());
      }
    } catch (e) {
      emit(AuthState(
        isLoggedIn: false,
        username: '',
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  // Clear any errors
  void clearError() {
    emit(state.copyWith(error: null));
  }
}

// Enhanced State class to hold auth information
class AuthState {
  final bool isLoggedIn;
  final String username;
  final bool isLoading;
  final String? error;

  const AuthState({
    required this.isLoggedIn,
    required this.username,
    this.isLoading = false,
    this.error,
  });

  // Factory constructor for initial state
  factory AuthState.initial() {
    return const AuthState(
      isLoggedIn: false,
      username: '',
      isLoading: false,
    );
  }

  // Copy with method for easier state updates
  AuthState copyWith({
    bool? isLoggedIn,
    String? username,
    bool? isLoading,
    String? error,
  }) {
    return AuthState(
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      username: username ?? this.username,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  // Equality override for proper BlocBuilder rebuilds
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AuthState &&
        other.isLoggedIn == isLoggedIn &&
        other.username == username &&
        other.isLoading == isLoading &&
        other.error == error;
  }

  @override
  int get hashCode {
    return Object.hash(isLoggedIn, username, isLoading, error);
  }

  @override
  String toString() {
    return 'AuthState(isLoggedIn: $isLoggedIn, username: $username, isLoading: $isLoading, error: $error)';
  }
}
