import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/core.dart';
import '../models/models.dart';

abstract class TransactionApiSource {
  Future<TransactionModel> createDeposit({
    required String walletId,
    required double amount,
    String? description,
    String? referenceId,
  });

  Future<TransactionModel> createWithdrawal({
    required String walletId,
    required double amount,
    String? description,
    String? referenceId,
  });

  Future<List<TransactionModel>> getTransactions({
    required String walletId,
    int page = 1,
    int limit = 10,
  });

  Future<TransactionModel> getTransactionById({
    required String walletId,
    required String transactionId,
  });
}

class TransactionApiSourceImpl implements TransactionApiSource {
  TransactionApiSourceImpl(this.dio);

  final Dio dio;

  // Delay simulation counter (static to persist across instances)
  static int _requestCounter = 0;

  /// Simulates network delay for every 2nd request (1-5 seconds)
  Future<void> _simulateDelay() async {
    _requestCounter++;
    if (_requestCounter % 2 == 0) {
      // Every 2nd request gets a delay
      final delaySeconds = 1 + (DateTime.now().millisecond % 5); // 1-5 seconds
      await Future.delayed(Duration(seconds: delaySeconds));
    }
  }

  @override
  Future<TransactionModel> createDeposit({
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
          if (description != null) 'description': description,
          if (referenceId != null) 'referenceId': referenceId,
        },
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        Map<String, dynamic> transactionJson;

        // Handle different response formats
        if (response.data is Map<String, dynamic> &&
            response.data['data'] != null) {
          // Response format: {"data": {...}}
          transactionJson = response.data['data'] as Map<String, dynamic>;
        } else if (response.data is Map<String, dynamic>) {
          // Response format: {...}
          transactionJson = response.data as Map<String, dynamic>;
        } else {
          throw ErrorCodeException(message: 'Invalid transaction data format');
        }

        return TransactionModel.fromJson(transactionJson);
      } else {
        throw ErrorCodeException(message: 'Failed to create deposit');
      }
    } on DioException catch (e) {
      throw e.toServerException();
    } catch (e) {
      throw ErrorCodeException(message: e.toString());
    }
  }

  @override
  Future<TransactionModel> createWithdrawal({
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
          if (description != null) 'description': description,
          if (referenceId != null) 'referenceId': referenceId,
        },
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        Map<String, dynamic> transactionJson;

        // Handle different response formats
        if (response.data is Map<String, dynamic> &&
            response.data['data'] != null) {
          // Response format: {"data": {...}}
          transactionJson = response.data['data'] as Map<String, dynamic>;
        } else if (response.data is Map<String, dynamic>) {
          // Response format: {...}
          transactionJson = response.data as Map<String, dynamic>;
        } else {
          throw ErrorCodeException(message: 'Invalid transaction data format');
        }

        return TransactionModel.fromJson(transactionJson);
      } else {
        throw ErrorCodeException(message: 'Failed to create withdrawal');
      }
    } on DioException catch (e) {
      throw e.toServerException();
    } catch (e) {
      throw ErrorCodeException(message: e.toString());
    }
  }

  @override
  Future<List<TransactionModel>> getTransactions({
    required String walletId,
    int page = 1,
    int limit = 10,
  }) async {
    await _simulateDelay();

    try {
      debugPrint(
          '🔍 Fetching transactions for wallet $walletId, page: $page, limit: $limit');
      final response = await dio.get(
        '/wallets/$walletId/transactions',
        queryParameters: {
          'page': page,
          'limit': limit,
        },
      );

      if (response.statusCode == 200) {
        debugPrint('✅ Transactions API response: ${response.data}');
        List<dynamic> transactionsJson;

        // Handle different response formats
        if (response.data is Map<String, dynamic> &&
            response.data['data'] != null) {
          // Response format: {"data": [...]}
          debugPrint('📄 Found transactions in data field');
          transactionsJson = response.data['data'] as List<dynamic>;
        } else if (response.data is List<dynamic>) {
          // Response format: [...]
          debugPrint('📄 Found transactions as direct list');
          transactionsJson = response.data as List<dynamic>;
        } else if (response.data is Map<String, dynamic> &&
            response.data['transactions'] != null) {
          // Response format: {"transactions": [...], "total": n, "page": p, "limit": l}
          debugPrint('📄 Found transactions in transactions field');
          // This is our TransactionListResponse format
          TransactionListResponse listResponse =
              TransactionListResponse.fromJson(
                  response.data as Map<String, dynamic>);
          debugPrint(
              '📊 Parsed TransactionListResponse with ${listResponse.transactions.length} transactions');
          return listResponse.transactions;
        } else {
          // Unexpected format, return empty list
          debugPrint(
              '⚠️ Unexpected API response format: ${response.data.runtimeType} - ${response.data}');
          return <TransactionModel>[];
        }

        // For the direct list or data field cases
        try {
          final models = transactionsJson.map((json) {
            debugPrint('🔄 Processing transaction JSON: $json');
            return TransactionModel.fromJson(json as Map<String, dynamic>);
          }).toList();
          debugPrint('📊 Parsed ${models.length} transaction models');
          return models;
        } catch (e) {
          debugPrint('🔥 Error parsing transaction JSON: $e');
          rethrow;
        }
      } else {
        debugPrint('❌ Failed to fetch transactions: ${response.statusCode}');
        throw ErrorCodeException(message: 'Failed to fetch transactions');
      }
    } on DioException catch (e) {
      debugPrint('🔥 DioException when fetching transactions: ${e.message}');
      throw e.toServerException();
    } catch (e) {
      debugPrint('🔥 Exception when fetching transactions: $e');
      throw ErrorCodeException(message: e.toString());
    }
  }

  @override
  Future<TransactionModel> getTransactionById({
    required String walletId,
    required String transactionId,
  }) async {
    await _simulateDelay();

    try {
      final response =
          await dio.get('/wallets/$walletId/transactions/$transactionId');

      if (response.statusCode == 200) {
        Map<String, dynamic> transactionJson;

        // Handle different response formats
        if (response.data is Map<String, dynamic> &&
            response.data['data'] != null) {
          // Response format: {"data": {...}}
          transactionJson = response.data['data'] as Map<String, dynamic>;
        } else if (response.data is Map<String, dynamic>) {
          // Response format: {...}
          transactionJson = response.data as Map<String, dynamic>;
        } else {
          throw ErrorCodeException(message: 'Invalid transaction data format');
        }

        return TransactionModel.fromJson(transactionJson);
      } else {
        throw ErrorCodeException(message: 'Failed to fetch transaction');
      }
    } on DioException catch (e) {
      throw e.toServerException();
    } catch (e) {
      throw ErrorCodeException(message: e.toString());
    }
  }
}
