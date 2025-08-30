import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:chatflow/src/core/services/error_handler_service.dart';
import 'package:chatflow/src/features/auth/bloc/auth_event.dart';
import 'package:chatflow/src/features/auth/bloc/auth_state.dart';
import 'package:chatflow/src/features/auth/repository/auth_repository.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(const AuthInitial()) {
    on<AuthLoginEvent>(_onLogin);
    on<AuthRegisterEvent>(_onRegister);
    on<AuthLogoutEvent>(_onLogout);
    on<AuthCheckStatusEvent>(_onCheckStatus);
  }

  FutureOr<void> _onLogin(
    AuthLoginEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      final user = await authRepository.login(
        email: event.email,
        password: event.password,
      );
      emit(AuthAuthenticated(user: user));
    } catch (e, s) {
      ErrorHandlerService.handleError(e, s);
      emit(AuthFailure(message: e.toString()));
    }
  }

  FutureOr<void> _onRegister(
    AuthRegisterEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      final user = await authRepository.register(
        email: event.email,
        password: event.password,
        fullName: event.fullName,
      );
      emit(AuthAuthenticated(user: user));
    } catch (e, s) {
      ErrorHandlerService.handleError(e, s);
      emit(AuthFailure(message: e.toString()));
    }
  }

  FutureOr<void> _onLogout(
    AuthLogoutEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      await authRepository.logout();
      emit(const AuthUnauthenticated());
    } catch (e, s) {
      ErrorHandlerService.handleError(e, s);
      emit(AuthFailure(message: e.toString()));
    }
  }

  FutureOr<void> _onCheckStatus(
    AuthCheckStatusEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final user = await authRepository.getCurrentUser();
      if (user != null) {
        emit(AuthAuthenticated(user: user));
      } else {
        emit(const AuthUnauthenticated());
      }
    } catch (e, s) {
      ErrorHandlerService.handleError(e, s);
      emit(const AuthUnauthenticated());
    }
  }
}
