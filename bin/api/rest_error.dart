import 'package:alfred/alfred.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pennyworth/pennyworth.dart';

part 'rest_error.g.dart';

@JsonSerializable()
@RestEntity(title: 'Error')
class RestError {
  RestError({required this.statusCode, required this.message});

  final int statusCode;
  final String message;

  Map toJson() => _$RestErrorToJson(this);

  static RestError fromJson(Map<String, dynamic> json) => _$RestErrorFromJson(json);
}
