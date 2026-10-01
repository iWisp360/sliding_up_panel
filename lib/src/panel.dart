/*
Name: Akshath Jain
Date: 3/18/2019 - 4/2/2020
Purpose: Defines the sliding_up_panel widget
Copyright: © 2020, Akshath Jain. All rights reserved.
Licensing: More information can be found here: https://github.com/akshathjain/sliding_up_panel/blob/master/LICENSE
*/

import 'package:material_ui/material_ui.dart';
import 'package:sliding_up_panel/src/controller.dart';
import 'package:sliding_up_panel/src/entities.dart';
import 'package:sliding_up_panel/src/gesture_handler.dart';

import 'package:sliding_up_panel/src/state.dart';

class SlidingUpPanel extends StatefulWidget {
  /// The Widget that slides into view. When the
  /// panel is collapsed and if [collapsed] is null,
  /// then top portion of this Widget will be displayed;
  /// otherwise, [collapsed] will be displayed overtop
  /// of this Widget. If [panel] and [panelBuilder] are both non-null,
  /// [panel] will be used.
  final Widget? panel;

  /// WARNING: This feature is still in beta and is subject to change without
  /// notice. Stability is not gauranteed. Provides a [ScrollController] and
  /// [ScrollPhysics] to attach to a scrollable object in the panel that links
  /// the panel position with the scroll position. Useful for implementing an
  /// infinite scroll behavior. If [panel] and [panelBuilder] are both non-null,
  /// [panel] will be used.
  final Widget Function(ScrollController scrollController)? panelBuilder;

  /// The Widget displayed overtop the [panel] when collapsed.
  /// This fades out as the panel is opened.
  final Widget? collapsed;

  /// The Widget that lies underneath the sliding panel.
  /// This Widget automatically sizes itself
  /// to fill the screen.
  final Widget? body;

  /// Optional persistent widget that floats above the [panel] and attaches
  /// to the top of the [panel]. Content at the top of the panel will be covered
  /// by this widget. Add padding to the bottom of the `panel` to
  /// avoid coverage.
  final Widget? header;

  /// Optional persistent widget that floats above the [panel] and
  /// attaches to the bottom of the [panel]. Content at the bottom of the panel
  /// will be covered by this widget. Add padding to the bottom of the `panel`
  /// to avoid coverage.
  final Widget? footer;

  /// The height of the sliding panel when fully collapsed.
  final double minHeight;

  /// The height of the sliding panel when fully open.
  final double maxHeight;

  /// A point between [minHeight] and [maxHeight] that the panel snaps to
  /// while animating. A fast swipe on the panel will disregard this point
  /// and go directly to the open/close position. This value is represented as a
  /// percentage of the total animation distance ([maxHeight] - [minHeight]),
  /// so it must be between 0.0 and 1.0, exclusive.
  final double? snapPoint;

  /// A border to draw around the sliding panel sheet.
  final Border? border;

  /// If non-null, the corners of the sliding panel sheet
  /// are rounded by this [BorderRadiusGeometry].
  final BorderRadiusGeometry? borderRadius;

  /// A list of shadows cast behind the sliding panel sheet.
  final List<BoxShadow>? boxShadow;

  /// The color to fill the background of the sliding panel sheet.
  final Color color;

  /// The amount to inset the children of the sliding panel sheet.
  final EdgeInsetsGeometry? padding;

  /// Empty space surrounding the sliding panel sheet.
  final EdgeInsetsGeometry? margin;

  /// Set to false to not to render the sheet the [panel] sits upon.
  /// This means that only the [body], [collapsed], and the [panel]
  /// Widgets will be rendered.
  /// Set this to false if you want to achieve a floating effect or
  /// want more customization over how the sliding panel
  /// looks like.
  final bool renderPanelSheet;

  /// Set to false to disable the panel from snapping open or closed.
  final bool panelSnapping;

  /// If non-null, shows a darkening shadow over the [body] as the
  /// panel slides open.
  final bool backdropEnabled;

  /// If non-null, this can be used to control the state of the panel.
  final PanelController? controller;

  /// Shows a darkening shadow of this [Color] over the [body] as the
  /// panel slides open.
  final Color backdropColor;

  /// The opacity of the backdrop when the panel is fully open.
  /// This value can range from 0.0 to 1.0 where 0.0 is completely transparent
  /// and 1.0 is completely opaque.
  final double backdropOpacity;

