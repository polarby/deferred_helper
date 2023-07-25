A simple flutter package to easily handle deferred content in your app.

Deferred content will split your build files into multiple ones, drastically reducing the size of
your app and lowers the start up time. Every well designed app should have deferred pages.
Note that some custom routers do already, have such functionality.

## Deferred loading in the widget tree

```dart

import 'deferred_content/deferred_widget.dart'
deferred as import_deferred_widget;


@override
Widget build(BuildContext context) {
  return Deferred.widget(import_deferred_widget.loadLibrary,
          () => import_deferred_widget.YourDeferredWidget());
}

```

## Deferred loading in the navigator

```dart
import 'deferred_content/page1.dart'
deferred as import_page1;

import 'deferred_content/page2.dart'
deferred as import_page2;


MaterialApp
(...onGenerateRoute: (settings) {
if (settings.name == "/"){
return PageRouteBuilder(
settings: RouteSettings(name: "/"),
pageBuilder: (context, animation, secondaryAnimation) {
// Only load the page when it is requested by the navigator
return Deferred.widget(import_page1.loadLibrary,
() => import_page1.Page1());
},
)
} else {
// can load multiple libraries (ex: deferred parameter class)
return Deferred.route([import_page2.loadLibrary],
(context) {
// you can use any page builder (such as transition)
return PageTransition(
// Here you can also define settings for the route, after successful loading
settings: RouteSettings(name: "deferred_dependent_route_settings"),
child: import_page2.Page2(),
type: PageTransitionType.fade,
);
})
}
},
);
```

# Known Issues

Currently Hero transitions are not supported. I am actively working on it to fix it soon.
