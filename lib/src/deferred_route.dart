// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'package:deferred_helper/src/service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'default_placeholder.dart';

typedef DeferredRouteBuilder = PageRouteBuilder Function(BuildContext context);

/// Wraps the child inside a deferred module loader.
///
/// The child is created and a single instance of the Widget is maintained in
/// state as long as closure to create widget stays the same.
///
class DeferredRoute {
  static PageRouteBuilder route(
    List<LibraryLoader> libraryLoader,
    DeferredRouteBuilder routeBuilder, {
    PageRouteBuilder? errorPage,
  }) {
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
      return DeferredLoadingPlaceholder(
        name: 'This page',
        onLoad: (context) async {
          try {
            await Future.wait(libraryLoader.map((e) => e()));
            if (context.mounted) {
              final completer = Completer();
              final result = await Navigator.of(context).pushReplacement(
                routeBuilder(context),
                result: completer.future,
              );
              completer.complete(result);
            }
          } catch (_) {
            if (kDebugMode) {
              rethrow;
            }
            if (errorPage != null && context.mounted) {
              await Navigator.of(context).pushReplacement(errorPage);
            }
          }
        },
      );
    });
  }
}
