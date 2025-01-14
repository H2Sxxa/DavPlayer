import 'package:davplayer/routers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginDavPage extends HookWidget {
  const LoginDavPage({super.key});

  Widget wrapTextField(BuildContext context, Widget child) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          color: Theme.of(context).colorScheme.surfaceContainer),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final host = useTextEditingController();
    final user = useTextEditingController();
    final password = useTextEditingController();

    final loading = useState(true);

    useEffect(() {
      SharedPreferences.getInstance().then((preferences) async {
        host.text = preferences.getString("host") ?? "";
        user.text = preferences.getString("user") ?? "";
        password.text = preferences.getString("password") ?? "";
        loading.value = false;
      });

      return null;
    });

    if (loading.value) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          wrapTextField(
            context,
            TextField(
              controller: host,
              decoration: const InputDecoration(
                icon: Icon(Icons.public),
                border: InputBorder.none,
                hintText: "Host",
              ),
            ),
          ),
          wrapTextField(
            context,
            TextField(
              controller: user,
              decoration: const InputDecoration(
                icon: Icon(Icons.person),
                border: InputBorder.none,
                hintText: "User",
              ),
            ),
          ),
          wrapTextField(
            context,
            TextField(
              controller: password,
              decoration: const InputDecoration(
                icon: Icon(Icons.lock),
                border: InputBorder.none,
                hintText: "Password",
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: FilledButton(
              onPressed: () async {
                final preferences = await SharedPreferences.getInstance();
                preferences.setString("host", host.text);
                preferences.setString("user", user.text);
                preferences.setString("password", password.text);
                router.go("/webdav/client");
              },
              child: const Text("Login"),
            ),
          )
        ],
      ),
    );
  }
}
