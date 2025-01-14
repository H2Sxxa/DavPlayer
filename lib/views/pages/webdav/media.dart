import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class MultiMediaWidget extends HookWidget {
  final Future<Uint8List> data;
  const MultiMediaWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final resolve = useMemoized(() async {
      final rev = await data;
      try {
        await decodeImageFromList(rev);
        return Image.memory(rev);
      } catch (_) {}
      try {
        final text = String.fromCharCodes(Uint16List.sublistView(rev));
        return SelectableText(text);
      } catch (_) {}
      return const Text("Unsupport");
    });

    final child = useFuture(resolve);
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: child.data ?? const CircularProgressIndicator(),
      ),
    );
  }
}
