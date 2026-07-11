import 'dart:io';

import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter/widgets.dart';
import 'package:home_widget/home_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path_provider_foundation/path_provider_foundation.dart';

import 'data/database.dart';
import 'data/todo_repository.dart';
import 'data/widget_state_writer.dart';

const appGroupId = 'group.com.example.ndsl';

TodoRepository createRepository() {
  final db = AppDatabase(driftDatabase(
    name: 'ndsl',
    native: const DriftNativeOptions(
      shareAcrossIsolates: true,
      databaseDirectory: _databaseDirectory,
    ),
  ));
  return TodoRepository(db, WidgetStateWriter());
}

Future<Directory> _databaseDirectory() async {
  if (!Platform.isIOS) return getApplicationDocumentsDirectory();
  // The iOS widget extension reads the same file, so it must live in the
  // shared App Group container. Phase 1 builds stored it in Documents; move
  // it over once.
  final container = await PathProviderFoundation()
      .getContainerPath(appGroupIdentifier: appGroupId);
  final dir = Directory(container!);
  await moveDatabaseFiles('ndsl.sqlite',
      from: await getApplicationDocumentsDirectory(), to: dir);
  return dir;
}

/// Moves a sqlite database and its WAL sidecars between directories.
/// No-op when the target database already exists or there is nothing to move.
Future<void> moveDatabaseFiles(
  String name, {
  required Directory from,
  required Directory to,
}) async {
  if (File('${to.path}/$name').existsSync()) return;
  for (final suffix in ['', '-wal', '-shm']) {
    final source = File('${from.path}/$name$suffix');
    if (source.existsSync()) {
      await source.rename('${to.path}/$name$suffix');
    }
  }
}

/// Runs headless when a widget button is tapped (both platforms) or the
/// Android midnight alarm fires.
@pragma('vm:entry-point')
Future<void> widgetBackgroundCallback(Uri? uri) async {
  if (uri == null) return;
  WidgetsFlutterBinding.ensureInitialized();
  await HomeWidget.setAppGroupId(appGroupId);
  _callbackRepo ??= createRepository();
  await handleWidgetUri(uri, _callbackRepo!);
}

TodoRepository? _callbackRepo;

Future<void> handleWidgetUri(Uri uri, TodoRepository repo) async {
  switch (uri.host) {
    case 'complete':
      final id = int.tryParse(uri.queryParameters['id'] ?? '');
      if (id != null) await repo.completeTodo(id);
    case 'rollover':
      await repo.rolloverIfNeeded();
  }
}
