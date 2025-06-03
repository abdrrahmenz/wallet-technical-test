import 'package:dartz/dartz.dart';

import '../../../../core/core.dart';
import '../../auth.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this.authApiSource, {required this.authLocalSource});

  final AuthApiSource authApiSource;
  final AuthLocalSource authLocalSource;

  @override
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  }) async {
    try {
      final result = await authApiSource.login(
        email: email,
        password: password,
      );

      return Right(result.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.code));
    }
  }

  @override
  Future<Either<Failure, bool>> logout() async {
    try {
      final result = await authLocalSource.clearCache();

      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.code));
    }
  }

  @override
  Future<Either<Failure, User>> register({
    String? name,
    required String email,
    required String password,
  }) async {
    try {
      final result = await authApiSource.register(
        email: email,
        name: name,
        password: password,
      );

      return Right(result.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.code));
    }
  }

  @override
  Future<Either<Failure, bool>> isAuthenticated() async {
    try {
      final hasToken = await authLocalSource.isCached();
      return Right(hasToken);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message, code: e.code));
    }
  }
}
