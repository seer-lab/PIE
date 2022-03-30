import 'package:dp_lifecycle/controllers/lifecycle_controller.dart';
import 'package:dp_lifecycle/controllers/timeline_controller.dart';
import 'package:dp_lifecycle/struct/project.dart';
import 'package:dp_lifecycle/ui/project_select/project_card.dart';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';

class ProjectSelection extends StatefulWidget {
  const ProjectSelection({Key? key}) : super(key: key);
  _ProjectSelection createState() => _ProjectSelection();
}

class _ProjectSelection extends State<ProjectSelection> {
  List<Project>? projects;
  TimelineController controller = Get.find<TimelineController>();
  String selectedProjectName = 'awt';
  bool popped = false;
  @override
  void initState() {
    controller.getProjects().then((value) => setState(() => projects = value));
  }

  void onSelectProject(Project project) {
    controller.onSelectProject(project).then((value) {
      Get.find<LifecycleController>().onRefresh();
      if (value && !popped) {
        setState(() {
          selectedProjectName = project.name;
        });
      }
    });
    Get.find<LifecycleController>().onUnload();
  }

  @override
  void dispose() {
    super.dispose();
    popped = true;
  }

  @override
  Widget build(BuildContext context) {
    if (projects == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return ListView(
          children: [
        const SizedBox(
          height: 20,
        ),
        const Text(
          "Projects",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 28,
          ),
        ),
        const SizedBox(
          height: 30,
        )
      ]..addAll(projects!.map((e) => ProjectCard(e, onSelectProject,
              e.name == controller.selectedProject.value.name))));
    }
  }
}
