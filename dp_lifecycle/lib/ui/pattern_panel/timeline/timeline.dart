import 'package:dp_lifecycle/controllers/timeline_controller.dart';
import 'package:dp_lifecycle/ui/pattern_panel/timeline/timeline_marker.dart';
import 'package:dp_lifecycle/ui/pattern_panel/timeline/timeline_preview.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:flutter/material.dart';

class Timeline extends GetView<TimelineController> {
  const Timeline({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 600,
      height: 100,
      child: Stack(
        children: const [
          Positioned(
            child: TimelineMarker(),
            bottom: 0,
            left: 0,
          ),
          Positioned(
            child: TimelinePreview(),
            left: 0,
            bottom: 40,
          )
        ],
      ),
    );
  }
}
