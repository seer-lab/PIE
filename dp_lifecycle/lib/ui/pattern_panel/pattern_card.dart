import 'package:dp_lifecycle/struct/pattern_instance.dart';
import 'package:dp_lifecycle/ui/pattern_panel/dp_chip.dart';
import 'package:flutter/material.dart';

class PatternCard extends StatelessWidget {
  final PatternInstance pattern;
  const PatternCard(this.pattern, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 550,
        height: 100,
        child: Card(
            child: Column(
          children: [
            Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      pattern.name.length > 35
                          ? pattern.name.substring(0, 33) + '..'
                          : pattern.name,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    DPChip(pattern.pattern)
                  ],
                )),
            Padding(
              padding: const EdgeInsets.all(5),
              child: Row(children: [
                const Icon(Icons.file_copy, color: Colors.grey),
                Text(pattern.files.length.toString())
              ]),
            )
          ],
        )));
  }
}
