import 'dart:async';

import '../model/todo.dart';

class TodoRepository {
  TodoRepository._();

  static final instance = TodoRepository._();

  int _lastId = 0;
  final _todos = <int, Todo>{};

  FutureOr<Todo> create(Todo todo) {
    if (todo.id != null) {
      throw Exception('BusinessException: id is already set');
    }
    final id = ++_lastId;
    final t = Todo(id, todo.title, todo.comment, todo.ownerId);
    _todos[id] = t;
    return t;
  }

  FutureOr<Todo> update(Todo todo) {
    final id = todo.id;
    if (id == null) throw Exception('BusinessException: id is not set');
    final current = _todos[id];
    if (current == null) {
      throw Exception('BusinessException: id not found');
    }
    _todos[id] = todo;
    return todo;
  }

  FutureOr<Todo?> find(int todoId) => _todos[todoId];

  Stream<Todo> getForOwner(String ownerId) async* {
    for (var todo in _todos.values) {
      yield todo;
    }
  }
}
