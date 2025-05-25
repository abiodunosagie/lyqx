import 'package:injectable/injectable.dart';

import '../model/user_model.dart';
import '../service/api_service.dart';

@lazySingleton
class AuthRepository {
  final ApiService api;

  AuthRepository(this.api);

  Future<bool> login(User user) async {
    try {
      final response = await api.login(user.toJson());
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }
}
