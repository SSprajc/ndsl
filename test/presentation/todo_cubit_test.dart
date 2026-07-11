import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ndsl/data/todo_repository.dart';
import 'package:ndsl/domain/todo.dart';
import 'package:ndsl/presentation/todo_cubit.dart';
import 'package:ndsl/presentation/todo_state.dart';

class MockTodoRepository extends Mock implements TodoRepository {}

void main() {
  const todo = Todo(id: 1, name: 'run', isCompleted: false);
  const done = Todo(id: 1, name: 'run', isCompleted: true);

  late MockTodoRepository repo;

  setUp(() {
    repo = MockTodoRepository();
    when(() => repo.rolloverIfNeeded()).thenAnswer((_) async {});
    when(() => repo.watchTodos()).thenAnswer((_) => Stream.value(const [todo]));
    when(() => repo.watchStreak()).thenAnswer((_) => Stream.value(3));
  });

  test('runs rollover before subscribing on creation', () async {
    final cubit = TodoCubit(repo);
    await expectLater(
      cubit.stream,
      emitsThrough(const TodoState(todos: [todo], streak: 3)),
    );
    verify(() => repo.rolloverIfNeeded()).called(1);
    await cubit.close();
  });

  test('add, complete and delete delegate to the repository', () async {
    when(() => repo.addTodo(any())).thenAnswer((_) async {});
    when(() => repo.completeTodo(any())).thenAnswer((_) async {});
    when(() => repo.deleteTodo(any())).thenAnswer((_) async {});

    final cubit = TodoCubit(repo);
    await cubit.add('read');
    await cubit.complete(1);
    await cubit.delete(2);

    verify(() => repo.addTodo('read')).called(1);
    verify(() => repo.completeTodo(1)).called(1);
    verify(() => repo.deleteTodo(2)).called(1);
    await cubit.close();
  });

  test('appResumed triggers another rollover check', () async {
    final cubit = TodoCubit(repo);
    await cubit.appResumed();
    verify(() => repo.rolloverIfNeeded()).called(2);
    await cubit.close();
  });

  group('TodoState.allDone', () {
    test('false for empty list', () {
      expect(const TodoState(todos: [], streak: 0).allDone, isFalse);
    });

    test('false while any item is open', () {
      expect(const TodoState(todos: [todo, done], streak: 0).allDone, isFalse);
    });

    test('true when every item is completed', () {
      expect(const TodoState(todos: [done], streak: 0).allDone, isTrue);
    });
  });
}
