import 'dart:async';
import 'dart:io';

import 'package:alfred/alfred.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:pennyworth/pennyworth.dart';

import '../../../middleware/role_middleware.dart';
import '../../../middleware/user_session.dart';
import '../../../model/user.dart';
import '../../../services/user_service.dart';
import '../../rest_error.dart';

part 'v1_user_api.g.dart';

@RestService('/user', tags: ['USER'])
// ignore: camel_case_types
class User_v1 extends NestedOpenApi {
  User_v1();

  final _userService = UserService();

  @RestOperation.post
  @RestOperation(summary: 'Authenticate user')
  @RestOperation.tags(['AUTH'])
  Future login(
      HttpRequest req, HttpResponse res, UserLoginDto loginRequest) async {
    final user =
        await _userService.login(loginRequest.userId, loginRequest.password);
    if (user == null) {
      throw AlfredException(HttpStatus.unauthorized, 'Bad credentials');
    }
    final session = UserSession.start(req, user);
    session.save(req, res);
  }

  @RestOperation(summary: 'Log user out', tags: ['AUTH'])
  void logout(HttpRequest req, HttpResponse res) {
    req.alfred.logWriter(() => 'logging out', LogType.debug);
    UserSession.clear(req, res);
  }

  @RestOperation(uri: '/:userid:alpha', summary: 'Get user info')
  @RestOperation.middleware([
    [RoleMiddleware, 'ADM']
  ])
  Future<UserInfoDto> getUserInfo(String userId) async {
    final user = await _userService.getInfo(userId);
    if (user == null) {
      throw AlfredException(HttpStatus.notFound, 'User not found');
    }
    return UserInfoDto.success(user);
  }

  @override
  List<OpenApiRoute> mount(
      NestedRoute parentRoute, OpenApiService openApiService) {
    openApiService.registerUserInfoDto();
    openApiService.registerUserLoginDto();
    return parentRoute.mount_User_v1(this, openApiService);
  }
}

@RestEntity(title: 'User login')
@JsonSerializable()
class UserLoginDto {
  UserLoginDto({required this.userId, required this.password});

  final String userId;
  final String password;

  // json_serializer serialization
  Map toJson() => _$UserLoginDtoToJson(this);

  static UserLoginDto fromJson(Map<String, dynamic> json) =>
      _$UserLoginDtoFromJson(json);
}

@JsonSerializable()
@RestEntity(title: 'User info')
class UserInfoDto {
  UserInfoDto(this.userId, this.name, this.roles) : error = null;

  UserInfoDto.success(User user)
      : userId = user.userid,
        name = user.name,
        roles = user.roles.toList(),
        error = null;

  UserInfoDto.error(this.error)
      : userId = '',
        name = null,
        roles = null;

  final String userId;
  final String? name;
  final List<String>? roles;
  final RestError? error;

  // json_serializer serialization
  Map toJson() => _$UserInfoDtoToJson(this);

  static UserInfoDto fromJson(Map<String, dynamic> json) =>
      _$UserInfoDtoFromJson(json);
}
