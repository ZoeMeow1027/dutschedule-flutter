import 'package:dutwrapper/account_object.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/process_state.dart';
import '../../utils/app_localizations.dart';
import '../../utils/string_utils.dart';
import '../../viewmodel/account_session_instance.dart';
import '../components/widget_account/subject_info_item.dart';

class SubjectInformationView extends StatelessWidget {
  const SubjectInformationView({super.key});

  @override
  Widget build(BuildContext context) {
    final accountSession = Provider.of<AccountSessionInstance>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: Text(AppLocalizations.of(context).translate("account_subjectinfo_title")),
      ),
      floatingActionButton: (accountSession.subjectInformationList.state == ProcessState.running &&
              accountSession.subjectInformationList.data.isEmpty)
          ? null
          : FloatingActionButton(
              onPressed: () async => await accountSession.fetchSubjectInformation(),
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
                onClick: () {},
              )
            : accountSession.subjectInformationList.state == ProcessState.running
                ? _onLoading(context)
                : _onNoData(context),
      ),
    );
  }

  Widget _header(BuildContext context) {
    final accountSession = Provider.of<AccountSessionInstance>(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      width: double.infinity,
      alignment: Alignment.center,
      child: Text(
        StringUtils.formatString(
          AppLocalizations.of(context).translate("account_schoolyear_main"),
          [
            accountSession.schoolYear.year.toString(),
            (accountSession.schoolYear.year + 1).toString(),
            (accountSession.schoolYear.semester == 3 ? 2 : accountSession.schoolYear.semester).toString(),
            accountSession.schoolYear.semester == 3
                ? AppLocalizations.of(context).translate("account_schoolyear_summer")
                : "",
          ],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _onNoData(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _header(context),
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
        _header(context),
        Spacer(),
        CircularProgressIndicator(),
        Spacer(),
      ],
    );
  }

  Widget _onData({
    required BuildContext context,
    required List<SubjectInformation> subInfoList,
    Function()? onClick,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _header(context),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: List.generate(
                subInfoList.length,
                (index) {
                  return SubjectInfoItem(
                    subjectInfo: subInfoList.elementAt(index),
                    onClick: () => onClick?.call(),
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
