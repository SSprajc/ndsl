import 'package:equatable/equatable.dart';

class Todo extends Equatable {
  const Todo({required this.id, required this.name, required this.isCompleted});

  final int id;
  final String name;
  final bool isCompleted;

  @override
  List<Object?> get props => [id, name, isCompleted];
}
