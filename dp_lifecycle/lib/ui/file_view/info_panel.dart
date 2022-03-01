import 'package:dp_lifecycle/controllers/timeline_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class InfoPanel extends StatefulWidget {
  _InfoPanel createState() => _InfoPanel();
}

class _InfoPanel extends State<InfoPanel> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<TimelineController>(
        builder: (c) => Container(width: 200, child: Text(c.getCommitInfo())));
  }
}
