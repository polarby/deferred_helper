// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'package:deferred_helper/src/service.dart';
import 'package:flutter/material.dart';

typedef DeferredWidgetBuilder = Widget Function();

typedef DeferredValidator = FutureOr<void> Function();

typedef DeferredFallback = void Function(BuildContext context);

/// Wraps the child inside a deferred module loader.
///
/// The child is created and a single instance of the Widget is maintained in
/// state as long as closure to create widget stays the same.
///
class DeferredWidget extends StatefulWidget {
  DeferredWidget(
    this.libraryLoader,
    this.createWidget, {
    super.key,
    Widget? placeholder,
    this.validate,
    this.fallback,
  }) : placeholder = placeholder ?? Container();

  /// Function called after successful load of the library and before launching
  /// the actual widget. If false the [fallback] is triggered.
  /// throw error if validation fails.
  final DeferredValidator? validate;

  /// Function called if [validate] throws error.
  final DeferredFallback? fallback;

  final LibraryLoader libraryLoader;
  final DeferredWidgetBuilder createWidget;
  final Widget placeholder;
  static final Map<LibraryLoader, Future<void>> _moduleLoaders = {};
  static final Set<LibraryLoader> _loadedModules = {};

  static Future<void> preload(LibraryLoader loader) {
    if (!_moduleLoaders.containsKey(loader)) {
      _moduleLoaders[loader] = loader().then((dynamic _) {
        _loadedModules.add(loader);
      });
    }
    return _moduleLoaders[loader]!;
  }

  @override
  State<DeferredWidget> createState() => _DeferredWidgetState();
}

class _DeferredWidgetState extends State<DeferredWidget> {
  _DeferredWidgetState();

  Widget? _loadedChild;
  DeferredWidgetBuilder? _loadedCreator;

  @override
  void initState() {
    /// If module was already loaded immediately create widget instead of
    /// waiting for future or zone turn.
    if (DeferredWidget._loadedModules.contains(widget.libraryLoader)) {
      _onLibraryLoaded();
    } else {
      DeferredWidget.preload(widget.libraryLoader)
          .then((dynamic _) => _onLibraryLoaded());
    }
    super.initState();
  }

  Future<void> _onLibraryLoaded() async {
    try {
      await widget.validate?.call();
      setState(() {
        _loadedCreator = widget.createWidget;
        _loadedChild = _loadedCreator!();
      });
    } catch (_) {
      widget.fallback?.call(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    /// If closure to create widget changed, create new instance, otherwise
    /// treat as const Widget.
    if (_loadedCreator != widget.createWidget && _loadedCreator != null) {
      _loadedCreator = widget.createWidget;
      _loadedChild = _loadedCreator!();
    }
    return _loadedChild ?? widget.placeholder;
  }
}
