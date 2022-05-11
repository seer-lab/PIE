import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';

class UIController extends GetxController {
  RxDouble _centre = 2.0.obs,
      _dpiSize = 600.0.obs,
      _codeSize = 0.8.obs,
      _infoPanelSize = 0.2.obs,
      _appbarSize = 60.0.obs;

  double getCentre(BuildContext context) {
    return MediaQuery.of(context).size.height / _centre.value;
  }

  double getCodeEditorWidth(BuildContext context) {
    return MediaQuery.of(context).size.width * _codeSize.value;
  }

  double getCodeEditorHeight(BuildContext context) {
    return MediaQuery.of(context).size.height / _centre.value -
        _appbarSize.value;
  }

  double getInfoPanelWidth(BuildContext context) {
    return MediaQuery.of(context).size.width * _infoPanelSize.value;
  }

  double getTimelineWidth(BuildContext context) {
    return MediaQuery.of(context).size.width - _dpiSize.value;
  }

  double getActiveTimelineWidth(BuildContext context) {
    return getTimelineWidth(context) - timelineMargins * 2;
  }

  double interpolateScreenPos(double position, BuildContext context) {
    return (MediaQuery.of(context).size.width -
                _dpiSize.value -
                timelineMargins * 2) *
            position -
        timelineMargins;
  }

  double get timelineControllerHeight => 60;
  double get appbarSize => _appbarSize.value;
  double get timelineMargins => 25.0;
}
