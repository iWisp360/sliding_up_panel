import 'package:material_ui/material_ui.dart';
import 'package:sliding_up_panel/src/state.dart';

class PanelController {
  PanelStateController? _panelState;

  void useState(PanelStateController controller) => _panelState = controller;

  PanelStateController get _currentState {
    assert(
      _panelState != null,
      "To use PanelController, you must first attach it to a SlidingUpPanel",
    );
    return _panelState!;
  }

  /// Closes the sliding panel to its collapsed state (i.e. to the  minHeight)
  Future<void> close() => _currentState.close();

  /// Opens the sliding panel fully
  /// (i.e. to the maxHeight)
  Future<void> open() => _currentState.open();

  /// Hides the sliding panel (i.e. is invisible)
  Future<void> hide() => _currentState.hide();

  /// Shows the sliding panel in its collapsed state
  /// (i.e. "un-hide" the sliding panel)
  Future<void> show() => _currentState.show();

  /// Animates the panel position to the value.
  /// The value must between 0.0 and 1.0
  /// where 0.0 is fully collapsed and 1.0 is completely open.
  /// (optional) duration specifies the time for the animation to complete
  /// (optional) curve specifies the easing behavior of the animation.
  Future<void> animatePanelToPosition(
    double value, {
    Duration? duration,
    Curve curve = Curves.linear,
  }) {
    assert(0.0 <= value && value <= 1.0);
    return _currentState.animatePanelToPosition(
      value,
      duration: duration,
      curve: curve,
    );
  }

  /// Animates the panel position to the snap point
  /// Requires that the SlidingUpPanel snapPoint property is not null
  /// (optional) duration specifies the time for the animation to complete
  /// (optional) curve specifies the easing behavior of the animation.
  Future<void> animatePanelToSnapPoint({
    Duration? duration,
    Curve curve = Curves.linear,
  }) {
    assert(
      _currentState.widget.snapPoint != null,
      "SlidingUpPanel snapPoint property must not be null",
    );
    return _currentState.animatePanelToSnapPoint(
      duration: duration,
      curve: curve,
    );
  }

  /// Sets the panel position (without animation).
  /// The value must between 0.0 and 1.0
  /// where 0.0 is fully collapsed and 1.0 is completely open.
  set panelPosition(double value) {
    assert(0.0 <= value && value <= 1.0);
    _currentState.panelPosition = value;
  }

  /// Gets the current panel position.
  /// Returns the % offset from collapsed state
  /// to the open state
  /// as a decimal between 0.0 and 1.0
  /// where 0.0 is fully collapsed and
  /// 1.0 is full open.
  double get panelPosition => _currentState.panelPosition;

  /// Returns whether or not the panel is
  /// currently animating.
  bool get isPanelAnimating => _currentState.isPanelAnimating;

  /// Returns whether or not the
  /// panel is open.
  bool get isPanelOpen => _currentState.isPanelOpen;

  /// Returns whether or not the
  /// panel is closed.
  bool get isPanelClosed => _currentState.isPanelClosed;

  /// Returns whether or not the
  /// panel is shown/hidden.
  bool get isPanelShown => _currentState.isPanelShown;
}
