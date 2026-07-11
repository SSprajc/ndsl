import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'data/database.dart';
import 'data/todo_repository.dart';
import 'data/widget_state_writer.dart';
import 'presentation/todo_cubit.dart';
import 'presentation/todo_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // ponytail: default app dir for now; Phase 2 moves the file into the iOS
  // App Group container (required for the widget extension) on first launch.
  final db = AppDatabase(driftDatabase(name: 'ndsl'));
  final repository = TodoRepository(db, WidgetStateWriter());
  runApp(NdslApp(repository: repository));
}

class NdslApp extends StatelessWidget {
  const NdslApp({super.key, required this.repository});

  final TodoRepository repository;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ndsl',
      home: BlocProvider(
        create: (_) => TodoCubit(repository),
        child: const TodoScreen(),
      ),
    );
  }
}
