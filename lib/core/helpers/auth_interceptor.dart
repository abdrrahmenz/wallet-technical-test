import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../features/auth/auth.dart';

/// Error handling when error in interceptor about authentication
class AuthHttpInterceptor extends InterceptorsWrapper {
  /// Repository to get data current token
  final AuthLocalSource authLocalSource;
  final VoidCallback? onUnAuth;

  // Keep track if a force logout is in progress
  static bool _isForceLogoutInProgress = false;

  ///
  AuthHttpInterceptor({
    required this.authLocalSource,
    this.onUnAuth,
  });

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await authLocalSource.getData();

    log('$token', name: 'TOKEN');

    final optionHeaders = <String, Object>{};

    if (token != null) {
      optionHeaders.putIfAbsent('Authorization', () => 'Bearer $token');
    }

    options.headers.addAll(optionHeaders);
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      // Handle 401 Unauthorized response
      log('401 Unauthorized response received', name: 'AUTH_INTERCEPTOR');

      // Prevent multiple simultaneous force logouts
      if (!_isForceLogoutInProgress) {
        _isForceLogoutInProgress = true;

        // Call the onUnAuth callback if provided
        if (onUnAuth != null) {
          onUnAuth!();
        } else {
          // Default handling: force logout
          await _forceLogout();
        }

        _isForceLogoutInProgress = false;
      }
    }

    // Pass the error to the next handler regardless
    handler.next(err);
  }

  /// Force logout by clearing token and triggering AuthBloc
  Future<void> _forceLogout() async {
    try {
      // Clear the auth token from local storage
      await authLocalSource.clearCache();

      // Try to access AuthBloc and trigger logout if available
      final authBloc = GetIt.instance<AuthBloc>();
      authBloc.add(LogoutEvent());

      log('Force logout completed', name: 'AUTH_INTERCEPTOR');
    } catch (e) {
      log('Error during force logout: $e', name: 'AUTH_INTERCEPTOR');
    }
  }
}
