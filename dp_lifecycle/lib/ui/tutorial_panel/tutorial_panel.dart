import 'package:flutter/material.dart';

class TutorialPanel extends StatelessWidget {
  const TutorialPanel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
          "What is this?",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        Text(
            '''PIE (Pattern Instance Explorer)! a tool for exploring & visualizing the 
life cycle of design patterns in open source Java projects. Using this tool we hope to 
learn why a pattern may have broke, morphed or changed all together. Below we will explain
parts of the tool to get you started'''
                .replaceAll('\n', '')),
        const SizedBox(
          height: 20,
        ),
        const Text(
          "A Pattern Instance",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Text('''We describe a pattern instance as a set of files that 
meet the criteria of a particular design pattern. Pattern instances have cards on the 
bottom left. You select the pattern chips to filter between different design patterns.
Additionally, click the drop down arrow will reveal it's files!'''
            .replaceAll('\n', '')),
        const SizedBox(
          height: 10,
        ),
        Image.asset('assets/images/exp1.png'),
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
        Text('''The timeline is adjacently placed on
the right of the pattern instance cards. The timeline is read from left to right, from the 
project's inception to its latest commit. The first timeline indicates the commits where the pattern was 
detected. The others are related to the files associated with the pattern. A change in 
colour denotes a modification and no colour indicates the file does not exist.'''
            .replaceAll('\n', '')),
        const SizedBox(
          height: 10,
        ),
        Image.asset('assets/images/exp2.png'),
        const SizedBox(
          height: 10,
        ),
        Text('''If you need
to zoom in, don't be afraid to adjust the blue handles at the ends of the top yellow bar.
Moving them closer together will zoom into the timeline, and you can navigate across by 
dragging the center yellow bar. '''
            .replaceAll('\n', '')),
        const SizedBox(
          height: 10,
        ),
        Image.asset('assets/images/timeline_zooming.gif'),
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
pattern instance is selected, the pinot information will
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
    );
  }
}
