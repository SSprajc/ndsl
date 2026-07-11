import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/todo_repository.dart';
import '../domain/todo.dart';
import 'todo_state.dart';

class TodoCubit extends Cubit<TodoState> {
  TodoCubit(this._repo) : super(TodoState.initial) {
    _init();
  }

  final TodoRepository _repo;
  StreamSubscription<List<Todo>>? _todosSub;
  StreamSubscription<int>? _streakSub;

  Future<void> _init() async {
    await _repo.rolloverIfNeeded();
    _todosSub = _repo.watchTodos().listen(
        (todos) => emit(TodoState(todos: todos, streak: state.streak)));
    _streakSub = _repo.watchStreak().listen(
        (streak) => emit(TodoState(todos: state.todos, streak: streak)));
  }

  Future<void> add(String name) => _repo.addTodo(name);

  Future<void> complete(int id) => _repo.completeTodo(id);

  Future<void> delete(int id) => _repo.deleteTodo(id);

  /// Call when the app returns to the foreground: the date may have changed.
  Future<void> appResumed() => _repo.rolloverIfNeeded();

  @override
  Future<void> close() async {
    await _todosSub?.cancel();
    await _streakSub?.cancel();
    return super.close();
  }
}
