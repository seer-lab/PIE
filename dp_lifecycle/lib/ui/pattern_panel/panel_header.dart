import 'package:dp_lifecycle/controllers/lifecycle_controller.dart';
import 'package:dp_lifecycle/struct/design_pattern.dart';
import 'package:dp_lifecycle/ui/pattern_panel/dp_chip.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';

class PanelHeader extends StatefulWidget {
  _PanelHeader createState() => _PanelHeader();
}

class _PanelHeader extends State<PanelHeader> {
  late LifecycleController controller;
  Set<DesignPattern> designPatterns = Set();

  @override
  void initState() {
    controller = Get.find<LifecycleController>();
    designPatterns.add(DesignPattern.strategy);
  }

  Widget chipWrapper(DesignPattern pattern) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (designPatterns.contains(pattern)) {
            designPatterns.remove(pattern);
          } else {
            designPatterns.add(pattern);
          }
          controller.onUpdatePattern(
              designPatterns.map((e) => e.parseString()).join(','));
        });
      },
      child: DPChip(
        pattern,
        isSelected: designPatterns.contains(pattern),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<DesignPattern> patterns = [
      DesignPattern.bridge,
      DesignPattern.composite,
      DesignPattern.facade,
      DesignPattern.flyweight,
      DesignPattern.strategy,
      DesignPattern.decorator
    ];

    return Container(
        width: 550,
        child: Column(
          children: [
            Row(
              children: [
                chipWrapper(DesignPattern.bridge),
                chipWrapper(DesignPattern.composite),
                chipWrapper(DesignPattern.facade)
              ],
            ),
            Row(
              children: [
                chipWrapper(DesignPattern.flyweight),
                chipWrapper(DesignPattern.strategy),
                chipWrapper(DesignPattern.decorator),
              ],
            )
          ],
        ));
  }
}
