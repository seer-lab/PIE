import 'package:dp_lifecycle/controllers/lifecycle_controller.dart';
import 'package:dp_lifecycle/struct/design_pattern.dart';
import 'package:dp_lifecycle/ui/pattern_panel/dp_chip.dart';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';

class PanelHeader extends StatefulWidget {
  const PanelHeader({Key? key}) : super(key: key);

  @override
  _PanelHeader createState() => _PanelHeader();
}

class _PanelHeader extends State<PanelHeader> {
  late LifecycleController controller;
  Set<DesignPattern> designPatterns = <DesignPattern>{};

  @override
  void initState() {
    super.initState();
    controller = Get.find<LifecycleController>();
    designPatterns.add(DesignPattern.strategy);
  }

  Widget chipWrapper(DesignPattern pattern) {
    return MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
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
        ));
  }

  // @override
  // Widget build(BuildContext context) {
  //   return const SizedBox(
  //     width: 550,
  //     child: Text(
  //       'Design Pattern Instances',
  //       style: TextStyle(fontSize: 23),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 550,
        child: Column(
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
        ));
  }
}
