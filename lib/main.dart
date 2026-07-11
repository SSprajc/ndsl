import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_widget/home_widget.dart';

import 'bootstrap.dart';
import 'data/todo_repository.dart';
import 'presentation/todo_cubit.dart';
import 'presentation/todo_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  HomeWidget.setAppGroupId(appGroupId);
  HomeWidget.registerInteractivityCallback(widgetBackgroundCallback);
  runApp(NdslApp(repository: createRepository()));
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
