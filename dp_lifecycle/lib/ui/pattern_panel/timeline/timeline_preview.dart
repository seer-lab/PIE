import 'package:dp_lifecycle/controllers/timeline_controller.dart';
import 'package:dp_lifecycle/controllers/ui_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';

class TimelinePreview extends StatefulWidget {
  const TimelinePreview({Key? key}) : super(key: key);

  @override
  _TimelinePreview createState() => _TimelinePreview();
}

enum PreviewSelection { leftHandle, rightHandle, center }

class _TimelinePreview extends State<TimelinePreview> {
  double position = 0;
  bool isDown = false;
  PreviewSelection selection = PreviewSelection.center;
  double range = -1;

  @override
  Widget build(BuildContext context) {
    TimelineController controller = Get.find<TimelineController>();
    double maxWidth = Get.find<UIController>().getTimelineWidth(context);
    if (range == -1) {
      range = maxWidth - 25;
    }
    return Container(
        height: 20,
        width: maxWidth,
        color: const Color.fromARGB(255, 180, 180, 180),
        child: Stack(
          children: [
            Positioned(
                left: position,
                child: MouseRegion(
                  cursor: isDown
                      ? SystemMouseCursors.grabbing
                      : SystemMouseCursors.grab,
                  child: Listener(
                      onPointerDown: (event) {
                        setState(() {
                          isDown = true;
                          selection = PreviewSelection.leftHandle;
                        });
                      },
                      onPointerUp: (event) {
                        setState(() {
                          isDown = false;
                        });
                      },
                      onPointerMove: (event) {
                        if (isDown) {
                          setState(() {
                            if (event.delta.dx > 0 && range < 30) {
                              return;
                            }
                            position += event.delta.dx;
                            if (position < 0) {
                              position = 0;
                            } else {
                              range -= event.delta.dx;
                            }
                            controller.updatePreviewStart(
                                controller.positionToCommit(
                                    (position) / (maxWidth - 50)));
                          });
                        }
                      },
                      child: Container(
                        width: 25,
                        height: 20,
                        color: Colors.blue.shade600,
                      )),
                )),
            Positioned(
                left: position + 25,
                child: MouseRegion(
                    cursor: isDown
                        ? SystemMouseCursors.grabbing
                        : SystemMouseCursors.grab,
                    child: Listener(
                        onPointerDown: (event) {
                          setState(() {
                            isDown = true;
                            selection = PreviewSelection.center;
                          });
                        },
                        onPointerUp: (event) {
                          setState(() {
                            isDown = false;
                          });
                        },
                        onPointerMove: (event) {
                          if (isDown) {
                            setState(() {
                              position += event.delta.dx;
                              if (position < 0) {
                                position = 0;
                              } else if (position > maxWidth - range - 25) {
                                position = maxWidth - range - 25;
                              }
                            });

                            controller.updatePreviewStart(
                                controller.positionToCommit(
                                    (position + 25) / (maxWidth - 50)));
                            controller.updatePreviewEnd(
                                controller.positionToCommit(
                                    (position + range + 25) / (maxWidth - 50)));
                          }
                        },
                        child: Container(
                          height: 20,
                          width: range,
                          color: Colors.amber,
                        )))),
            Positioned(
                left: position + range,
                child: MouseRegion(
                  cursor: isDown
                      ? SystemMouseCursors.grabbing
                      : SystemMouseCursors.grab,
                  child: Listener(
                      onPointerDown: (event) {
                        setState(() {
                          isDown = true;
                          selection = PreviewSelection.rightHandle;
                        });
                      },
                      onPointerUp: (event) {
                        setState(() {
                          isDown = false;
                        });
                      },
                      onPointerMove: (event) {
                        if (isDown) {
                          setState(() {
                            if (event.delta.dx < 0 && range < 30) {
                              return;
                            }
                            range += event.delta.dx;
                            if (position + range > maxWidth - 25) {
                              range = maxWidth - 25 - position;
                            }
                            controller.updatePreviewEnd(
                                controller.positionToCommit(
                                    (position + range) / (maxWidth - 25)));
                          });
                        }
                      },
                      child: Container(
                        width: 25,
                        height: 20,
                        color: Colors.blue.shade600,
                      )),
                )),
          ],
        ));
  }
}
