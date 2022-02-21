import 'dart:async';
import 'dart:io';

import 'package:alfred/alfred.dart';
import 'package:pennyworth/pennyworth.dart';

import '../extensions.dart';
import 'user_session.dart';

class RoleMiddleware {
  RoleMiddleware._(this.role)
      : security = ApiKeySpecification('Cookie', 'Session cookie', 'cookie',
            UserSession.sessionCookieName);

  static final Map<String, RoleMiddleware> _instances =
      <String, RoleMiddleware>{};

  static AlfredMiddleware get(String role) {
    return _instances.putIfAbsent(role, () => RoleMiddleware._(role))._hasRole;
  }

  static RoleMiddleware? find(AlfredMiddleware middleware) =>
      _instances.values.singleOrNullWhere((m) => m._hasRole == middleware);

  final String role;
  final SecuritySpecification security;

  FutureOr _hasRole(HttpRequest req, HttpResponse res) async {
    req.alfred.logWriter(
        () => 'Checking $role role for request ${req.method} ${req.uri}',
        LogType.debug);
    print(req.cookies.map((e) => '${e.name} => ${e.value}'));
    final hasRole = req.userSession.roles.contains(role);
    if (!hasRole) {
      req.alfred.logWriter(
          () => '$role role check failed for request ${req.method} ${req.uri}',
          LogType.warn);
      req.alfred.logWriter(() => StackTrace.current.toString(), LogType.warn);
      throw AlfredException(HttpStatus.forbidden, '$role role required');
    }
    return null;
  }
}
