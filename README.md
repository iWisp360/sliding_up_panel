# sliding_up_panel

A bottom sheet that can be clicked on demand for extra content.

## Installing

Execute this command

```sh
flutter pub add sliding_up_panel
```

## Simple Usage

Here is an example to use this widget:

```dart
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text("SlidingUpPanelExample"),
    ),
    body: SlidingUpPanel(
      panel: Center(
        child: Text("This is the sliding Widget"),
      ),
      body: Center(
        child: Text("This is the Widget behind the sliding panel"),
      ),
    ),
  );
}
```

### Controlling the panel

A `PanelController` is exposed to interact with the panel from other parts of
your app.

```dart
class Example extends StatefulWidget {
  const Example({super.key});

  @override
  State<Example> createState() => _ExampleState();
}

class _ExampleState extends State<Example> {
  // Create a controller to interact with the panel
  late final PanelController controller;

  @override
  void initState() {
    super.initState();
    controller = PanelController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlidingUpPanel(
      // Remember to attach the controller to your panel, 
      // otherwise it will throw exceptions
      controller: controller,
      body: const Placeholder(),
      panel: const Placeholder(),
    );
  }
}
```
