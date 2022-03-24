import 'package:dp_lifecycle/ui/file_view/file_view.dart';
import 'package:dp_lifecycle/ui/file_view/info_panel.dart';
import 'package:dp_lifecycle/ui/pattern_panel/pattern_panel.dart';
import 'package:dp_lifecycle/ui/project_select/project_selection.dart';
import 'package:flutter/material.dart';

class RootPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Design Pattern Lifecycles'),
        actions: [
          Builder(
            builder: (context) => IconButton(
                onPressed: () => Scaffold.of(context).openEndDrawer(),
                icon: const Icon(Icons.info)),
          )
        ],
      ),
      body: Column(
        children: [
          Container(
            child: Row(children: [FileView(), InfoPanel()]),
            height: MediaQuery.of(context).size.height / 2,
          ),
          PatternPanel()
        ],
      ),
      drawer: Drawer(
        child: ProjectSelection(),
        elevation: 15.0,
      ),
      endDrawer: Drawer(
          elevation: 15.0,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: SingleChildScrollView(
                child: Column(children: [
              const Text(
                "Information",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "The Timeline",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                  '''The timeline is located at the bottom, with the pattern instance
to its left. A pattern instance is single pattern distinguished by its
design pattern and the files associated with it. Clicking the drop down
arrow will reveal those files. The related timeline is adjacently placed on
the right. The first timeline indicates the commits where the pattern was 
detected. The others are related to the files associated with the pattern. A change in 
colour denotes a modification and no colour indicates the file does not exist. '''
                      .replaceAll('\n', '')),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "The Info Panel",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                  '''The Info Panel is the panel to the right side of the code viewer.
The panel indicates key information like commit data and relevant pinot information. When a 
pattern is selected (by clicking on it on the bottom left panel), the pinot information will
be updated. By clicking on the dark grey area with the timeline markers you can move the red
marker. Moving the red marker will also update this information.'''
                      .replaceAll('\n', '')),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "The Code Viewer",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                  '''The code viewer displays relevant code changes of a pattern instance.
It updates similarly to the Info Panel, moving the red cursor at the top of the timeline will
change the time period, and selecting a pattern instance will bring up their code data. You
can select between the different files at the top of the code viewer. Lines that have been added
will be shown with a '+' at the beginning, and a '-' if it was removed.'''
                      .replaceAll('\n', '')),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Interpreting the Timeline",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                  '''Understand that not all pattern/file breaks in the timeline are real
breaks. As we only have information on the main/master branch, branch merges are not reflected.
Notice how these interruptions are largely related with all files existing or not existing at the
beginning of the pattern. These breaks have been minimized by using topological sorting. Red arrow
markers act as a guide for breaks that are likely to be true breaks.'''
                      .replaceAll('\n', ''))
            ])),
          )),
    );
  }
}
