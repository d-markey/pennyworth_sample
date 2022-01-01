import 'dart:io';

import 'package:alfred/alfred.dart';

import '../extensions.dart';
import '../model/user.dart';

class UserSession {
  const UserSession._(this.userId, this.roles);

  UserSession.start(HttpRequest req, User user)
      : userId = user.userid,
        roles = user.roles.toList() {
    req.store.set(UserSessionExt._sessionKey, this);
  }

  static const none = UserSession._('', []);

  factory UserSession.load(HttpRequest req) {
    final cookie =
        req.cookies.singleOrNullWhere((c) => c.name == sessionCookieName);
    if (cookie == null) {
      return UserSession.none;
    } else {
      final parts = cookie.value.split('/');
      return UserSession._(parts[0], parts[1].split('+'));
    }
  }

  void save(HttpRequest req, HttpResponse res) {
    if (isEmpty) {
      req.store.unset(UserSessionExt._sessionKey);
      final cookie = Cookie(sessionCookieName, '/');
      cookie.expires = DateTime.now().add(Duration(days: -1));
      cookie.path = '/api';
      res.cookies.add(cookie);
    } else {
      req.store.set(UserSessionExt._sessionKey, this);
      final cookie = Cookie(sessionCookieName, userId + '/' + roles.join('+'));
      cookie.expires = DateTime.now().add(Duration(days: 7));
      cookie.path = '/api';
      res.cookies.add(cookie);
    }
  }

  static void clear(HttpRequest req, HttpResponse res) {
    none.save(req, res);
  }

  final String userId;
  final List<String> roles;

  bool get isEmpty => userId.trim().isEmpty;

  static const String sessionCookieName = 'NEVER_DO_THIS';
}

extension UserSessionExt on HttpRequest {
  static const String _sessionKey = r'req$session';

  UserSession get userSession =>
      store.getOrSet<UserSession>(_sessionKey, () => UserSession.load(this));
}
