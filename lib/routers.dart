import 'package:davplayer/views/pages/main_page.dart';
import 'package:davplayer/views/pages/webdav/client.dart';
import 'package:davplayer/views/pages/webdav/login.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(initialLocation: "/webdav/login", routes: [
  GoRoute(
    path: "/",
    builder: (context, state) {
      return const MainPage();
    },
  ),
  GoRoute(
    path: "/webdav/login",
    builder: (context, state) {
      return const LoginDavPage();
    },
  ),
  GoRoute(
    path: "/webdav/client",
    builder: (context, state) {
      return const WebDavClientPage();
    },
  ),
]);
