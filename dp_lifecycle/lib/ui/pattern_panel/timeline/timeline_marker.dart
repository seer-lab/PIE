import 'package:dp_lifecycle/controllers/timeline_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class TimelineMarker extends GetView<TimelineController> {
  final int maxMarkers = 5;

  int interpolateCommitNumber(double position) {
    return controller.previewStart +
        ((controller.previewEnd - controller.previewStart) * position).round();
  }

  double interpolateScreenPos(double position, BuildContext context) {
    return (MediaQuery.of(context).size.width - 650) * position - 25;
  }

  Widget _marker(int commitNumber) {
    return Container(
        width: 50,
        child: Column(
          children: [
            Text(
              commitNumber.toString(),
              style: const TextStyle(color: Colors.white, fontSize: 10),
            ),
            const SizedBox(
              height: 2,
            ),
            Container(
              color: Colors.white,
              width: 2,
              height: 10,
            ),
          ],
        ));
  }

  List<Widget> _generateMarkers(BuildContext context) {
    List<double> markerPositions = [0, 0.25, 0.5, 0.75, 1];
    return markerPositions
        .map((e) => Positioned(
              child: _marker(interpolateCommitNumber(e)),
              left: interpolateScreenPos(e, context) + 25,
              top: 0,
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: MediaQuery.of(context).size.width - 600,
      color: const Color.fromARGB(255, 133, 133, 133),
      child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Positioned(
                child: Container(
                  height: 30,
                  width: MediaQuery.of(context).size.width - 650,
                  color: const Color.fromARGB(255, 71, 71, 71),
                ),
                top: 0,
                left: 25)
          ]..addAll(_generateMarkers(context))),
    );
  }
}
