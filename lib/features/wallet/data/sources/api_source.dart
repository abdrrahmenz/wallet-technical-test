import 'package:dio/dio.dart';
import '../../../../core/core.dart';
import '../models/models.dart';

abstract class WalletApiSource {
  Future<List<WalletModel>> getWallets();
  Future<WalletModel> getWalletById(String id);
  Future<WalletModel> createWallet({
    String? currency,
    double? initialBalance,
  });
}

class WalletApiSourceImpl implements WalletApiSource {
  WalletApiSourceImpl(this.dio);

  final Dio dio;

  @override
  Future<List<WalletModel>> getWallets() async {
    try {
      final response = await dio.get('/wallets');

      if (response.statusCode == 200) {
        List<dynamic> walletsJson;

        // Handle different response formats
        if (response.data is Map<String, dynamic> &&
            response.data['data'] != null) {
          // Response format: {"data": [...]}
          walletsJson = response.data['data'] as List<dynamic>;
        } else if (response.data is List<dynamic>) {
          // Response format: [...]
          walletsJson = response.data as List<dynamic>;
        } else {
          // Unexpected format, return empty list
          return <WalletModel>[];
        }

        return walletsJson
            .map((json) => WalletModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw ErrorCodeException(message: 'Failed to fetch wallets');
      }
    } on DioException catch (e) {
      throw e.toServerException();
    } catch (e) {
      throw ErrorCodeException(message: e.toString());
    }
  }

  @override
  Future<WalletModel> getWalletById(String id) async {
    try {
      final response = await dio.get('/wallets/$id');

      if (response.statusCode == 200) {
        Map<String, dynamic> walletJson;

        // Handle different response formats
        if (response.data is Map<String, dynamic> &&
            response.data['data'] != null) {
          // Response format: {"data": {...}}
          walletJson = response.data['data'] as Map<String, dynamic>;
        } else if (response.data is Map<String, dynamic>) {
          // Response format: {...}
          walletJson = response.data as Map<String, dynamic>;
        } else {
          throw ErrorCodeException(message: 'Invalid wallet data format');
        }

        return WalletModel.fromJson(walletJson);
      } else {
        throw ErrorCodeException(message: 'Failed to fetch wallet');
      }
    } on DioException catch (e) {
      throw e.toServerException();
    } catch (e) {
      throw ErrorCodeException(message: e.toString());
    }
  }

  @override
  Future<WalletModel> createWallet({
    String? currency,
    double? initialBalance,
  }) async {
    try {
      final response = await dio.post('/wallets', data: {
        if (currency != null) 'currency': currency,
        if (initialBalance != null) 'initial_balance': initialBalance,
      });

      if (response.statusCode == 201) {
        Map<String, dynamic> walletJson;

        // Handle different response formats
        if (response.data is Map<String, dynamic> &&
            response.data['data'] != null) {
          // Response format: {"data": {...}}
          walletJson = response.data['data'] as Map<String, dynamic>;
        } else if (response.data is Map<String, dynamic>) {
          // Response format: {...}
          walletJson = response.data as Map<String, dynamic>;
        } else {
          throw ErrorCodeException(message: 'Invalid wallet data format');
        }

        return WalletModel.fromJson(walletJson);
      } else {
        throw ErrorCodeException(message: 'Failed to create wallet');
      }
    } on DioException catch (e) {
      throw e.toServerException();
    } catch (e) {
      throw ErrorCodeException(message: e.toString());
    }
  }
}
