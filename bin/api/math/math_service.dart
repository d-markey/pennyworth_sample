import 'dart:math' as math;
import 'dart:async';
import 'dart:io';

import 'package:alfred/alfred.dart';
import 'package:pennyworth/pennyworth.dart';

part 'math_service.g.dart';

@RestService('/', tags: ['MATH'])
class MathService extends NestedOpenedApi {
  MathService();

  @RestOperation(uri: '/add/:a:int/:b:int', summary: 'Returns a + b', output: int)
  Future<int> add(int a, int b) async {
    return a + b;
  }

  @RestOperation(uri: '/sub/:a:int/:b:int', summary: 'Returns a - b', output: int)
  Future<int> sub(int a, int b) async {
    return a - b;
  }

  @RestOperation(uri: '/mul/:a:int/:b:int', summary: 'Returns a * b', output: int)
  Future<int> mul(int a, int b) async {
    return a * b;
  }

  @RestOperation(uri: '/div/:a:int/:b:int', summary: 'Returns a / b', output: int)
  Future<double> div(int a, int b) async {
    if (b == 0) throw AlfredException(403, 'Division by 0');
    return a / b;
  }

  @RestOperation(uri: '/sqrt/:x:double', summary: 'Returns sqrt(x)', output: double)
  Future<double> sqrt(double x) async {
    if (x < 0) throw AlfredException(403, 'Square root of negative number');
    return math.sqrt(x);
  }

  @override
  List<OpenApiRoute> mount(
          NestedRoute parentRoute, OpenApiService openApiService) =>
      parentRoute.mount_MathService(this, openApiService);
}
