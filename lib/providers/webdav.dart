import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webdav_client/webdav_client.dart' as webdav;

class WebDavClientProvider extends ChangeNotifier {
  webdav.Client? _client;
  List<String> paths = ["/"];

  Future<List<webdav.File>> read() async {
    final result =
        await (await client()).readDir(paths.last.replaceAll("#", "%23"));
    return result;
  }

  Future<Uint8List> readFile(String path) async {
    final result = await (await client()).read(path);
    return Uint8List.fromList(result);
  }

  void pushLocation(String path) {
    paths.add(path);
    notifyListeners();
  }

  void goHome() {
    paths = ["/"];
    notifyListeners();
  }

  bool canPop() {
    if (paths.length > 1) {
      return true;
    }

    return false;
  }

  String? pop() {
    if (paths.length != 1) {
      final last = paths.removeLast();
      notifyListeners();

      return last;
    }

    return null;
  }

  Future<webdav.Client> client() async {
    if (_client != null) {
      return _client!;
    }
    final preferences = await SharedPreferences.getInstance();

    _client = webdav.newClient(
      preferences.getString("host") ?? "",
      user: preferences.getString("user") ?? "",
      password: preferences.getString("password") ?? "",
    );

    return _client!;
  }
}
