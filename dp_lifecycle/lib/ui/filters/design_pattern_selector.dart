import 'package:dp_lifecycle/controllers/lifecycle_controller.dart';
import 'package:dp_lifecycle/struct/design_pattern.dart';
import 'package:dp_lifecycle/ui/pattern_panel/dp_chip.dart';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';

class DesignPatternSelector extends StatefulWidget {
  const DesignPatternSelector({Key? key}) : super(key: key);

  _DesignPatternSelector createState() => _DesignPatternSelector();
}

class _DesignPatternSelector extends State<DesignPatternSelector> {
  late LifecycleController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<LifecycleController>();
  }

  Widget chipWrapper(DesignPattern pattern) {
    return MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () {
            setState(() {
              if (controller.designPatterns.contains(pattern)) {
                controller.designPatterns.remove(pattern);
              } else {
                controller.designPatterns.add(pattern);
              }
              controller.onUpdatePattern(controller.designPatterns
                  .map((e) => e.parseString())
                  .join(','));
            });
          },
          child: DPChip(
            pattern,
            isSelected: controller.designPatterns.contains(pattern),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            chipWrapper(DesignPattern.bridge),
            const SizedBox(
              width: 10,
            ),
            chipWrapper(DesignPattern.composite),
            const SizedBox(
              width: 10,
            ),
            chipWrapper(DesignPattern.facade),
            const SizedBox(
              width: 10,
            ),
            chipWrapper(DesignPattern.proxy)
          ],
        ),
        const SizedBox(
          height: 3,
        ),
        Row(
          children: [
            chipWrapper(DesignPattern.flyweight),
            const SizedBox(
              width: 10,
            ),
            chipWrapper(DesignPattern.strategy),
            const SizedBox(
              width: 10,
            ),
            chipWrapper(DesignPattern.decorator),
            const SizedBox(
              width: 10,
            ),
            chipWrapper(DesignPattern.mediator)
          ],
        )
      ],
    );
  }
}
