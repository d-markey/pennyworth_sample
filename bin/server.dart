import 'dart:io';

import 'package:alfred/alfred.dart';
import 'package:pennyworth/pennyworth.dart';
import 'package:pennyworth/open_api_v3.dart' as v3;
import 'package:pennyworth/open_api_v2.dart' as v2;

import 'api/rest_error.dart';
import 'middleware/middleware_resolver.dart';
import 'api/v1/v1.dart';

void main(List<String> args) async {
  startServer();
}

void startServer() async {
  final app = Alfred();

  app.typeHandlers.insert(0, openApiTypeHandler);

  final openApiService = setupOpenApiDocumentation_v3(app);

  var apis = [
    Api_v1(app.route('/api')),
    SwaggerApi(app.route('/dev/open-api'), openApiService,
        Directory('assets/swagger-ui-4.1.2/')),
  ];

  for (var api in apis) {
    openApiService.mount(api);
  }

  final server = await app.listen(8080);

  openApiService.addServer(server);

  app.printRoutes();
}

// ignore: non_constant_identifier_names
OpenApiService setupOpenApiDocumentation_v3(Alfred app) {
  final middlewareResolver = MiddlewareResolver();
  final openApiService = v3.OpenApiService(
      'Example API backend', 'v1', middlewareResolver.resolve);

  openApiService.registerTypeSpecification<DateTime>(
      TypeSpecification.integer(title: 'Date/time (in ms since Epoch)'));

  openApiService.registerParameter(v3.Parameter('code', 'path',
      schema: openApiService.getSchema(String),
      description: 'The code of the item'));
  openApiService.registerParameter(
    v3.Parameter('userid', 'path',
        schema: openApiService.getSchema(String),
        description: 'The ID of the user'),
  );
  openApiService.registerParameter(v3.Parameter('id', 'path',
      schema: openApiService.getSchema(int),
      description: 'The ID of the entity'));

  openApiService.registerRestError();

  return openApiService;
}

// ignore: non_constant_identifier_names
OpenApiService setupOpenApiDocumentation_v2(Alfred app) {
  final middlewareResolver = MiddlewareResolver();
  final openApiService = v2.OpenApiService(
      'Example API backend', 'v1', middlewareResolver.resolve);

  openApiService.registerTypeSpecification<DateTime>(
      TypeSpecification.integer(title: 'Date/time (in ms since Epoch)'));

  openApiService.registerParameter(v2.Parameter('code', 'path',
      schema: openApiService.getSchema(String),
      description: 'The code of the item'));
  openApiService.registerParameter(
    v2.Parameter('userid', 'path',
        schema: openApiService.getSchema(String),
        description: 'The ID of the user'),
  );
  openApiService.registerParameter(v2.Parameter('id', 'path',
      schema: openApiService.getSchema(int),
      description: 'The ID of the entity'));

  openApiService.registerRestError();

  return openApiService;
}
