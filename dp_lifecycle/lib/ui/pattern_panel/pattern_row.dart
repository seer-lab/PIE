import 'package:dp_lifecycle/controllers/timeline_controller.dart';
import 'package:flutter/material.dart';
import 'package:dp_lifecycle/struct/pattern_instance.dart';
import 'package:dp_lifecycle/ui/pattern_panel/pattern_card.dart';
import 'package:dp_lifecycle/ui/pattern_panel/pattern_timeline.dart';
import 'package:get/instance_manager.dart';

class PatternRow extends StatefulWidget {
  final PatternInstance pattern;
  const PatternRow(this.pattern, {Key? key}) : super(key: key);
  _PatternRow createState() => _PatternRow();
}

class _PatternRow extends State<PatternRow> {
  bool isOpen = false;
  late PatternInstance patternInstance;
  TimelineController fileController = Get.find<TimelineController>();
  @override
  void initState() {
    patternInstance = widget.pattern;
  }

  void onSelectRow() async {
    if (fileController.isPerformingGitOperation) {
      return;
    }
    fileController.updateSelectedPattern(null);
    patternInstance.fileHistory ??=
        await fileController.getFileHistory(patternInstance);
    fileController.updateSelectedPattern(patternInstance);
  }

  void onToggleDropdown() {
    setState(() {
      isOpen = !isOpen;
    });
  }

  bool _isSelected() {
    if (fileController.selectedPattern == null) {
      return false;
    }
    return fileController.selectedPattern!.value == patternInstance;
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      PatternCard(patternInstance, isOpen, _isSelected(), onToggleDropdown,
          onSelectRow),
      PatternTimeline(patternInstance, isOpen)
    ]);
  }
}
