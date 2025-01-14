import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:media_kit/media_kit.dart';

class MultiMediaWidget extends HookWidget {
  final Future<String> source;
  final Future<Uint8List> Function() fetcher;
  final String? path;
  const MultiMediaWidget({
    super.key,
    required this.source,
    required this.path,
    required this.fetcher,
  });

  @override
  Widget build(BuildContext context) {
    final player = useMemoized(() => Player());
    useEffect(() {
      return () => player.dispose();
    }, []);

    final resolve = useMemoized(() async {
      final url = await source;

      if (path?.endsWith("flac") == true) {
        debugPrint(url);
        player.open(Media(url));
        return SizedBox(
          child: FilledButton(
              onPressed: () {
                player.playOrPause();
              },
              child: const Text("Pause/Playing")),
        );
      }

      final rev = await fetcher();

      try {
        await decodeImageFromList(rev);
        return InteractiveViewer(child: Image.memory(rev));
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
