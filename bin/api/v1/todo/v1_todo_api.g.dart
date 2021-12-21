// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'v1_todo_api.dart';

// **************************************************************************
// RestEntityGenerator
// **************************************************************************

// REST Entity: TodoDto

extension TodoDtoRegistrationExt on OpenApiService {
  void registerTodoDto() {
    registerTypeSpecification<TodoDto>(TypeSpecification.object(
            title: 'To do item')
        .addProperty(PropertySpecification.integer('id', nullable: true))
        .addProperty(PropertySpecification.string('title', nullable: true))
        .addProperty(PropertySpecification.string('comment', nullable: true))
        .addProperty(PropertySpecification.object('user',
            type: UserInfoDto, nullable: true))
        .addProperty(PropertySpecification.object('error',
            type: RestError, nullable: true)));
    registerTypeSpecification<List<TodoDto>>(TypeSpecification.array(
        items: TypeSpecification.object(type: TodoDto),
        title: 'To do item (array)'));
  }
}

extension TodoDtoSerializationExt on TodoDto {
  Map autoSerialize() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['title'] = title;
    map['comment'] = comment;
    map['user'] = user?.toJson();
    map['error'] = error?.toJson();
    return map;
  }
}

extension TodoDtoDeserializationExt on Map {
  TodoDto autoDeserializeTodoDto() {
    return TodoDto(
        this['id'],
        this['title'],
        this['comment'],
        (this['user'] == null)
            ? null
            : (this['user'] as Map).autoDeserializeUserInfoDto());
  }
}

extension TodoDtoRequestExt on HttpRequest {
  Future<TodoDto> getTodoDto() async {
    final body = await bodyAsJsonMap;
    return body.autoDeserializeTodoDto();
  }

  Future<List<TodoDto>> getListOfTodoDto() async {
    final body = await bodyAsJsonList;
    return body.map((item) => (item as Map).autoDeserializeTodoDto()).toList();
  }
}

// **************************************************************************
// RestServiceGenerator
// **************************************************************************

// REST Service Todo_v1

// ignore: camel_case_extensions
extension Todo_v1_MounterExt on NestedRoute {
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
  List<OpenApiRoute> mount_Todo_v1(Todo_v1 api, OpenApiService openApiService) {
    // ensure types used by these operations are registered
    openApiService.registerTodoDto();

    // mount operations on the service's base URI
    final mountPoint = route('/todo', middleware: [
      ApiKeyMiddleware.get('X-API-Key'),
    ]);
    final tags = ['TODO'];
    return <OpenApiRoute>[
      OpenApiRoute(
          mountPoint.put(
              '/',
              (req, res) => _process(req, res, (req, res) async {
                    final input = await req.getTodoDto();
                    return await api.create(req, input);
                  }),
              middleware: [
                RoleMiddleware.get('USR'),
              ]),
          summary: 'Create a to-do item',
          operationId: 'Todo_v1.create.put',
          input: TodoDto,
          output: TodoDto,
          tags: tags),
      OpenApiRoute(
          mountPoint.post(
              '/',
              (req, res) => _process(req, res, (req, res) async {
                    final input = await req.getTodoDto();
                    return await api.create(req, input);
                  }),
              middleware: [
                RoleMiddleware.get('USR'),
              ]),
          summary: 'Create a to-do item',
          operationId: 'Todo_v1.create.post',
          input: TodoDto,
          output: TodoDto,
          tags: tags),
      OpenApiRoute(
          mountPoint.patch(
              '/:id:int',
              (req, res) => _process(req, res, (req, res) async {
                    final input = await req.getTodoDto();
                    final id = req.params['id'];
                    return await api.update(req, input, id);
                  }),
              middleware: [
                RoleMiddleware.get('USR'),
              ]),
          summary: 'Update a to-do item',
          operationId: 'Todo_v1.update',
          input: TodoDto,
          output: TodoDto,
          tags: tags),
      OpenApiRoute(
          mountPoint.get(
              '/:id:int',
              (req, res) => _process(req, res, (req, res) async {
                    final id = req.params['id'];
                    return await api.get(req, id);
                  }),
              middleware: [
                RoleMiddleware.get('USR'),
              ]),
          summary: 'Get a to-do item',
          operationId: 'Todo_v1.get',
          output: TodoDto,
          tags: tags),
      OpenApiRoute(
          mountPoint.get(
              '/my-items',
              (req, res) => _process(req, res, (req, res) async {
                    return await api.myItems(req);
                  }),
              middleware: [
                RoleMiddleware.get('USR'),
              ]),
          summary: 'Get the user\'s to-do items',
          operationId: 'Todo_v1.myItems',
          output: List<TodoDto>,
          tags: tags)
    ];
  }
}