  /// Flag that indicates whether or not tapping the
  /// backdrop closes the panel. Defaults to true.
  final bool backdropTapClosesPanel;

  /// If non-null, this callback
  /// is called as the panel slides around with the
  /// current position of the panel. The position is a double
  /// between 0.0 and 1.0 where 0.0 is fully collapsed and 1.0 is fully open.
  final void Function(double position)? onPanelSlide;

  /// If non-null, this callback is called when the
  /// panel is fully opened
  final VoidCallback? onPanelOpened;

  /// If non-null, this callback is called when the panel
  /// is fully collapsed.
  final VoidCallback? onPanelClosed;

  /// If non-null and true, the SlidingUpPanel exhibits a
  /// parallax effect as the panel slides up. Essentially,
  /// the body slides up as the panel slides up.
  final bool parallaxEnabled;

  /// Allows for specifying the extent of the parallax effect in terms
  /// of the percentage the panel has slid up/down. Recommended values are
  /// within 0.0 and 1.0 where 0.0 is no parallax and 1.0 mimics a
  /// one-to-one scrolling effect. Defaults to a 10% parallax.
  final double parallaxOffset;

  /// Allows toggling of the draggability of the SlidingUpPanel.
  /// Set this to false to prevent the user from being able to drag
  /// the panel up and down. Defaults to true.
  final bool isDraggable;

  /// Either SlideDirection.up or SlideDirection.down. Indicates which way
  /// the panel should slide. Defaults to up. If set to down, the panel attaches
  /// itself to the top of the screen and is fully opened when the user swipes
  /// down on the panel.
  final SlideDirection slideDirection;

  /// The default state of the panel; either PanelState.open or
  /// PanelState.closed. This value defaults to PanelState.closed which
  /// indicates that the panel is in the closed position and must be opened.
  /// PanelState.open indicates that by default the Panel is open and must be
  /// swiped closed by the user.
  final PanelState defaultPanelState;

  const SlidingUpPanel({
    super.key,
    this.panel,
    this.panelBuilder,
    this.body,
    this.collapsed,
    this.minHeight = 100.0,
    this.maxHeight = 500.0,
    this.snapPoint,
    this.border,
    this.borderRadius,
    this.boxShadow = const [
      .new(blurRadius: 8.0, color: .fromRGBO(0, 0, 0, 0.25)),
    ],
    this.color = Colors.white,
    this.padding,
    this.margin,
    this.renderPanelSheet = true,
    this.panelSnapping = true,
    this.controller,
    this.backdropEnabled = false,
    this.backdropColor = Colors.black,
    this.backdropOpacity = 0.5,
    this.backdropTapClosesPanel = true,
    this.onPanelSlide,
    this.onPanelOpened,
    this.onPanelClosed,
    this.parallaxEnabled = false,
    this.parallaxOffset = 0.1,
    this.isDraggable = true,
    this.slideDirection = .up,
    this.defaultPanelState = .closed,
    this.header,
    this.footer,
  }) : assert(panel != null || panelBuilder != null),
       assert(0 <= backdropOpacity && backdropOpacity <= 1.0),
       assert(snapPoint == null || 0 < snapPoint && snapPoint < 1.0);

  @override
  State<SlidingUpPanel> createState() => _SlidingUpPanelState();
}

