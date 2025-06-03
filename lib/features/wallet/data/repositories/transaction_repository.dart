import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/core.dart';
import '../../domain/entities/entities.dart';
import '../../domain/repositories/repositories.dart';
import '../sources/sources.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  TransactionRepositoryImpl(this.transactionApiSource);

  final TransactionApiSource transactionApiSource;

  @override
  Future<Either<Failure, Transaction>> createDeposit({
    required String walletId,
    required double amount,
    String? description,
    String? referenceId,
  }) async {
    try {
      final result = await transactionApiSource.createDeposit(
        walletId: walletId,
        amount: amount,
        description: description,
        referenceId: referenceId,
      );
      return Right(result.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.code));
    }
  }

  @override
  Future<Either<Failure, Transaction>> createWithdrawal({
    required String walletId,
    required double amount,
    String? description,
    String? referenceId,
  }) async {
    try {
      final result = await transactionApiSource.createWithdrawal(
        walletId: walletId,
        amount: amount,
        description: description,
        referenceId: referenceId,
      );
      return Right(result.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.code));
    }
  }

  @override
  Future<Either<Failure, List<Transaction>>> getTransactions({
    required String walletId,
    int? page,
    int? limit,
  }) async {
    try {
      debugPrint(
          '🔍 Repository: Getting transactions for wallet $walletId, page: ${page ?? 1}, limit: ${limit ?? 10}');

      final result = await transactionApiSource.getTransactions(
        walletId: walletId,
        page: page ?? 1,
        limit: limit ?? 10,
      );

      debugPrint(
          '✅ Repository: Got ${result.length} transaction models from API');

      final entities = result.map((model) {
        final entity = model.toEntity();
        debugPrint(
            '🔄 Repository: Converted model ID=${model.id} to entity ID=${entity.id}, type=${entity.type}');
        return entity;
      }).toList();

      debugPrint(
          '📊 Repository: Returning ${entities.length} transaction entities');
      return Right(entities);
    } on ServerException catch (e) {
      debugPrint('❌ Repository: ServerException - ${e.message}');
      return Left(ServerFailure(message: e.message, code: e.code));
    } catch (e) {
      debugPrint('❌ Repository: Unexpected exception - $e');
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Transaction>> getTransactionById({
    required String walletId,
    required String transactionId,
  }) async {
    try {
      final result = await transactionApiSource.getTransactionById(
        walletId: walletId,
        transactionId: transactionId,
      );
      return Right(result.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.code));
    }
  }
}
