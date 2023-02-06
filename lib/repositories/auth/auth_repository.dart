import 'dart:developer';

import 'package:delivery_app/core/exceptions/repository_exption.dart';
import 'package:delivery_app/core/exceptions/unauthorized_exception.dart';
import 'package:delivery_app/core/rest_client/custom_dio.dart';
import 'package:delivery_app/models/auth_model.dart';
import 'package:delivery_app/repositories/auth/iauth_repository.dart';
import 'package:dio/dio.dart';

class AuthRepository implements IAuthRepository {
  final CustomDio dio;

  AuthRepository({
    required this.dio,
  });

  @override
  Future<AuthModel> login(String email, String password) async {
    try {
      final result = await dio.unauth().post(
        "/auth",
        data: {
          "email": email,
          "password": password,
        },
      );

      return AuthModel.fromMap(result.data);
    } on DioError catch (e, s) {
      if (e.response?.statusCode == 403) {
        log("Usuário ou senha inválidos", error: e, stackTrace: s);
        throw UnauthorizedException();
      }

      log("Erro ao autenticar o usuário", error: e, stackTrace: s);
      throw RepositoryException(message: "Erro ao autenticar o usuário");
    }
  }

  @override
  Future<void> register(String name, String email, String password) async {
    try {
      await dio.unauth().post(
        "/users",
        data: {
          "name": name,
          "email": email,
          "password": password,
        },
      );
    } on DioError catch (e, s) {
      log("Erro ao registrar o usuário", error: e, stackTrace: s);
      throw RepositoryException(message: "Erro ao registrar o usuário");
    }
  }
}
