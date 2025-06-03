import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/core.dart';
import '../entities/entities.dart';
import '../repositories/repositories.dart';

class GetTransactionsParams extends Equatable {
  const GetTransactionsParams({
    required this.walletId,
    this.page = 1,
    this.limit = 10,
  });

  final String walletId;
  final int page;
  final int limit;

  @override
  List<Object?> get props => [walletId, page, limit];
}

class GetTransactionsUseCase
    implements
        UseCaseFuture<Failure, List<Transaction>, GetTransactionsParams> {
  GetTransactionsUseCase(this.repository);

  final TransactionRepository repository;

  @override
  Future<Either<Failure, List<Transaction>>> call(
      GetTransactionsParams params) async {
    return repository.getTransactions(
      walletId: params.walletId,
      page: params.page,
      limit: params.limit,
    );
  }
}
