import 'package:collection/collection.dart';
import 'package:deferred_helper/deferred_helper.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import 'deferred_content/deferred_route_page.dart'
    deferred as import_deferred_route_page;
import 'deferred_content/deferred_widget_page.dart'
    deferred as import_deferred_widget_page;

enum Dir {
  deferredWidgetPage("deferred/widget"),
  deferredRoute("deferred/route");

  final String path;

  const Dir(this.path);

  static Dir? byPath(String path) =>
      Dir.values.singleWhereOrNull((element) => element.path == path);

  static PageRoute<dynamic> routes(RouteSettings settings) {
    final uri = Uri.parse(settings.name!);
    switch (byPath(uri.path)) {
      case deferredWidgetPage:
        return PageRouteBuilder(
          settings: RouteSettings(name: deferredWidgetPage.path),
          pageBuilder: (context, animation, secondaryAnimation) {
            return Deferred.widget(import_deferred_widget_page.loadLibrary,
                () => import_deferred_widget_page.DeferredWidgetPage());
          },
        );
      case deferredRoute:
        // can load multiple libraries (ex: for parameter import file)
        return Deferred.route([import_deferred_route_page.loadLibrary],
            (context) {
          return PageTransition(
            settings: RouteSettings(name: deferredWidgetPage.path),
            child: import_deferred_route_page.DeferredRoutePage(),
            type: PageTransitionType.fade,
          );
        });
      default:
        throw "Route not found.";
    }
  }
}
