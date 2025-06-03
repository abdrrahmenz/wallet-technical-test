import 'dart:async';

import 'package:dartz/dartz.dart';
import '../../../../core/core.dart';
import '../../auth.dart';

class IsAuthenticatedUseCase implements UseCaseFuture<Failure, bool, NoParams> {
  IsAuthenticatedUseCase(this.authRepository);

  final AuthRepository authRepository;

  @override
  FutureOr<Either<Failure, bool>> call(NoParams params) async {
    return authRepository.isAuthenticated();
  }
}
