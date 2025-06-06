import 'package:dio/dio.dart';

import '../core.dart';

extension DioErrorExtension on DioException {
  ServerException toServerException() {
    MetaError? meta;
    try {
      if (response?.data != null && response?.data is Map<String, dynamic>) {
        meta = MetaError.fromJson(response!.data);
      }
    } catch (e) {
      // If parsing fails, meta will remain null and we'll use default messages
      meta = null;
    }

    switch (type) {
      case DioExceptionType.badResponse:
        switch (response?.statusCode) {
          case 401:
            return UnAuthenticationServerException(
              message: meta?.message ?? 'Unauthorized',
              code: response?.statusCode,
            );
          case 403:
            return UnAuthorizeServerException(
              message: meta?.message ?? 'Forbidden',
              code: response?.statusCode,
            );
          case 404:
            return NotFoundServerException(
              message: meta?.message ?? 'Not found',
              code: response?.statusCode,
            );
          case 500:
          case 502:
            return InternalServerException(
              message: meta?.message ?? 'Internal server error',
              code: response?.statusCode,
            );
          default:
            return GeneralServerException(
              message: meta?.message ?? 'Internal server error',
              code: response?.statusCode,
            );
        }

      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return TimeOutServerException(
          message: meta?.message ?? 'Connection timeout',
          code: response?.statusCode,
        );

      case DioExceptionType.cancel:
      case DioExceptionType.badCertificate:
      case DioExceptionType.connectionError:
      case DioExceptionType.unknown:
        return GeneralServerException(
          message: meta?.message ?? 'A Server Error Occurred',
          code: response?.statusCode,
        );
    }
  }
}
