import 'dart:async';
import 'dart:math';

import 'package:dio/dio.dart';
import '../../../../core/core.dart';
import '../../../wallet/domain/entities/entities.dart';
import '../models/models.dart';

abstract class TransactionRemoteDataSource {
  Future<Transaction> createDeposit({
    required String walletId,
    required double amount,
    String? description,
    String? referenceId,
  });

  Future<Transaction> createWithdrawal({
    required String walletId,
    required double amount,
    String? description,
    String? referenceId,
  });

  Future<List<Transaction>> getTransactions({
    required String walletId,
    int page = 1,
    int limit = 10,
  });

  Future<Transaction> getTransactionById({
    required String walletId,
    required String transactionId,
  });
}

class TransactionRemoteDataSourceImpl implements TransactionRemoteDataSource {
  final Dio dio;
  int _requestCount = 0;

  TransactionRemoteDataSourceImpl({
    required this.dio,
  });

  Future<void> _simulateDelay() async {
    // Every 2nd request will have a delay
    _requestCount++;
    if (_requestCount % 2 == 0) {
      final random = Random();
      final seconds = random.nextInt(4) + 1; // 1-5 seconds
      await Future.delayed(Duration(seconds: seconds));
    }
  }

  @override
  Future<Transaction> createDeposit({
    required String walletId,
    required double amount,
    String? description,
    String? referenceId,
  }) async {
    await _simulateDelay();

    try {
      final response = await dio.post(
        '/wallets/$walletId/transactions/deposit',
        data: {
          'amount': amount,
          'description': description,
          'reference_id': referenceId,
        },
      );

      return TransactionModel.fromJson(response.data).toEntity();
    } on DioException catch (e) {
      throw ServerFailure(
        message: e.response?.data['message'] ?? 'Failed to create deposit',
      );
    }
  }

  @override
  Future<Transaction> createWithdrawal({
    required String walletId,
    required double amount,
    String? description,
    String? referenceId,
  }) async {
    await _simulateDelay();

    try {
      final response = await dio.post(
        '/wallets/$walletId/transactions/withdrawal',
        data: {
          'amount': amount,
          'description': description,
          'reference_id': referenceId,
        },
      );

      return TransactionModel.fromJson(response.data).toEntity();
    } on DioException catch (e) {
      throw ServerFailure(
        message: e.response?.data['message'] ?? 'Failed to create withdrawal',
      );
    }
  }

  @override
  Future<List<Transaction>> getTransactions({
    required String walletId,
    int page = 1,
    int limit = 10,
  }) async {
    await _simulateDelay();

    try {
      final response = await dio.get(
        '/wallets/$walletId/transactions',
        queryParameters: {
          'page': page,
          'limit': limit,
        },
      );

      final List<dynamic> data = response.data;
      return data
          .map((json) => TransactionModel.fromJson(json).toEntity())
          .toList();
    } on DioException catch (e) {
      throw ServerFailure(
        message: e.response?.data['message'] ?? 'Failed to get transactions',
      );
    }
  }

  @override
  Future<Transaction> getTransactionById({
    required String walletId,
    required String transactionId,
  }) async {
    await _simulateDelay();

    try {
      final response = await dio.get(
        '/wallets/$walletId/transactions/$transactionId',
      );

      return TransactionModel.fromJson(response.data).toEntity();
    } on DioException catch (e) {
      throw ServerFailure(
        message:
            e.response?.data['message'] ?? 'Failed to get transaction details',
      );
    }
  }
}
