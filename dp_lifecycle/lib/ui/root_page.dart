import 'package:dp_lifecycle/ui/file_view/file_view.dart';
import 'package:dp_lifecycle/ui/file_view/info_panel.dart';
import 'package:dp_lifecycle/ui/pattern_panel/pattern_panel.dart';
import 'package:flutter/material.dart';

class RootPage extends StatefulWidget {
  _RootPage createState() => _RootPage();
}

class _RootPage extends State<RootPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Design Pattern Lifecycles')),
      body: Column(
        children: [
          Container(
            child: Row(children: [FileView(), InfoPanel()]),
            height: MediaQuery.of(context).size.height / 2,
          ),
          SingleChildScrollView(child: PatternPanel())
        ],
      ),
    );
  }
}
