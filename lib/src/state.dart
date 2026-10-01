import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/physics.dart';
import 'package:material_ui/material_ui.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

mixin PanelStateController on State<SlidingUpPanel> {
  late final AnimationController animationController;
  late final ScrollController scrollController;

  bool scrollingEnabled = false;
  final VelocityTracker velocityTracker = .withKind(PointerDeviceKind.touch);

  bool isPanelVisible = true;

  //close the panel
  Future<void> close() {
    if (scrollingEnabled) {
      setState(() {
        scrollController.jumpTo(0);
        scrollingEnabled = false;
      });
    }
    return animationController.fling(velocity: -1.0);
  }

  //open the panel
  Future<void> open() => animationController.fling(velocity: 1.0);

  //hide the panel (completely offscreen)
  Future<void> hide() => animationController
      .fling(velocity: -1.0)
      .then((x) => setState(() => isPanelVisible = false));

  //show the panel (in collapsed mode)
  Future<void> show() => animationController
      .fling(velocity: -1.0)
      .then((x) => setState(() => isPanelVisible = true));

  //animate the panel position to value - must
  //be between 0.0 and 1.0
  Future<void> animatePanelToPosition(
    double value, {
    Duration? duration,
    Curve curve = Curves.linear,
  }) {
    assert(0.0 <= value && value <= 1.0);
    return animationController.animateTo(
      value,
      duration: duration,
      curve: curve,
    );
  }

  //animate the panel position to the snap point
  //REQUIRES that widget.snapPoint != null
  Future<void> animatePanelToSnapPoint({
    Duration? duration,
    Curve curve = Curves.linear,
  }) {
    assert(widget.snapPoint != null);
    return animationController.animateTo(
      widget.snapPoint!,
      duration: duration,
      curve: curve,
    );
  }

  //set the panel position to value - must
  //be between 0.0 and 1.0
  set panelPosition(double value) {
    assert(0.0 <= value && value <= 1.0);
    animationController.value = value;
  }

  //get the current panel position
  //returns the % offset from collapsed state
  //as a decimal between 0.0 and 1.0
  double get panelPosition => animationController.value;

  //returns whether or not
  //the panel is still animating
  bool get isPanelAnimating => animationController.isAnimating;

  //returns whether or not the
  //panel is open
  //
  // allow 0.01 deviation to match
  // AnimationController's _kFlingTolerance
  bool get isPanelOpen => animationController.value >= 0.99;

  //returns whether or not the
  //panel is closed
  //
  // allow 0.01 deviation to match
  // AnimationController's _kFlingTolerance
  bool get isPanelClosed => animationController.value <= 0.01;

  //returns whether or not the
  //panel is shown/hidden
  bool get isPanelShown => isPanelVisible;

  double getParallax() => widget.slideDirection == .up
      ? -animationController.value *
            (widget.maxHeight - widget.minHeight) *
            widget.parallaxOffset
      : animationController.value *
            (widget.maxHeight - widget.minHeight) *
            widget.parallaxOffset;

  // handles the sliding gesture
  void onGestureSlide(double dy) {
    // only slide the panel if scrolling is not enabled
    if (!scrollingEnabled) {
      if (widget.slideDirection == .up) {
        animationController.value -= dy / (widget.maxHeight - widget.minHeight);
      } else {
        animationController.value += dy / (widget.maxHeight - widget.minHeight);
      }
    }

    // if the panel is open and the user hasn't scrolled, we need to determine
    // whether to enable scrolling if the user swipes up, or disable closing and
    // begin to close the panel if the user swipes down
    if (isPanelOpen &&
        scrollController.hasClients &&
        scrollController.offset <= 0) {
      setState(() => scrollingEnabled = dy < 0);
    }
  }

  // handles when user stops sliding
  void onGestureEnd(Velocity v) {
    double minFlingVelocity = 365.0;
    double kSnap = 8;

    //let the current animation finish before starting a new one
    if (animationController.isAnimating) return;

    // if scrolling is allowed and the panel is open, we don't want to close
    // the panel if they swipe up on the scrollable
    if (isPanelOpen && scrollingEnabled) return;

    //check if the velocity is sufficient to constitute fling to end
    double visualVelocity =
        -v.pixelsPerSecond.dy / (widget.maxHeight - widget.minHeight);

    // reverse visual velocity to account for slide direction
    if (widget.slideDirection == .down) {
      visualVelocity = -visualVelocity;
    }

    // get minimum distances to figure out where the panel is at
    double d2Close = animationController.value;
    double d2Open = 1 - animationController.value;
    double d2Snap = ((widget.snapPoint ?? 3) - animationController.value)
        .abs(); // large value if null results in not every being the min
    double minDistance = min(d2Close, min(d2Snap, d2Open));

    // check if velocity is sufficient for a fling
    if (v.pixelsPerSecond.dy.abs() >= minFlingVelocity) {
      // snapPoint exists
      if (widget.panelSnapping && widget.snapPoint != null) {
        if (v.pixelsPerSecond.dy.abs() >= kSnap * minFlingVelocity ||
            minDistance == d2Snap) {
          animationController.fling(velocity: visualVelocity);
        } else {
          flingPanelToPosition(widget.snapPoint!, visualVelocity);
        }

        // no snap point exists
      } else if (widget.panelSnapping) {
        animationController.fling(velocity: visualVelocity);

        // panel snapping disabled
      } else {
        animationController.animateTo(
          animationController.value + visualVelocity * 0.16,
          duration: const Duration(milliseconds: 410),
          curve: Curves.decelerate,
        );
      }

      return;
    }

    // check if the controller is already halfway there
    if (widget.panelSnapping) {
      if (minDistance == d2Close) {
        close();
      } else if (minDistance == d2Snap) {
        flingPanelToPosition(widget.snapPoint!, visualVelocity);
      } else {
        open();
      }
    }
  }

  void flingPanelToPosition(double targetPos, double velocity) {
    final simulation = SpringSimulation(
      SpringDescription.withDampingRatio(
        mass: 1.0,
        stiffness: 500.0,
        ratio: 1.0,
      ),
      animationController.value,
      targetPos,
      velocity,
    );

    animationController.animateWith(simulation);
  }
}
