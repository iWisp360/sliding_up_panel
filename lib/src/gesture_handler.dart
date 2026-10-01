import 'package:material_ui/material_ui.dart';
import 'package:sliding_up_panel/src/state.dart';

/// returns a gesture detector if panel is used
/// and a listener if panelBuilder is used.
/// this is because the listener is designed only for use with linking
/// the scrolling of panels and using it for panels that don't want to
/// linked scrolling yields odd results
class GestureHandler extends StatelessWidget {
  final PanelStateController parent;
  final Widget child;

  const GestureHandler({super.key, required this.parent, required this.child});

  @override
  Widget build(BuildContext context) => !parent.widget.isDraggable
      ? child
      : parent.widget.panel != null
      ? GestureDetector(
          onVerticalDragUpdate: (details) {
            if (!parent.mounted) return;
            parent.onGestureSlide(details.delta.dy);
          },
          onVerticalDragEnd: (details) {
            if (!parent.mounted) return;
            parent.onGestureEnd(details.velocity);
          },
          child: child,
        )
      : Listener(
          onPointerDown: (event) {
            if (!parent.mounted) return;
            parent.velocityTracker.addPosition(event.timeStamp, event.position);
          },
          onPointerMove: (event) {
            if (!parent.mounted) return;
            parent.velocityTracker.addPosition(
              event.timeStamp,
              event.position,
            ); // add current position for velocity tracking
            parent.onGestureSlide(event.delta.dy);
          },
          onPointerUp: (event) {
            if (!parent.mounted) return;
            parent.onGestureEnd(parent.velocityTracker.getVelocity());
          },
          child: child,
        );
}
