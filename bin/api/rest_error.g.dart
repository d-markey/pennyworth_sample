// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rest_error.dart';

// **************************************************************************
// RestEntityGenerator
// **************************************************************************

// REST Entity: RestError

extension RestErrorRegistrationExt on OpenApiService {
  void registerRestError() {
    registerTypeSpecification<RestError>(TypeSpecification.object(
            title: 'Error')
        .addProperty(
            PropertySpecification.integer('statusCode', required: true))
        .addProperty(PropertySpecification.string('message', required: true)));
    registerTypeSpecification<List<RestError>>(TypeSpecification.array(
        items: TypeSpecification.object(type: RestError),
        title: 'Error (array)'));
  }
}

extension RestErrorRequestExt on HttpRequest {
  Future<RestError> getRestError() async {
    final body = await bodyAsJsonMap;
    return RestError.fromJson(body);
  }

  Future<List<RestError>> getListOfRestError() async {
    final body = await bodyAsJsonList;
    return body
        .map((item) => RestError.fromJson((item as Map<String, dynamic>)))
        .toList();
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RestError _$RestErrorFromJson(Map<String, dynamic> json) => RestError(
      statusCode: json['statusCode'] as int,
      message: json['message'] as String,
    );

Map<String, dynamic> _$RestErrorToJson(RestError instance) => <String, dynamic>{
      'statusCode': instance.statusCode,
      'message': instance.message,
    };
