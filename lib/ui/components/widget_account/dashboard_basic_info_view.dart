import 'package:flutter/material.dart';

class DashboardBasicInfoView extends StatelessWidget {
  const DashboardBasicInfoView({
    super.key,
    this.padding,
    this.name,
    this.studentId,
    this.schoolClass,
    this.specialization,
    this.isRunning = false,
  });

  final EdgeInsets? padding;
  final String? name, studentId, schoolClass, specialization;
  final bool isRunning;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      child: Card.filled(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 15,
          ),
          child: !isRunning
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.account_circle_outlined,
                      size: 64,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 7),
                      child: Text(
                        name ?? "(Unknown)",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    Text("${studentId ?? "(Unknown)"} - ${schoolClass ?? "(Unknown)"}"),
                    Text(specialization ?? "(unknown)"),
                  ],
                )
              : Container(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  alignment: Alignment.center,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 32,
                        height: 32,
                        child: const CircularProgressIndicator(),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
