import 'package:dutwrapper/account_object.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../model/enum/background_image_option.dart';
import '../../model/enum/process_state.dart';
import '../../utils/string_utils.dart';
import '../../viewmodel/account_session_instance.dart';
import '../../viewmodel/settings_instance.dart';
import '../components/widget_account/subject_detail_info.dart';
import '../components/widget_account/subject_info_item.dart';

class SubjectInformationView extends StatefulWidget {
  const SubjectInformationView({super.key});

  @override
  State<StatefulWidget> createState() => _SubjectInformationView();
}

class _SubjectInformationView extends State<SubjectInformationView> {
  @override
  void initState() {
    super.initState();

    // Post-frame callback to safely use context
    WidgetsBinding.instance.addPostFrameCallback((_) {
      doSomething();
    });
  }

  Future<void> doSomething() async {
    final accountSession = Provider.of<AccountSessionInstance>(context, listen: false);
    await accountSession.fetchSubjectInformation();
  }

  @override
  Widget build(BuildContext context) {
    final accountSession = Provider.of<AccountSessionInstance>(context);
    final settingsInstance = Provider.of<SettingsInstance>(context);

    String getSemesterLabel(BuildContext context, int semester) {
      final t = AppLocalizations.of(context).translate;
      switch (semester) {
        case 1:
          return t("account_schoolyear_title_semester_1");
        case 2:
          return t("account_schoolyear_title_semester_2");
        case 3:
          return t("account_schoolyear_title_summersemester");
        default:
          return t("data_unknown");
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: Text(AppLocalizations.of(context).translate("account_subjectinfo_title")),
      ),
      bottomNavigationBar: BottomAppBar(
        color: settingsInstance.backgroundImageOption == BackgroundImageOption.none ? null : Colors.transparent,
        child: Row(
          children: [
            Expanded(
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
                        getSemesterLabel(context, accountSession.schoolYear.semester),
                      ],
                    ),
                    style: Theme.of(context).textTheme.titleSmall,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    softWrap: false,
                  ),
                  const SizedBox(height: 3),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(Icons.history, size: 24),
                      const SizedBox(width: 7),
                      Expanded(
                        child: Text(
                          StringUtils.formatString(
                            AppLocalizations.of(context).translate("time_last_request"),
                            [
                              accountSession.subjectInformationList.lastRequest == 0
                                  ? AppLocalizations.of(context).translate("data_unknown")
                                  : DateFormat("dd/MM/yyyy HH:mm").format(
                                      DateTime.fromMillisecondsSinceEpoch(
                                        accountSession.subjectInformationList.lastRequest,
                                      ),
                                    ),
                            ],
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          softWrap: false,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            FloatingActionButton(
              onPressed: () async => await accountSession.fetchSubjectInformation(forceRequest: true),
              child: accountSession.subjectInformationList.state == ProcessState.running
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.refresh, size: 24),
            ),
          ],
        ),
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
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Spacer(),
            Text(
              AppLocalizations.of(context).translate("account_subjectinfo_summary_nosubjects"),
              textAlign: TextAlign.center,
            ),
            Spacer(),
          ],
        ),
      ),
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
          child: ListView.separated(
            itemCount: subInfoList.length,
            itemBuilder: (context, index) {
              return SubjectInfoItem(
                subjectInfo: subInfoList.elementAt(index),
                onClick: () => onClick?.call(subInfoList.elementAt(index)),
                shouldRadiusOnTop: index == 0,
                shouldRadiusOnBottom: index == (subInfoList.length - 1),
              );
            },
            separatorBuilder: (context, index) => SizedBox(height: 3),
          ),
        )
      ],
    );
  }
}
