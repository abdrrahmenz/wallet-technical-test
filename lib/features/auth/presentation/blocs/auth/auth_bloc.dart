import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/core.dart';
import '../../../auth.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required this.loginUseCase,
    required this.logoutUseCase,
    required this.registerUseCase,
    required this.isAuthenticatedUseCase,
  }) : super(AuthState.initial()) {
    on<GetAuthCacheEvent>(
      (event, emit) async {
        try {
          // Check if user is authenticated (has valid token in cache)
          final authCheck = await isAuthenticatedUseCase(const NoParams());

          authCheck.fold(
            (l) {
              // Cache check failed, user is not authenticated
              emit(state.copyWith(
                failure: l,
                status: AuthStateStatus.unAuthorized,
              ));
            },
            (isAuthenticated) {
              if (!isAuthenticated) {
                // No valid token found, user needs to login
                emit(state.copyWith(
                  status: AuthStateStatus.unAuthorized,
                ));
              } else {
                // User has valid token in cache, mark as authorized
                emit(state.copyWith(
                  status: AuthStateStatus.authorized,
                ));
              }
            },
          );
        } catch (exception, stackTrace) {
          exception.recordError(
            RecordErrorParams(exception: exception, stackTrace: stackTrace),
          );
        }
      },
      transformer: debounce(const Duration(seconds: 1)),
    );

    on<SubmitLoginEvent>(
      (event, emit) async {
        try {
          emit(state.copyWith(status: AuthStateStatus.loading));
          final usecase = await loginUseCase(LoginParams(
            email: event.email,
            password: event.password,
          ));
          usecase.fold(
            (l) {
              emit(state.copyWith(
                failure: l,
                status: AuthStateStatus.unAuthorized,
              ));
            },
            (r) {
              emit(state.copyWith(
                user: r,
                status: AuthStateStatus.authorized,
              ));
            },
          );
        } catch (exception, stackTrace) {
          exception.recordError(
            RecordErrorParams(exception: exception, stackTrace: stackTrace),
          );
        }
      },
    );

    on<SubmitRegisterEvent>(
      (event, emit) async {
        try {
          emit(state.copyWith(status: AuthStateStatus.loading));
          final usecase = await registerUseCase(RegisterParams(
            name: event.name,
            email: event.email,
            password: event.password,
          ));
          usecase.fold(
            (l) {
              emit(state.copyWith(
                failure: l,
                status: AuthStateStatus.unAuthorized,
              ));
            },
            (r) {
              emit(state.copyWith(
                user: r,
                status: AuthStateStatus.success,
              ));
            },
          );
        } catch (exception, stackTrace) {
          exception.recordError(
            RecordErrorParams(exception: exception, stackTrace: stackTrace),
          );
        }
      },
    );

    on<LogoutEvent>(
      (event, emit) async {
        try {
          emit(state.copyWith(status: AuthStateStatus.loading));
          await logoutUseCase(const NoParams());
          emit(state.copyWith(status: AuthStateStatus.unAuthorized));
          emit(AuthState.initial());
        } catch (exception, stackTrace) {
          exception.recordError(
            RecordErrorParams(exception: exception, stackTrace: stackTrace),
          );
        }
      },
    );
  }

  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final LogoutUseCase logoutUseCase;
  final IsAuthenticatedUseCase isAuthenticatedUseCase;
}
