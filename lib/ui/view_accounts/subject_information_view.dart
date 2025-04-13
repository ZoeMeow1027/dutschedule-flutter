import 'package:dutwrapper/account_object.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../model/enum/background_image_option.dart';
import '../../model/process_state.dart';
import '../../utils/app_localizations.dart';
import '../../utils/string_utils.dart';
import '../../viewmodel/account_session_instance.dart';
import '../../viewmodel/settings_instance.dart';
import '../components/widget_account/subject_detail_info.dart';
import '../components/widget_account/subject_info_item.dart';

class SubjectInformationView extends StatelessWidget {
  const SubjectInformationView({super.key});

  @override
  Widget build(BuildContext context) {
    final accountSession = Provider.of<AccountSessionInstance>(context);
    final settingsInstance = Provider.of<SettingsInstance>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: Text(AppLocalizations.of(context).translate("account_subjectinfo_title")),
      ),
      bottomNavigationBar: BottomAppBar(
        color: settingsInstance.backgroundImageOption == BackgroundImageOption.none ? null : Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              StringUtils.formatString(
                AppLocalizations.of(context).translate("account_schoolyear_title_main"),
                [
                  accountSession.schoolYear.year.toString(),
                  (accountSession.schoolYear.year + 1).toString(),
                  accountSession.schoolYear.semester == 1
                      ? AppLocalizations.of(context).translate("account_schoolyear_title_semester_1")
                      : accountSession.schoolYear.semester == 2
                          ? AppLocalizations.of(context).translate("account_schoolyear_title_semester_2")
                          : accountSession.schoolYear.semester == 3
                              ? AppLocalizations.of(context).translate("account_schoolyear_title_summersemester")
                              : AppLocalizations.of(context).translate("data_unknown"),
                ],
              ),
              style: Theme.of(context).textTheme.titleSmall,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 3),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(Icons.history),
                  Padding(
                    padding: const EdgeInsets.only(left: 7),
                    child: Text(StringUtils.formatString(
                      AppLocalizations.of(context).translate("time_last_request"),
                      [
                        accountSession.subjectInformationList.lastRequest == 0
                            ? AppLocalizations.of(context).translate("data_unknown")
                            : DateFormat("dd/MM/yyyy HH:mm").format(
                                DateTime.fromMillisecondsSinceEpoch(accountSession.subjectInformationList.lastRequest))
                      ],
                    )),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endContained,
      floatingActionButton: (accountSession.subjectInformationList.state == ProcessState.running &&
              accountSession.subjectInformationList.data.isEmpty)
          ? null
          : FloatingActionButton(
              onPressed: () async => await accountSession.fetchSubjectInformation(forceRequest: true),
              child: accountSession.subjectInformationList.state == ProcessState.running
                  ? SizedBox(width: 24, height: 24, child: CircularProgressIndicator())
                  : const Icon(Icons.refresh),
            ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: accountSession.subjectInformationList.data.isNotEmpty
            ? _onData(
                context: context,
                subInfoList: accountSession.subjectInformationList.data,
                onClick: (subjectInfo) async {
                  await showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (BuildContext context) => SubjectDetailInfo(
                      subjectInfo: subjectInfo,
                    ),
                  );
                },
              )
            : accountSession.subjectInformationList.state == ProcessState.running
                ? _onLoading(context)
                : _onNoData(context),
      ),
    );
  }

  Widget _onNoData(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Spacer(),
        Text(
          AppLocalizations.of(context).translate("account_subjectinfo_summary_nosubjects"),
          textAlign: TextAlign.center,
        ),
        Spacer(),
      ],
    );
  }

  Widget _onLoading(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Spacer(),
        Container(
          alignment: Alignment.center,
          child: CircularProgressIndicator(),
        ),
        Spacer(),
      ],
    );
  }

  Widget _onData({
    required BuildContext context,
    required List<SubjectInformation> subInfoList,
    Function(SubjectInformation)? onClick,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: List.generate(
                subInfoList.length,
                (index) {
                  return SubjectInfoItem(
                    subjectInfo: subInfoList.elementAt(index),
                    onClick: () => onClick?.call(subInfoList.elementAt(index)),
                  );
                },
              ),
            ),
          ),
        )
      ],
    );
  }
}
