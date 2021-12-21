import 'dart:async';

import '../model/todo.dart';
import '../model/user.dart';
import '../repoitories/todo_repository.dart';

class TodoService {
  FutureOr<Todo> create(User owner, String title, String? comment) =>
      TodoRepository.instance.create(Todo(null, title, comment, owner.userid));

  FutureOr<Todo> update(
      User owner, int id, String title, String? comment) async {
    final current = await TodoRepository.instance.find(id);
    if (current == null) {
      throw Exception('BusinessException: Todo item #$id does not exist');
    }
    if (current.ownerId != owner.userid) {
      throw Exception('BusinessException: Todo item belongs to another user');
    }
    return TodoRepository.instance
        .update(Todo(id, title, comment, owner.userid));
  }

  FutureOr<Todo?> get(int id) => TodoRepository.instance.find(id);

  Stream<Todo> getForOwner(String ownerId) =>
      TodoRepository.instance.getForOwner(ownerId);
}
