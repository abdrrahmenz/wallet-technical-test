import 'package:dartz/dartz.dart';
import '../../../../core/core.dart';
import '../../domain/entities/entities.dart';
import '../../domain/repositories/repositories.dart';
import '../sources/sources.dart';

class WalletRepositoryImpl implements WalletRepository {
  WalletRepositoryImpl(this.walletApiSource);

  final WalletApiSource walletApiSource;

  @override
  Future<Either<Failure, List<Wallet>>> getWallets() async {
    try {
      final result = await walletApiSource.getWallets();
      return Right(result.map((model) => model.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.code));
    }
  }

  @override
  Future<Either<Failure, Wallet>> getWalletById(String id) async {
    try {
      final result = await walletApiSource.getWalletById(id);
      return Right(result.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.code));
    }
  }

  @override
  Future<Either<Failure, Wallet>> createWallet({
    String? currency,
    double? initialBalance,
  }) async {
    try {
      final result = await walletApiSource.createWallet(
        currency: currency,
        initialBalance: initialBalance,
      );
      return Right(result.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.code));
    }
  }
}
