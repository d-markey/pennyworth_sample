import 'package:pennyworth/pennyworth.dart';

import 'api_key_middleware.dart';
import 'role_middleware.dart';

class MiddlewareResolver {
  MiddlewareResolver([this.tokenUrl]);

  final String? tokenUrl;

  SecuritySpecification? resolve(
      ApiSpecification doc, AlfredMiddleware middleware) {
    final apiKeyMiddleware = ApiKeyMiddleware.find(middleware);
    if (apiKeyMiddleware != null) return apiKeyMiddleware.security;
    final roleMiddleware = RoleMiddleware.find(middleware);
    if (roleMiddleware != null) return roleMiddleware.security;
    return null;
  }
}
