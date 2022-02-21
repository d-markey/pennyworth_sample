import 'package:alfred/alfred.dart';
import 'package:pennyworth/pennyworth.dart';

import 'math_service.dart';

class MathApi extends OpenedApiMountPoint {
  MathApi(NestedRoute parent) : mountPoint = parent,
        super([MathService()]);

  @override
  final NestedRoute mountPoint;
}
