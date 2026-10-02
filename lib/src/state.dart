import 'dart:async';

import 'package:material_ui/material_ui.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:sliding_up_panel/src/entities.dart';

mixin PanelStateController on State<SlidingUpPanel> {
  Duration get animationDuration => const Duration(milliseconds: 300);

  late final StreamController<double> panelPositionStream;
  late final StreamController<PanelState> panelStateStream;
  late final StreamController<bool> panelVisibleStream;
  late final AnimationController animationController;

  double panelPosition = 0;
  PanelState panelState = .closed;

  double get maxMinHeightDiff => widget.maxHeight - widget.minHeight;

  void close() => animationController.fling(velocity: -1);
  void open() => animationController.fling();

  Stream<double> parallax() async* {
    await for (final position in panelPositionStream.stream) {
      yield (widget.slideDirection == .up ? -position : position) *
          maxMinHeightDiff *
          widget.parallaxOffset;
    }
  }
}
