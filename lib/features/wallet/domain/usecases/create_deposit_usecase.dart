import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/core.dart';
import '../entities/entities.dart';
import '../repositories/repositories.dart';

class CreateDepositParams extends Equatable {
  const CreateDepositParams({
    required this.walletId,
    required this.amount,
    this.description,
    this.referenceId,
  });

  final String walletId;
  final double amount;
  final String? description;
  final String? referenceId;

  @override
  List<Object?> get props => [walletId, amount, description, referenceId];
}

class CreateDepositUseCase
    implements UseCaseFuture<Failure, Transaction, CreateDepositParams> {
  CreateDepositUseCase(this.repository);

  final TransactionRepository repository;

  @override
  Future<Either<Failure, Transaction>> call(CreateDepositParams params) async {
    return repository.createDeposit(
      walletId: params.walletId,
      amount: params.amount,
      description: params.description,
      referenceId: params.referenceId,
    );
  }
}
