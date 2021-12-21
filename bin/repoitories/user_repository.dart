import 'dart:async';

import '../model/user.dart';

class UserRepository {
  UserRepository._() {
    _users['admin'] = User('admin', 'r00tpwd', 'root', ['USR', 'ADM']);
    _users['user1'] = User('user1', 'password', 'User 1', ['USR']);
    _users['user2'] = User('user2', 'password', 'User 2', ['USR']);
  }

  static final instance = UserRepository._();

  final _users = <String, User>{};

  FutureOr<User?> find(String userId) => _users[userId];
}
