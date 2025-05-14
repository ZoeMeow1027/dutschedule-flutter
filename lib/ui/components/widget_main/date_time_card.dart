import 'dart:async';

import 'package:dutwrapper/custom_clock.dart';
import 'package:dutwrapper/utils.dart';
import 'package:dutwrapper/utils_object.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../utils/app_localizations.dart';
import '../card_with_title.dart';

class DateTimeCard extends StatefulWidget {
  const DateTimeCard({
    super.key,
    this.padding = EdgeInsets.zero,
  });

  final EdgeInsets padding;

  @override
  State<StatefulWidget> createState() => _DateTimeCard();
}

class _DateTimeCard extends State<DateTimeCard> {
  Timer? timer;
  DutSchoolYear? dutSchoolYear;
  String dateTimeStr = "";
  bool needRefershDutSchYear = true;
  String currentLesson = "";

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(milliseconds: 100), _updateTime);
  }

  @override
  void dispose() {
    timer?.cancel();
    timer = null;
    super.dispose();
  }

  void _updateTime(Timer timer) {
    setState(() {
      dateTimeStr = DateFormat('y/MM/d kk:mm:ss').format(DateTime.now());
      currentLesson = switch (CustomClock.current().toDUTLesson()) {
        -2 => AppLocalizations.of(context).translate("main_dashboard_widget_datetime_notyetstarted"),
        -1 => AppLocalizations.of(context).translate("main_dashboard_widget_datetime_atnoon"),
        0 => AppLocalizations.of(context).translate("main_dashboard_widget_datetime_finished"),
        _ => CustomClock.current().toDUTLesson().toString(),
      };
    });

    if (needRefershDutSchYear) {
      Utils.getCurrentSchoolYear().then((p) {
        setState(() {
          dutSchoolYear = p;
          needRefershDutSchYear = false;
        });
      }).onError((err, _) {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return CardWithTitle(
      padding: widget.padding,
      title: AppLocalizations.of(context).translate("main_dashboard_widget_datetime_title"),
      // child: Text(
      //   "Date & time: $dateTimeStr"
      //   "\nCurrent lesson: $currentLesson"
      //   "\n(based on your system settings)"
      //   "\n\nSchool year: ${dutSchoolYear?.schoolYear ?? "(unknown)"} - Week: ${dutSchoolYear?.week ?? "(unknown)"}",
      // ),
      child: Text(AppLocalizations.of(context).translateWithParameters(
        "main_dashboard_widget_datetime_currenttime",
        [
          dateTimeStr,
          currentLesson,
          dutSchoolYear?.schoolYear ?? AppLocalizations.of(context).translate("data_unknown"),
          dutSchoolYear?.week.toString() ?? AppLocalizations.of(context).translate("data_unknown"),
        ],
      )),
    );
  }
}
