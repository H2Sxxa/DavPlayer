import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class MainPage extends HookWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Drawer(),
      appBar: AppBar(
        title: const Text("DavPlayer"),
      ),
      extendBodyBehindAppBar: true,
      extendBody: true,
    );
  }
}