class _SlidingUpPanelState extends State<SlidingUpPanel>
    with SingleTickerProviderStateMixin, PanelStateController {
  @override
  void initState() {
    super.initState();

    animationController =
        AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 300),

          // set the default panel state (i.e. set initial value of _ac)
          value: widget.defaultPanelState == .closed ? 0.0 : 1.0,
        )..addListener(() {
          widget.onPanelSlide?.call(animationController.value);

          switch (animationController.value) {
            case 1.0:
              widget.onPanelOpened?.call();

            case 0.0:
              widget.onPanelClosed?.call();
          }
        });

    // prevent the panel content from being scrolled only if the widget is
    // draggable and panel scrolling is enabled
    scrollController = ScrollController()
      ..addListener(() {
        if (widget.isDraggable && !scrollingEnabled) scrollController.jumpTo(0);
      });
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Stack(
      alignment: switch (widget.slideDirection) {
        .up => .bottomCenter,
        .down => .topCenter,
      },
      children: [
        //make the back widget take up the entire back side
        widget.body != null
            ? AnimatedBuilder(
                animation: animationController,
                builder: (context, child) => Positioned(
                  top: widget.parallaxEnabled ? getParallax() : 0.0,
                  child: child ?? const SizedBox(),
                ),
                child: SizedBox(
                  height: screenSize.height,
                  width: screenSize.width,
                  child: widget.body,
                ),
              )
            : const SizedBox(),

        //the backdrop to overlay on the body
        !widget.backdropEnabled
            ? const SizedBox()
            : GestureDetector(
                onVerticalDragEnd: widget.backdropTapClosesPanel
                    ? (details) {
                        // only trigger a close if the drag is
                        // towards panel close position
                        if ((widget.slideDirection == .up ? 1 : -1) *
                                details.velocity.pixelsPerSecond.dy >
                            0) {
                          close();
                        }
                      }
                    : null,
                onTap: widget.backdropTapClosesPanel ? close : null,
                child: AnimatedBuilder(
                  animation: animationController,
                  builder: (context, _) => Container(
                    height: screenSize.height,
                    width: screenSize.width,

                    //set color to null so that touch events pass through
                    //to the body when the panel is closed, otherwise,
                    //if a color exists, then touch events won't go through
                    color: animationController.value == 0.0
                        ? null
                        : widget.backdropColor.withValues(
                            alpha:
                                widget.backdropOpacity *
                                animationController.value,
                          ),
                  ),
                ),
              ),

        //the actual sliding part
        !isPanelVisible
            ? const SizedBox()
            : GestureHandler(
                parent: this,
                child: AnimatedBuilder(
                  animation: animationController,
                  builder: (context, child) => Container(
                    height:
                        animationController.value *
                            (widget.maxHeight - widget.minHeight) +
                        widget.minHeight,
                    margin: widget.margin,
                    padding: widget.padding,
                    decoration: widget.renderPanelSheet
                        ? BoxDecoration(
                            border: widget.border,
                            borderRadius: widget.borderRadius,
                            boxShadow: widget.boxShadow,
                            color: widget.color,
                          )
                        : null,
                    child: child,
                  ),
                  child: Stack(
                    children: [
                      //open panel
                      Positioned(
                        top: widget.slideDirection == .up ? 0.0 : null,
                        bottom: widget.slideDirection == .down ? 0.0 : null,
                        width:
                            screenSize.width -
                            (widget.margin != null
                                ? widget.margin!.horizontal
                                : 0) -
                            (widget.padding != null
                                ? widget.padding!.horizontal
                                : 0),
                        child: SizedBox(
                          height: widget.maxHeight,
                          child:
                              widget.panel ??
                              widget.panelBuilder?.call(scrollController),
                        ),
                      ),

                      // header
                      widget.header != null
                          ? Positioned(
                              top: widget.slideDirection == .up ? 0.0 : null,
                              bottom: widget.slideDirection == .down
                                  ? 0.0
                                  : null,
                              child: widget.header ?? const SizedBox(),
                            )
                          : const SizedBox(),

                      // footer
                      widget.footer != null
                          ? Positioned(
                              top: widget.slideDirection == .up ? null : 0.0,
                              bottom: widget.slideDirection == .down
                                  ? null
                                  : 0.0,
                              child: widget.footer ?? const SizedBox(),
                            )
                          : const SizedBox(),

                      // collapsed panel
                      Positioned(
                        top: widget.slideDirection == .up ? 0.0 : null,
                        bottom: widget.slideDirection == .down ? 0.0 : null,
                        width:
                            screenSize.width -
                            (widget.margin != null
                                ? widget.margin!.horizontal
                                : 0) -
                            (widget.padding != null
                                ? widget.padding!.horizontal
                                : 0),
                        child: SizedBox(
                          height: widget.minHeight,
                          child: widget.collapsed == null
                              ? const SizedBox()
                              : FadeTransition(
                                  opacity: Tween(
                                    begin: 1.0,
                                    end: 0.0,
                                  ).animate(animationController),

                                  // if the panel is open ignore pointers
                                  // (touch events) on the collapsed
                                  // child so that way touch events go through
                                  // to whatever is underneath
                                  child: IgnorePointer(
                                    ignoring: isPanelOpen,
                                    child: widget.collapsed,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ],
    );
  }
}
