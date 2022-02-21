import 'package:alfred/alfred.dart';
import 'package:pennyworth/pennyworth.dart';

import 'todo/v1_todo_api.dart';
import 'user/v1_user_api.dart';

// ignore: camel_case_types
class Api_v1 extends OpenedApiMountPoint {
  Api_v1(NestedRoute parent)
      : mountPoint = parent,
        super([User_v1(), Todo_v1()]);

  @override
  final NestedRoute mountPoint;
}
