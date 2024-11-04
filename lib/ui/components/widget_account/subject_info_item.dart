import 'package:dutwrapper/account_object.dart';
import 'package:flutter/material.dart';

class SubjectInfoItem extends StatelessWidget {
  const SubjectInfoItem({
    super.key,
    required this.subjectInfo,
    this.padding = EdgeInsets.zero,
    this.onClick,
  });

  final EdgeInsets padding;
  final SubjectInformation subjectInfo;
  final Function()? onClick;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: InkWell(
        onTap: () {
          if (onClick != null) {
            onClick!();
          }
        },
        child: Card.filled(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            alignment: Alignment.topLeft,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  subjectInfo.name,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Text("""
                ${subjectInfo.lecturerName}
                
                Week range: ${subjectInfo.subjectStudy.weekList.toString()}
                Schedules:
                ${subjectInfo.subjectStudy.subjectStudyList.map((p) {
                  return "- ${p.dayOfWeek} - Lesson ${p.lesson.toString()} - Room ${p.room}";
                }).join("\n") }
                """),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
