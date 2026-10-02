import 'dart:async';

import 'package:sliding_up_panel/src/entities.dart';
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

  void close() => _currentState.close();
  void open() => _currentState.open();

  Stream<double> get panelPosition => _currentState.panelPositionStream.stream;
  Stream<PanelState> get panelOpen => _currentState.panelStateStream.stream;
  Stream<bool> get panelVisible => _currentState.panelVisibleStream.stream;
}
