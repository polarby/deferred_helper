import 'package:deferred_helper/src/deferred_widget.dart';
import 'package:deferred_helper/src/service.dart';
import 'package:flutter/material.dart';

import 'deferred_route.dart';

class Deferred {
  static PageRouteBuilder route(
    List<LibraryLoader> libraryLoader,
    DeferredRouteBuilder routeBuilder, {
    PageRouteBuilder? errorPage,
  }) {
    return DeferredRoute.route(libraryLoader, routeBuilder,
        errorPage: errorPage);
  }


  static Widget widget(
    LibraryLoader libraryLoader,
    DeferredWidgetBuilder createWidget, {
    Widget? placeholder,
    DeferredValidator? validate,
    DeferredFallback? fallback,
  }) {
    return DeferredWidget(libraryLoader, createWidget,
        placeholder: placeholder, validate: validate, fallback: fallback);
  }
}
