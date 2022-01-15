import 'package:dp_lifecycle/controllers/timeline_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';

class TimelineMarker extends StatefulWidget {
  _TimelineMarker createState() => _TimelineMarker();
}

class _TimelineMarker extends State<TimelineMarker> {
  int maxMarkers = 20;
  double interpolateScreenPos(double position, BuildContext context) {
    return (MediaQuery.of(context).size.width - 650) * position - 25;
  }

  Widget _previewMarker() {
    return Container(
      child: Column(children: [
        Container(
          height: 20,
          width: 20,
          decoration: BoxDecoration(
              color: Colors.red, borderRadius: BorderRadius.circular(8.0)),
        ),
        Container(
          height: 30,
          width: 2,
          color: Colors.red,
        )
      ]),
    );
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

  List<Widget> _generateMarkers(BuildContext context, TimelineController c) {
    maxMarkers = 20 *
        (c.commits.length / (c.previewEnd.value - c.previewStart.value))
            .round();
    if (maxMarkers <= 0) maxMarkers = 20;
    List<int> markerPositions = List<int>.generate(maxMarkers + 1,
        (index) => index * (c.commits.length / maxMarkers).round());
    return markerPositions
        .map((e) => Positioned(
              child: _marker(e),
              left: interpolateScreenPos(c.normalizedPosition(e), context) + 25,
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
        child: GetBuilder<TimelineController>(
          builder: ((c) => Stack(
              alignment: Alignment.topCenter,
              children: [
                Positioned(
                    child: Listener(
                      child: Container(
                        height: 30,
                        width: MediaQuery.of(context).size.width - 650,
                        color: const Color.fromARGB(255, 71, 71, 71),
                      ),
                      onPointerUp: (e) {
                        double percent = e.localPosition.dx /
                            (MediaQuery.of(context).size.width - 650);
                        int commit =
                            ((c.previewEnd.value - c.previewStart.value) *
                                        percent)
                                    .round() +
                                c.previewStart.value;
                        print(commit);
                        c.updatePreviewMarker(commit);
                      },
                    ),
                    top: 0,
                    left: 25),
                Positioned(
                  child: _previewMarker(),
                  left: interpolateScreenPos(
                          c.normalizedPosition(c.previewMarker.value),
                          context) +
                      40,
                )
              ]..addAll(_generateMarkers(context, c)))),
        ));
  }
}
