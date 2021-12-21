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

extension RestErrorSerializationExt on RestError {
  Map autoSerialize() {
    final map = <String, dynamic>{};
    map['statusCode'] = statusCode;
    map['message'] = message;
    return map;
  }
}

extension RestErrorDeserializationExt on Map {
  RestError autoDeserializeRestError() {
    return RestError(statusCode: this['statusCode'], message: this['message']);
  }
}

extension RestErrorRequestExt on HttpRequest {
  Future<RestError> getRestError() async {
    final body = await bodyAsJsonMap;
    return body.autoDeserializeRestError();
  }

  Future<List<RestError>> getListOfRestError() async {
    final body = await bodyAsJsonList;
    return body
        .map((item) => (item as Map).autoDeserializeRestError())
        .toList();
  }
}
