import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/core.dart';
import '../entities/entities.dart';
import '../repositories/repositories.dart';

class GetTransactionByIdParams extends Equatable {
  const GetTransactionByIdParams({
    required this.walletId,
    required this.transactionId,
  });

  final String walletId;
  final String transactionId;

  @override
  List<Object?> get props => [walletId, transactionId];
}

class GetTransactionByIdUseCase
    implements UseCaseFuture<Failure, Transaction, GetTransactionByIdParams> {
  GetTransactionByIdUseCase(this.repository);

  final TransactionRepository repository;

  @override
  Future<Either<Failure, Transaction>> call(
      GetTransactionByIdParams params) async {
    return repository.getTransactionById(
      walletId: params.walletId,
      transactionId: params.transactionId,
    );
  }
}
