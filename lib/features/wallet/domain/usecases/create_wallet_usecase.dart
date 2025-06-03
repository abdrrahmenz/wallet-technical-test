import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/core.dart';
import '../entities/entities.dart';
import '../repositories/repositories.dart';

class CreateWalletParams extends Equatable {
  const CreateWalletParams({
    this.currency,
    this.initialBalance,
  });

  final String? currency;
  final double? initialBalance;

  @override
  List<Object?> get props => [currency, initialBalance];
}

class CreateWalletUseCase
    implements UseCaseFuture<Failure, Wallet, CreateWalletParams> {
  CreateWalletUseCase(this.repository);

  final WalletRepository repository;

  @override
  Future<Either<Failure, Wallet>> call(CreateWalletParams params) async {
    return repository.createWallet(
      currency: params.currency,
      initialBalance: params.initialBalance,
    );
  }
}
