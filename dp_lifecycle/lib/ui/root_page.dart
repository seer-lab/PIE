import 'package:dp_lifecycle/ui/pattern_panel/pattern_panel.dart';
import 'package:flutter/material.dart';

class RootPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Design Pattern Lifecycles')),
      body: Column(
        children: [
          Container(
            child: const Center(child: Text('Text Editor')),
            height: MediaQuery.of(context).size.height / 2,
          ),
          PatternPanel()
        ],
      ),
    );
  }
}
