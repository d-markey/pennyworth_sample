import 'dart:async';

class ApiKeyService {
  FutureOr<bool> checkApiKey(String apiKey) => apiKey == 'hardcoded';
}
