import 'package:dp_lifecycle/controllers/ui_controller.dart';
import 'package:dp_lifecycle/struct/modified_file.dart';
import 'package:flutter/material.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/night-owl.dart';
import 'package:get/instance_manager.dart';

class Code extends StatelessWidget {
  final ModifiedFile file;
  final bool showAdditions, showDeletions;
  final double? width;
  Code(this.file,
      {Key? key,
      this.showAdditions = false,
      this.showDeletions = false,
      this.width})
      : super(key: key);
  final UIController uiController = Get.find<UIController>();
  final double fontSize = 18.0;
  Map<String, TextStyle> theme = Map<String, TextStyle>.from(nightOwlTheme);
  double ratio = 1.17;
  Widget _createHighlight(
      int startIndex, int difference, bool isAddition, BuildContext context) {
    return Positioned(
        top: startIndex.toDouble() * (fontSize * ratio),
        left: 5,
        child: Container(
          color: (isAddition) ? Colors.green : Colors.red,
          child: Text(
            ((isAddition) ? '+ \n' : '- \n') * difference,
            style: TextStyle(fontSize: fontSize),
          ),
          height: ratio * difference * fontSize,
          width: 9,
        ));
  }

  Widget _createDropShaddow(
      int startIndex, int difference, bool isAddition, BuildContext context) {
    return Positioned(
        top: startIndex.toDouble() * (fontSize * ratio),
        left: 20,
        child: Container(
          color: (isAddition)
              ? Colors.green.withOpacity(0.02)
              : Colors.red.withOpacity(0.02),
          //height: (difference).toDouble() * (ratio * fontSize),
          child: Text(
            ((isAddition) ? '+ \n' : '- \n') * (difference - 1),
            style: TextStyle(fontSize: fontSize, color: Colors.transparent),
          ),
          width: width ?? 0,
        ));
  }

  List<Widget> _getDiffHighlight(
      List<Diff> diffs, bool isAddition, BuildContext context) {
    if (isAddition && !showAdditions) return [];
    if (!isAddition && !showDeletions) return [];
    List<Widget> highlights = [];
    for (int i = 0; i < diffs.length; i++) {
      highlights.add(_createHighlight(diffs[i].index - 1,
          diffs[i].content.split('\n').length, isAddition, context));
      highlights.add(_createDropShaddow(diffs[i].index - 1,
          diffs[i].content.split('\n').length, isAddition, context));
    }
    return highlights;
  }

  @override
  Widget build(BuildContext context) {
    theme['root'] = const TextStyle(
        color: Color(0xffabb2bf), backgroundColor: Colors.transparent);
    return Stack(
      children: [
        // ..._getModificationHighlight(file.content, context),
        ..._getDiffHighlight(file.added, true, context),
        ..._getDiffHighlight(file.deleted, false, context),
        SizedBox(
            width: uiController.getCodeEditorWidth(context),
            child: HighlightView(
              file.content,
              padding: const EdgeInsets.only(left: 20),
              language: file.language,
              textStyle:
                  TextStyle(fontSize: fontSize, fontWeight: FontWeight.w600),
              theme: theme,
            )),
      ],
    );
  }
}
