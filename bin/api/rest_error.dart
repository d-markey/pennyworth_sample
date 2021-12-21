import 'package:alfred/alfred.dart';
import 'package:pennyworth/pennyworth.dart';

part 'rest_error.g.dart';

@RestEntity(title: 'Error')
class RestError {
  RestError({required this.statusCode, required this.message});

  final int statusCode;
  final String message;

  Map toJson() => autoSerialize();
}
