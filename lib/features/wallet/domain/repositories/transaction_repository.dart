import 'package:dartz/dartz.dart';
import '../../../../core/core.dart';
import '../entities/entities.dart';

abstract class TransactionRepository {
  Future<Either<Failure, Transaction>> createDeposit({
    required String walletId,
    required double amount,
    String? description,
    String? referenceId,
  });

  Future<Either<Failure, Transaction>> createWithdrawal({
    required String walletId,
    required double amount,
    String? description,
    String? referenceId,
  });

  Future<Either<Failure, List<Transaction>>> getTransactions({
    required String walletId,
    int page = 1,
    int limit = 10,
  });

  Future<Either<Failure, Transaction>> getTransactionById({
    required String walletId,
    required String transactionId,
  });
}
