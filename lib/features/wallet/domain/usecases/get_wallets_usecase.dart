import 'package:dartz/dartz.dart';
import '../../../../core/core.dart';
import '../entities/entities.dart';
import '../repositories/repositories.dart';

class GetWalletsUseCase
    implements UseCaseFuture<Failure, List<Wallet>, NoParams> {
  GetWalletsUseCase(this.repository);

  final WalletRepository repository;

  @override
  Future<Either<Failure, List<Wallet>>> call(NoParams params) async {
    return repository.getWallets();
  }
}
