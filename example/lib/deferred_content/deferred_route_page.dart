import 'package:deferred_helper/deferred_helper.dart';
import 'package:example/directory.dart';
import 'package:flutter/material.dart';

import 'deferred_in_page_widget.dart' deferred as import_deferred_widget;

class DeferredRoutePage extends StatelessWidget {
  const DeferredRoutePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Deferred Route'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Deferred.widget(import_deferred_widget.loadLibrary,
              () => import_deferred_widget.DeferredInPageWidget()),
          TextButton(
              onPressed: () =>
                  Navigator.pushReplacementNamed(context, Dir.deferredWidgetPage.path),
              child: const Text("To deferred widget page")),
        ],
      ),
    );
  }
}
