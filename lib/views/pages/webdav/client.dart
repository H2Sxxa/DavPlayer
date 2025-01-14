import 'dart:math';
import 'dart:ui';

import 'package:davplayer/providers/webdav.dart';
import 'package:davplayer/views/pages/webdav/media.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';

class WebDavClientPage extends HookWidget {
  const WebDavClientPage({super.key});
  static String getFileSizeString({required int bytes, int decimals = 0}) {
    if (bytes == 0) {
      return "";
    }
    const suffixes = ["B", "KB", "MB", "GB", "TB"];
    var i = (log(bytes) / log(1024)).floor();
    return "${(bytes / pow(1024, i)).toStringAsFixed(decimals)} ${suffixes[i]}";
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WebDavClientProvider>(context);
    final result = useMemoized(() async {
      final data = await provider.read();
      data.sort((a, b) => a.name.toString().compareTo(b.name.toString()));
      return data;
    }, [provider.paths.last]);
    final future = useFuture(result);
    final data = future.data;

    return AnimatedSwitcher(
      duration: Durations.medium4,
      child: Scaffold(
        drawer: Drawer(
          child: ListView(
            children: [
              ListTile(
                title: const Text("Home"),
                onTap: () => provider.goHome(),
              )
            ],
          ),
        ),
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: const Text("DavPlayer"),
          flexibleSpace: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 7, sigmaY: 7),
            ),
          ),
        ),
        body: data == null || future.connectionState == ConnectionState.waiting
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemBuilder: (context, index) {
                  if (provider.canPop()) {
                    index -= 1;
                  }
                  if (index == -1) {
                    return ListTile(
                      leading: const Icon(Icons.arrow_back),
                      onTap: () {
                        provider.pop();
                      },
                    );
                  }

                  if (index < data.length) {
                    final entry = data[index];

                    return ListTile(
                      leading: Icon(
                          entry.isDir == true ? Icons.folder : Icons.file_open),
                      title: Text(entry.name.toString()),
                      trailing: Text(getFileSizeString(bytes: entry.size ?? 0)),
                      onTap: () {
                        if (entry.path != null) {
                          if (entry.isDir == true) {
                            provider.pushLocation(entry.path!);
                          } else {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) {
                                return MultiMediaWidget(
                                  data: provider.readFile(entry.path!),
                                );
                              },
                            ));
                          }
                        }
                      },
                    );
                  }
                  return null;
                },
              ),
      ),
    );
  }
}
