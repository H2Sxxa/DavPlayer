import 'package:davplayer/routers.dart';
import 'package:davplayer/providers/webdav.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(ChangeNotifierProvider.value(
    value: WebDavClientProvider(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (lightDynamic, darkDynamic) => MaterialApp.router(
        themeMode: ThemeMode.system,
        theme: ThemeData.from(
          colorScheme: lightDynamic ??
              ColorScheme.fromSeed(seedColor: Colors.pink.shade200),
          useMaterial3: true,
        ).copyWith(brightness: Brightness.light),
        darkTheme: ThemeData.from(
          colorScheme: darkDynamic ??
              ColorScheme.fromSeed(seedColor: Colors.pink.shade200),
          useMaterial3: true,
        ).copyWith(brightness: Brightness.dark),
        routerConfig: router,
      ),
    );
  }
}
