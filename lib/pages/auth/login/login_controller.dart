import 'dart:developer';

import 'package:delivery_app/core/exceptions/unauthorized_exception.dart';
import 'package:delivery_app/models/auth_model.dart';
import 'package:delivery_app/pages/auth/login/login_state.dart';
import 'package:delivery_app/repositories/auth/iauth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends Cubit<LoginState> {
  final IAuthRepository _authRepository;

  LoginController(this._authRepository) : super(const LoginState.initial());

  Future<void> login(String email, String password) async {
    try {
      emit(state.copyWith(status: LoginStatus.login));

      final AuthModel result = await _authRepository.login(email, password);

      final sharedPreferences = await SharedPreferences.getInstance();
      sharedPreferences.setString("accessToken", result.accessToken);
      sharedPreferences.setString("refreshToken", result.refreshToken);

      emit(state.copyWith(status: LoginStatus.success));
    } on UnauthorizedException catch (e, s) {
      log("Usuário ou senha inválidos", error: e, stackTrace: s);
      emit(
        state.copyWith(
          status: LoginStatus.loginError,
          errorMessage: "Usuário ou senha inválidos",
        ),
      );
    } catch (e, s) {
      log("Erro ao realizar login", error: e, stackTrace: s);
      emit(state.copyWith(status: LoginStatus.error));
    }
  }
}
