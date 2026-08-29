// Asset generator (not a behavioural test). Renders the Dart Mascot painter to
// transparent PNGs for the Android home-screen widget, which can't custom-draw.
// Run: flutter test test/generate_widget_assets.dart
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ndsl/presentation/widgets/mascot.dart';
import 'package:ndsl/theme/app_theme.dart';

Future<void> _render(WidgetTester tester, Widget mascot, String path, {double pr = 4}) async {
  final key = GlobalKey();
  await tester.pumpWidget(
    Theme(
      data: buildAppTheme(Brightness.light),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Center(child: RepaintBoundary(key: key, child: mascot)),
      ),
    ),
  );
  await tester.pump();
  await tester.runAsync(() async {
    final boundary = key.currentContext!.findRenderObject() as RenderRepaintBoundary;
    final image = await boundary.toImage(pixelRatio: pr);
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    Directory(File(path).parent.path).createSync(recursive: true);
    File(path).writeAsBytesSync(bytes!.buffer.asUint8List());
    // ignore: avoid_print
    print('wrote $path (${image.width}x${image.height})');
    image.dispose();
  });
}

void main() {
  const dir = 'android/app/src/main/res/drawable-nodpi';
  testWidgets('generate widget mascot PNGs', (tester) async {
    await _render(tester, const Mascot(pose: MascotPose.peek, m: 100, idle: false), '$dir/mascot_peek.png');
    await _render(
        tester, const Mascot(pose: MascotPose.cheer, m: 100, white: true, idle: false), '$dir/mascot_cheer_white.png');
  });

  // Launcher icon sources for flutter_launcher_icons, from design/assets/app_icon.svg
  // (gradient square + white peek mascot). Rendered at 512 logical, pr 2 => 1024px.
  testWidgets('generate launcher icon sources', (tester) async {
    const gradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFFFF6D31), Color(0xFFE62845)],
    );
    // White-limb icon variant: white body/limbs, dark header + face, coloured dots.
    const iconColors = MascotColors(
      gradA: Color(0xFFFFFFFF),
      gradB: Color(0xFFFFE3D4),
      limb: Color(0xFFFFFFFF),
      dot1: Color(0xFF7965F0),
      dotIdle: Color(0xFFC8C2E0),
      face: Color(0xFF1B1630),
      header: Color(0xFF1B1630),
    );
    // SVG places the mascot at translate(76.8, 103.7) scale(1.667) => m = 166.7.
    const mascot = Positioned(
      left: 76.8,
      top: 103.7,
      child: Mascot(pose: MascotPose.peek, m: 166.7, idle: false, colors: iconColors),
    );
    Widget square({required bool bg, required bool fg}) => SizedBox(
          width: 512,
          height: 512,
          child: Stack(children: [
            if (bg) const Positioned.fill(child: DecoratedBox(decoration: BoxDecoration(gradient: gradient))),
            if (fg) mascot,
          ]),
        );

    // Full icon (iOS + legacy Android), adaptive background, adaptive foreground.
    await _render(tester, square(bg: true, fg: true), 'assets/icon/app_icon.png', pr: 2);
    await _render(tester, square(bg: true, fg: false), 'assets/icon/icon_bg.png', pr: 2);
    await _render(tester, square(bg: false, fg: true), 'assets/icon/icon_fg.png', pr: 2);
  });
}
