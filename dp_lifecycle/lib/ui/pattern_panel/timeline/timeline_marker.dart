import 'package:dp_lifecycle/controllers/timeline_controller.dart';
import 'package:dp_lifecycle/controllers/ui_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';

class TimelineMarker extends StatefulWidget {
  const TimelineMarker({Key? key}) : super(key: key);

  @override
  _TimelineMarker createState() => _TimelineMarker();
}

class _TimelineMarker extends State<TimelineMarker> {
  final UIController uiController = Get.find<UIController>();
  int maxMarkers = 20;
  bool previewMarkerDown = false;
  double previewPosition = 0;

  Widget _previewMarker(
      double height, BuildContext context, TimelineController c) {
    if (c.previewMarker.value > c.previewEnd.value ||
        c.previewMarker.value < c.previewStart.value) {
      return const SizedBox();
    }
    return MouseRegion(
        cursor: previewMarkerDown
            ? SystemMouseCursors.grabbing
            : SystemMouseCursors.grab,
        child: Listener(
          onPointerDown: (event) {
            setState(() {
              previewMarkerDown = true;
            });
          },
          onPointerUp: (event) {
            setState(() {
              previewMarkerDown = false;
            });
          },
          onPointerMove: (e) {
            double percent =
                e.delta.dx / uiController.getActiveTimelineWidth(context);
            int commit = ((c.previewEnd.value - c.previewStart.value) * percent)
                    .round() +
                c.previewMarker.value;
            if (commit < c.previewStart.value) {
              commit = c.previewStart.value;
            } else if (commit > c.previewEnd.value) {
              commit = c.previewEnd.value;
            }
            c.updatePreviewMarker(commit);
          },
          child: Column(children: [
            Container(
              height: 20,
              width: 20,
              decoration: BoxDecoration(
                  color: Colors.red, borderRadius: BorderRadius.circular(8.0)),
            ),
            Container(
              height: height - 20,
              width: 2,
              color: Colors.red,
            )
          ]),
        ));
  }

  Widget _marker(int commitNumber) {
    return SizedBox(
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
    markerPositions.add(c.previewStart.value);
    markerPositions.add(c.previewEnd.value);
    markerPositions = markerPositions
        .where((element) =>
            element <= c.previewEnd.value && element >= c.previewStart.value)
        .toList();
    return markerPositions
        .map((e) => Positioned(
              child: _marker(e),
              left: uiController.interpolateScreenPos(
                      c.normalizedPosition(e), context) +
                  25,
              top: 0,
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 40,
        width: uiController.getTimelineWidth(context),
        color: const Color.fromARGB(255, 133, 133, 133),
        child: GetBuilder<TimelineController>(
          builder: ((c) => Stack(
                  alignment: Alignment.topCenter,
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                        child: Listener(
                          child: Container(
                            height: 30,
                            width: uiController.getActiveTimelineWidth(context),
                            color: const Color.fromARGB(255, 71, 71, 71),
                          ),
                          onPointerUp: (e) {
                            double percent = e.localPosition.dx /
                                uiController.getActiveTimelineWidth(context);
                            int commit =
                                ((c.previewEnd.value - c.previewStart.value) *
                                            percent)
                                        .round() +
                                    c.previewStart.value;
                            c.updatePreviewMarker(commit);
                          },
                        ),
                        top: 0,
                        left: 25),
                    Positioned(
                      child: _previewMarker(
                          uiController.getCentre(context) -
                              uiController.timelineControllerHeight,
                          context,
                          c),
                      left: uiController.interpolateScreenPos(
                              c.normalizedPosition(c.previewMarker.value),
                              context) +
                          40,
                      height: uiController.getCentre(context) -
                          uiController.timelineControllerHeight,
                    ),
                    ..._generateMarkers(context, c)
                  ])),
        ));
  }
}
