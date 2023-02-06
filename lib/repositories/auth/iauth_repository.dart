import 'package:delivery_app/models/auth_model.dart';

abstract class IAuthRepository {
  Future<void> register(String name, String email, String password);

  Future<AuthModel> login(String email, String password);
}
