import 'package:dp_lifecycle/controllers/timeline_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class TimelinePreview extends GetView<TimelineController> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 20,
        width: MediaQuery.of(context).size.width - 600,
        color: const Color.fromARGB(255, 180, 180, 180),
        child: Stack(
          children: [],
        ));
  }
}
