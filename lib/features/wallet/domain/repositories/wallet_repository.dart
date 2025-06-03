import 'package:dartz/dartz.dart';
import '../../../../core/core.dart';
import '../entities/entities.dart';

abstract class WalletRepository {
  Future<Either<Failure, List<Wallet>>> getWallets();
  Future<Either<Failure, Wallet>> getWalletById(String id);
  Future<Either<Failure, Wallet>> createWallet({
    String? currency,
    double? initialBalance,
  });
}
