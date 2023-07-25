import 'package:flutter/material.dart';

/// Displays a progress indicator and text description explaining that
/// the widget is a deferred component and is currently being installed.
class DeferredLoadingPlaceholder extends StatelessWidget {
  final void Function(BuildContext context)? onLoad;
  final Duration displayDelay;

  const DeferredLoadingPlaceholder({
    super.key,
    this.name = 'This Element',
    this.onLoad,
    this.displayDelay = const Duration(milliseconds: 800),
  });

  final String name;

  @override
  Widget build(BuildContext context) {
    if (onLoad != null) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        onLoad!(context);
      });
    }
    return FutureBuilder(
        future: Future.delayed(displayDelay),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // display nothing for the first few milliseconds
            return Container();
          }
          return Center(
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.grey[300]!.withOpacity(0.9),
                  border: Border.all(
                    width: 5,
                    color: Colors.grey[400]!.withOpacity(0.9),
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(20))),
              padding: const EdgeInsets.all(20),
              width: 250,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('$name is installing.',
                      style: Theme.of(context).textTheme.headlineMedium),
                  Container(height: 10),
                  Text(
                      '$name is a deferred component which is downloaded and installed at runtime.',
                      style: Theme.of(context).textTheme.bodyLarge),
                  Container(height: 20),
                  const Center(child: CircularProgressIndicator()),
                ],
              ),
            ),
          );
        });
  }
}
