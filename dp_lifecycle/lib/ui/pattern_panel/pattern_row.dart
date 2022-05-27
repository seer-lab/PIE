import 'package:dp_lifecycle/controllers/timeline_controller.dart';
import 'package:flutter/material.dart';
import 'package:dp_lifecycle/struct/pattern_instance.dart';
import 'package:dp_lifecycle/ui/pattern_panel/pattern_card.dart';
import 'package:dp_lifecycle/ui/pattern_panel/pattern_timeline.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class PatternRow extends StatefulWidget {
  final PatternInstance pattern;
  const PatternRow(this.pattern, {Key? key}) : super(key: key);

  @override
  _PatternRow createState() => _PatternRow();
}

class _PatternRow extends State<PatternRow> {
  bool isOpen = false;
  late PatternInstance patternInstance;

  @override
  void initState() {
    super.initState();
    patternInstance = widget.pattern;
  }

  void onSelectRow(TimelineController fileController) async {
    fileController.updateSelectedPattern(null);
    patternInstance.fileHistory ??=
        await fileController.getFileHistory(patternInstance);
    setState(() {
      fileController.updateSelectedPattern(patternInstance);
    });
  }

  void onToggleDropdown() {
    setState(() {
      isOpen = !isOpen;
    });
  }

  bool _isSelected(TimelineController fileController) {
    if (fileController.selectedPattern == null) {
      return false;
    }
    return fileController.selectedPattern!.value == patternInstance;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TimelineController>(
        builder: (c) => Row(children: [
              PatternCard(patternInstance, isOpen, _isSelected(c),
                  onToggleDropdown, () => onSelectRow(c)),
              PatternTimeline(patternInstance, isOpen)
            ]));
  }
}
