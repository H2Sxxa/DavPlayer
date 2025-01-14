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
        return Column(children: [
          StreamBuilder(
            stream: player.stream.duration,
            builder: (context, snapshot) {
              final data = snapshot.data;
              if (data == null) {
                return const SizedBox.shrink();
              }

              return Text(data.toString());
            },
          ),
          StreamBuilder(
            stream: player.stream.position,
            builder: (context, snapshot) {
              final data = snapshot.data;
              if (data == null) {
                return const SizedBox.shrink();
              }

              return Text(data.toString());
            },
          ),
          StreamBuilder(
            stream: player.stream.subtitle,
            builder: (context, snapshot) {
              final data = snapshot.data;
              if (data == null) {
                return const SizedBox.shrink();
              }

              return Text(data.toString());
            },
          ),
          SizedBox(
            child: FilledButton(
                onPressed: () {
                  player.jump(0);
                },
                child: const Text("Replay")),
          ),
          SizedBox(
            child: FilledButton(
                onPressed: () {
                  player.playOrPause();
                },
                child: const Text("Pause/Play")),
          )
        ]);
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
      try {
        final text = String.fromCharCodes(rev);
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
