// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'v1_user_api.dart';

// **************************************************************************
// RestEntityGenerator
// **************************************************************************

// REST Entity: UserLoginDto

extension UserLoginDtoRegistrationExt on OpenApiService {
  void registerUserLoginDto() {
    registerTypeSpecification<UserLoginDto>(TypeSpecification.object(
            title: 'User login')
        .addProperty(PropertySpecification.string('userId', required: true))
        .addProperty(PropertySpecification.string('password', required: true)));
    registerTypeSpecification<List<UserLoginDto>>(TypeSpecification.array(
        items: TypeSpecification.object(type: UserLoginDto),
        title: 'User login (array)'));
  }
}

extension UserLoginDtoSerializationExt on UserLoginDto {
  Map<String, dynamic> autoSerialize() => <String, dynamic>{
        'userId': userId,
        'password': password,
      };
}

extension UserLoginDtoDeserializationExt on Map<String, dynamic> {
  UserLoginDto autoDeserializeUserLoginDto() {
    return UserLoginDto(userId: this['userId'], password: this['password']);
  }
}

extension UserLoginDtoRequestExt on HttpRequest {
  Future<UserLoginDto> getUserLoginDto() async {
    final body = await bodyAsJsonMap;
    return UserLoginDto.fromJson(body);
  }

  Future<List<UserLoginDto>> getListOfUserLoginDto() async {
    final body = await bodyAsJsonList;
    return body
        .map((item) => UserLoginDto.fromJson((item as Map<String, dynamic>)))
        .toList();
  }
}

// REST Entity: UserInfoDto

extension UserInfoDtoRegistrationExt on OpenApiService {
  void registerUserInfoDto() {
    registerTypeSpecification<UserInfoDto>(
        TypeSpecification.object(title: 'User info')
            .addProperty(PropertySpecification.string('userId', required: true))
            .addProperty(PropertySpecification.string('name', nullable: true))
            .addProperty(PropertySpecification.array('roles',
                items: TypeSpecification.string(), nullable: true))
            .addProperty(PropertySpecification.object('error',
                type: RestError, nullable: true)));
    registerTypeSpecification<List<UserInfoDto>>(TypeSpecification.array(
        items: TypeSpecification.object(type: UserInfoDto),
        title: 'User info (array)'));
  }
}

extension UserInfoDtoSerializationExt on UserInfoDto {
  Map<String, dynamic> autoSerialize() => <String, dynamic>{
        'userId': userId,
        if (name != null) 'name': name,
        if (roles != null) 'roles': roles,
        if (error != null) 'error': error?.toJson(),
      };
}

extension UserInfoDtoDeserializationExt on Map<String, dynamic> {
  UserInfoDto autoDeserializeUserInfoDto() {
    return UserInfoDto(this['userId'], this['name'], this['roles']);
  }
}

extension UserInfoDtoRequestExt on HttpRequest {
  Future<UserInfoDto> getUserInfoDto() async {
    final body = await bodyAsJsonMap;
    return UserInfoDto.fromJson(body);
  }

  Future<List<UserInfoDto>> getListOfUserInfoDto() async {
    final body = await bodyAsJsonList;
    return body
        .map((item) => UserInfoDto.fromJson((item as Map<String, dynamic>)))
        .toList();
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserLoginDto _$UserLoginDtoFromJson(Map<String, dynamic> json) => UserLoginDto(
      userId: json['userId'] as String,
      password: json['password'] as String,
    );

Map<String, dynamic> _$UserLoginDtoToJson(UserLoginDto instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'password': instance.password,
    };

UserInfoDto _$UserInfoDtoFromJson(Map<String, dynamic> json) => UserInfoDto(
      json['userId'] as String,
      json['name'] as String?,
      (json['roles'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );

Map<String, dynamic> _$UserInfoDtoToJson(UserInfoDto instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'name': instance.name,
      'roles': instance.roles,
    };

// **************************************************************************
// RestServiceGenerator
// **************************************************************************

// REST Service User_v1

// ignore: camel_case_extensions
extension User_v1_MounterExt on NestedRoute {
  static Future _process(HttpRequest req, HttpResponse res,
      FutureOr Function(HttpRequest req, HttpResponse res) body) async {
    try {
      var ret = body(req, res);
      if (ret is Future) {
        ret = await ret;
      }
      return ret;
    } on AlfredException {
      rethrow;
    } catch (ex) {
      throw AlfredException(
          HttpStatus.internalServerError, 'Internal Server Error');
    }
  }

  // ignore: non_constant_identifier_names
  List<OpenApiRoute> mount_User_v1(User_v1 api, OpenApiService openApiService) {
    // mount operations on the service's base URI
    final mountPoint = route('/user', middleware: const <AlfredMiddleware>[]);
    final tags = ['USER'];
    return <OpenApiRoute>[
      OpenApiRoute(
          mountPoint.post(
            'login',
            (req, res) => _process(req, res, (req, res) async {
              final input = await req.getUserLoginDto();
              return await api.login(req, res, input);
            }),
          ),
          summary: 'Authenticate user',
          operationId: 'User_v1.login',
          input: UserLoginDto,
          tags: tags.followedBy(['AUTH'])),
      OpenApiRoute(
          mountPoint.get(
            'logout',
            (req, res) => _process(req, res, (req, res) {
              api.logout(req, res);
            }),
          ),
          summary: 'Log user out',
          operationId: 'User_v1.logout',
          tags: tags.followedBy(['AUTH'])),
      OpenApiRoute(
          mountPoint.get(
              '/:userid:alpha',
              (req, res) => _process(req, res, (req, res) async {
                    final userid = req.params['userid'];
                    return await api.getUserInfo(userid);
                  }),
              middleware: [
                RoleMiddleware.get('ADM'),
              ]),
          summary: 'Get user info',
          operationId: 'User_v1.getUserInfo',
          output: UserInfoDto,
          tags: tags)
    ];
  }
}
