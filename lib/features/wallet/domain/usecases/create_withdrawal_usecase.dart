import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/core.dart';
import '../entities/entities.dart';
import '../repositories/repositories.dart';

class CreateWithdrawalParams extends Equatable {
  const CreateWithdrawalParams({
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

class CreateWithdrawalUseCase
    implements UseCaseFuture<Failure, Transaction, CreateWithdrawalParams> {
  CreateWithdrawalUseCase(this.repository);

  final TransactionRepository repository;

  @override
  Future<Either<Failure, Transaction>> call(
      CreateWithdrawalParams params) async {
    return repository.createWithdrawal(
      walletId: params.walletId,
      amount: params.amount,
      description: params.description,
      referenceId: params.referenceId,
    );
  }
}
