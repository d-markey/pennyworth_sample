import 'dart:async';

import '../model/user.dart';
import '../repoitories/user_repository.dart';

class UserService {
  FutureOr<User?> login(String userId, String password) async {
    final user = await UserRepository.instance.find(userId);
    if (user == null) return null;
    if (user.password != password) return null;
    return user;
  }

  FutureOr<User?> getInfo(String userId) =>
      UserRepository.instance.find(userId);
}
