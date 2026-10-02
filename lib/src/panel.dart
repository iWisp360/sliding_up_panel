import 'package:material_ui/material_ui.dart';
import 'package:sliding_up_panel/src/controller.dart';
import 'package:sliding_up_panel/src/entities.dart';
import 'package:sliding_up_panel/src/state.dart';

class SlidingUpPanel extends StatefulWidget {
  final Widget? panel;
  final Widget? body;

  /// The height of the sliding panel when fully collapsed.
  final double minHeight;

  /// The height of the sliding panel when fully open.
  final double maxHeight;

  final Border? border;
  final BorderRadiusGeometry? borderRadius;
  final List<BoxShadow>? boxShadow;
  final Color? color;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  final PanelController? controller;

  final Color? backdropColor;
  final double backdropOpacity;
  final bool backdropTapClosesPanel;

  final bool parallaxEnabled;
  final double parallaxOffset;

  final SlideDirection slideDirection;
  final PanelState defaultPanelState;

  const SlidingUpPanel({
    super.key,
    this.panel,
    this.body,
    this.minHeight = 100,
    this.maxHeight = 500,
    this.border,
    this.borderRadius,
    this.boxShadow = const [.new(blurRadius: 8, color: .fromARGB(63, 0, 0, 0))],
    this.color,
    this.padding,
    this.margin,
    this.controller,
    this.backdropColor,
    this.backdropOpacity = .5,
    this.backdropTapClosesPanel = true,
    this.parallaxEnabled = false,
    this.parallaxOffset = .1,
    this.slideDirection = .up,
    this.defaultPanelState = .closed,
  }) : assert(panel != null),
       assert(0 <= backdropOpacity && backdropOpacity <= 1);

  @override
  State<SlidingUpPanel> createState() => _SlidingUpPanelState();
}

class _SlidingUpPanelState extends State<SlidingUpPanel>
    with PanelStateController, SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();

    animationController =
        AnimationController(
          vsync: this,
          duration: animationDuration,
          value: switch (widget.defaultPanelState) {
            .open => 1,
            .closed => 0,
          },
        )..addListener(() {
          panelPositionStream.add(animationController.value);

          switch (animationController.value) {
            case 0:
              panelStateStream.add(.closed);

            case 1:
              panelStateStream.add(.open);
          }
        });

    panelPositionStream = .broadcast()
      ..add(animationController.value)
      ..stream.listen((pos) => panelPosition = pos);

    panelStateStream = .broadcast()
      ..add(widget.defaultPanelState)
      ..stream.listen((state) => panelState = state);
  }

  @override
  void dispose() {
    animationController.dispose();
    panelPositionStream.close();
    panelStateStream.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: switch (widget.slideDirection) {
        .up => .bottomCenter,
        .down => .topCenter,
      },
      children: [
        StreamBuilder(
          stream: parallax(),
          builder: (context, parallax) => Positioned.fill(
            top: widget.parallaxEnabled ? parallax.data ?? 0 : 0,
            child: widget.body ?? const SizedBox(),
          ),
        ),
        Positioned(
          right: 0,
          left: 0,
          top: widget.slideDirection == .down ? 0 : null,
          bottom: widget.slideDirection == .up ? 0 : null,
          child: GestureDetector(
            onTap: () => switch (panelState) {
              .open => close(),
              .closed => open(),
            },
            child: StreamBuilder(
              stream: panelPositionStream.stream,
              builder: (context, position) {
                final currentPosition = position.data ?? widget.minHeight;

                return Container(
                  height: currentPosition * maxMinHeightDiff - widget.minHeight,
                  margin: widget.margin,
                  padding: widget.padding,
                  decoration: BoxDecoration(
                    color: widget.color ?? ColorScheme.of(context).surface,
                    borderRadius: widget.borderRadius,
                    border: widget.border,
                    boxShadow: widget.boxShadow,
                  ),
                  constraints: .new(
                    maxHeight: widget.maxHeight,
                    minHeight: widget.minHeight,
                  ),
                  child: widget.panel,
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
