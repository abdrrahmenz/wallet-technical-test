part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class GetAuthCacheEvent extends AuthEvent {}

class LogoutEvent extends AuthEvent {}

class SubmitLoginEvent extends AuthEvent {
  final String email;
  final String password;

  const SubmitLoginEvent({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

class SubmitRegisterEvent extends AuthEvent {
  final String email;
  final String? name;
  final String password;

  const SubmitRegisterEvent({
    required this.email,
    required this.password,
    this.name,
  });

  @override
  List<Object?> get props => [email, password, name];
}