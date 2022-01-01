import 'dart:async';
import 'dart:io';

import 'package:alfred/alfred.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pennyworth/pennyworth.dart';

import '../../../middleware/api_key_middleware.dart';
import '../../../middleware/role_middleware.dart';
import '../../../middleware/user_session.dart';
import '../../../model/todo.dart';
import '../../../model/user.dart';
import '../../../repoitories/user_repository.dart';
import '../../../services/todo_service.dart';

import '../../rest_error.dart';
import '../user/v1_user_api.dart';

part 'v1_todo_api.g.dart';

@RestService('/todo', tags: ['TODO'])
@RestService.middleware([
  [ApiKeyMiddleware, 'X-API-Key']
])
// ignore: camel_case_types
class Todo_v1 extends NestedOpenedApi {
  Todo_v1();

  final _todoService = TodoService();

  @RestOperation.put
  @RestOperation.post
  @RestOperation(uri: '/', summary: 'Create a to-do item')
  @RestOperation.middleware([
    [RoleMiddleware, 'USR']
  ])
  Future<TodoDto> create(HttpRequest req, TodoDto todoReq) async {
    final owner = await UserRepository.instance.find(req.userSession.userId);
    if (owner == null) {
      throw AlfredException(HttpStatus.forbidden, 'Authentication required');
    }
    if (todoReq.id != null) {
      throw AlfredException(HttpStatus.badRequest, 'Invalid payload');
    }
    final title = todoReq.title?.trim();
    if (title == null || title.isEmpty) {
      throw AlfredException(HttpStatus.badRequest, 'Missing title');
    }
    final todo = await _todoService.create(owner, title, todoReq.comment);
    return TodoDto.success(todo, owner);
  }

  @RestOperation.patch
  @RestOperation(uri: '/:id:int', summary: 'Update a to-do item')
  @RestOperation.middleware([
    [RoleMiddleware, 'USR']
  ])
  Future<TodoDto> update(HttpRequest req, TodoDto todoReq, int id) async {
    final owner = await UserRepository.instance.find(req.userSession.userId);
    if (owner == null) {
      throw AlfredException(HttpStatus.forbidden, 'Authentication required');
    }
    if (todoReq.id == null || todoReq.id != id) {
      throw AlfredException(HttpStatus.badRequest, 'Invalid payload');
    }
    final title = todoReq.title?.trim();
    if (title == null || title.isNotEmpty) {
      throw AlfredException(HttpStatus.badRequest, 'Missing title');
    }
    final todo =
        await _todoService.update(owner, todoReq.id!, title, todoReq.comment);
    return TodoDto.success(todo, owner);
  }

  @RestOperation(uri: '/:id:int', summary: 'Get a to-do item')
  @RestOperation.middleware([
    [RoleMiddleware, 'USR']
  ])
  Future<TodoDto> get(HttpRequest req, int id) async {
    final owner = await UserRepository.instance.find(req.userSession.userId);
    if (owner == null) {
      throw AlfredException(HttpStatus.forbidden, 'Authentication required');
    }
    final todo = await _todoService.get(id);
    if (todo == null) {
      throw AlfredException(HttpStatus.notFound, 'Todo not found');
    }
    if (todo.ownerId != owner.userid) {
      throw AlfredException(HttpStatus.forbidden, 'Wrong owner');
    }
    return TodoDto.success(todo, owner);
  }

  @RestOperation(uri: '/my-items', summary: 'Get the user\'s to-do items')
  @RestOperation.middleware([
    [RoleMiddleware, 'USR']
  ])
  Future<List<TodoDto>> myItems(HttpRequest req) async {
    final owner = await UserRepository.instance.find(req.userSession.userId);
    if (owner == null) {
      throw AlfredException(HttpStatus.forbidden, 'Authentication required');
    }
    final todos = await _todoService.getForOwner(owner.userid).toList();
    return todos.map((t) => TodoDto.success(t, owner)).toList();
  }

  @override
  List<OpenApiRoute> mount(
          NestedRoute parentRoute, OpenApiService openApiService) =>
      parentRoute.mount_Todo_v1(this, openApiService);
}

@JsonSerializable()
@RestEntity(title: 'To do item')
class TodoDto {
  TodoDto(this.id, this.title, this.comment, this.user) : error = null;

  TodoDto.success(Todo todo, User owner)
      : id = todo.id!,
        title = todo.title,
        comment = todo.comment,
        user = UserInfoDto.success(owner),
        error = null,
        super();

  TodoDto.error(this.error)
      : id = -1,
        title = '',
        comment = null,
        user = null;

  final int? id;
  final String? title;
  final String? comment;
  final UserInfoDto? user;
  final RestError? error;

  Map toJson() => _$TodoDtoToJson(this);

  static TodoDto fromJson(Map<String, dynamic> json) => _$TodoDtoFromJson(json);
}
