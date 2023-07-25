import 'package:example/directory.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "FlockUp",
      // Navigator.defaultRouteName,
      onGenerateInitialRoutes: (initialRouteName) {
        return [Dir.routes(RouteSettings(name: Dir.deferredRoute.path))];
      },
      onGenerateRoute: (settings) {
        return Dir.routes(settings);
      },
    );
  }
}
