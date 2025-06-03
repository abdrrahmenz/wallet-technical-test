import 'package:dio/dio.dart';
import '../../../../core/core.dart';
import '../../auth.dart';

abstract class AuthApiSource {
  Future<UserModel> login({
    required String email,
    required String password,
  });

  Future<UserModel> register({
    String? name,
    required String email,
    required String password,
  });

}

class AuthApiSourceImpl implements AuthApiSource {
  AuthApiSourceImpl(this.dio, {required this.authLocalSource});

  final Dio dio;
  final AuthLocalSource authLocalSource;

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await dio.post('/auth/login', data: {
        'email': email,
        'password': password,
      });

      if (response.statusCode == 200) {
        // Save the access token from the direct response
        await authLocalSource.saveCache(response.data['access_token']);

        // Return a basic user model with email instead of calling getProfile()
        // This prevents the automatic API call that was causing 404 errors
        return UserModel(
          id: '', // Will be populated when profile is actually needed
          email: email,
          name: '', // Will be populated when profile is actually needed
          username: '', // Will be populated when profile is actually needed
          role: 'user', // Default role
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
      } else {
        throw ErrorCodeException(message: 'Login failed');
      }
    } on DioException catch (e) {
      throw e.toServerException();
    } catch (e) {
      throw ErrorCodeException(message: e.toString());
    }
  }

  @override
  Future<UserModel> register({
    String? name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await dio.post('/auth/register', data: {
        'email': email,
        if (name != null) 'name': name,
        'password': password,
      });

      // Based on the API response format, it returns user data directly
      // TODO: Handle access_token if the API provides it in the future
      return UserModel.fromJson(response.data);
    } on DioException catch (e) {
      throw e.toServerException();
    } catch (e) {
      throw ErrorCodeException(message: e.toString());
    }
  }
}
