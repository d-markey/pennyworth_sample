import 'package:pennyworth/pennyworth.dart';

import 'api_key_middleware.dart';
import 'role_middleware.dart';
import 'user_session.dart';

class MiddlewareResolver {
  MiddlewareResolver([this.tokenUrl]);

  final String? tokenUrl;

  SecuritySpecification? resolve(
      ApiSpecification doc, AlfredMiddleware middleware) {
    final apiKeyMiddleware = ApiKeyMiddleware.find(middleware);
    if (apiKeyMiddleware != null) {
      return ApiKeySpecification(
          'APIKey', 'Api Key security', 'header', apiKeyMiddleware.header);
    }
    final roleMiddleware = RoleMiddleware.find(middleware);
    if (roleMiddleware != null) {
      return ApiKeySpecification(
          'Cookie', 'Session cookie', 'cookie', UserSession.sessionCookieName);
    }
    return null;
  }
}
