import 'package:dp_lifecycle/struct/project.dart';
import 'package:flutter/material.dart';

class ProjectCard extends StatelessWidget {
  final Project project;
  final Function(Project) callback;
  final bool isSelected;
  const ProjectCard(this.project, this.callback, this.isSelected, {Key? key})
      : super(key: key);

  Color _getColour() {
    switch (project.projectStatus) {
      case ProjectStatus.ready:
        return Colors.green;
      case ProjectStatus.error:
        return Colors.red;
      case ProjectStatus.processing:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 100,
        child: Card(
          color: isSelected
              ? const Color.fromARGB(255, 20, 53, 70)
              : Theme.of(context).dialogBackgroundColor,
          child: InkWell(
              onTap: project.projectStatus == ProjectStatus.ready
                  ? () => callback(project)
                  : null,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  Icon(
                    Icons.folder_outlined,
                    color: _getColour(),
                    size: 50,
                  ),
                  const SizedBox(
                    width: 50,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        project.name,
                        style: TextStyle(color: _getColour(), fontSize: 18),
                        textAlign: TextAlign.right,
                      ),
                      Text(
                        project.projectStatus.toString().split('.')[1],
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            color: _getColour(),
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  )
                ]),
              )),
        ));
  }
}
