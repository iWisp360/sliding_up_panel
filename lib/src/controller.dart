import 'dart:async';

import 'package:sliding_up_panel/src/entities.dart';
import 'package:sliding_up_panel/src/state.dart';

class PanelController {
  PanelStateController? _panelState;

  final StreamController<double> _panelPositionStream = .broadcast();
  final StreamController<PanelState> _panelStateStream = .broadcast();

  void useState(PanelStateController controller) {
    if (_panelState == null || controller != _panelState) {
      _panelState = controller;

      _panelPositionStream.addStream(controller.panelPositionStream.stream);
      _panelStateStream.addStream(controller.panelStateStream.stream);
    }
  }

  void close() => _panelState?.close();
  void open() => _panelState?.open();

  Stream<double> get panelPosition => _panelPositionStream.stream;
  Stream<PanelState> get panelOpen => _panelStateStream.stream;

  void dispose() {
    _panelPositionStream.close();
    _panelStateStream.close();
    _panelState = null;
  }
}
