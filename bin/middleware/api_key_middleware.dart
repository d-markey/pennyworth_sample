import 'dart:async';
import 'dart:io';

import 'package:alfred/alfred.dart';
import 'package:pennyworth/pennyworth.dart';

import '../extensions.dart';
import '../services/api_key_service.dart';

class ApiKeyMiddleware {
  ApiKeyMiddleware._(this.header);

  static final Map<String, ApiKeyMiddleware> _instances =
      <String, ApiKeyMiddleware>{};

  static AlfredMiddleware get(String apiKeyHeader) => _instances
      .putIfAbsent(
          apiKeyHeader.toLowerCase(), () => ApiKeyMiddleware._(apiKeyHeader))
      ._checkApiKey;

  static ApiKeyMiddleware? find(AlfredMiddleware middleware) => _instances
      .values
      .singleOrNullWhere((m) => m._checkApiKey == middleware);

  final String header;
  final _apiKeyService = ApiKeyService();

  FutureOr _checkApiKey(HttpRequest req, HttpResponse res) async {
    req.alfred.logWriter(
        () => 'Checking API key for request ${req.method} ${req.uri}',
        LogType.debug);
    final apiKey = req.headers.value(header) ?? '';
    final valid = await _apiKeyService.checkApiKey(apiKey);
    if (!valid) {
      req.alfred.logWriter(
          () => 'API key check failed for request ${req.method} ${req.uri}',
          LogType.warn);
      throw AlfredException(HttpStatus.forbidden, 'Invalid API key');
    }
    return null;
  }
}
