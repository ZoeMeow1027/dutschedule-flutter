import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/process_state.dart';
import '../../utils/app_localizations.dart';
import '../../utils/string_utils.dart';
import '../../viewmodel/account_session_instance.dart';
import '../components/info_card.dart';

class SubjectResultView extends StatelessWidget {
  const SubjectResultView({super.key});

  @override
  Widget build(BuildContext context) {
    final accountSession = Provider.of<AccountSessionInstance>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: Text(AppLocalizations.of(context).translate("account_trainingstatus_subjectresult_title")),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endContained,
      floatingActionButton: FloatingActionButton(
        onPressed: () async => await accountSession.fetchTrainingResult(),
        child: accountSession.trainingResult.state == ProcessState.running
            ? SizedBox(width: 24, height: 24, child: CircularProgressIndicator())
            : const Icon(Icons.refresh),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: List.generate(
            accountSession.trainingResult.data?.subjectResultList.length ?? 0,
            (index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: InfoCard(
                  title: StringUtils.formatString(
                    "{0} - {1}",
                    [
                      ((accountSession.trainingResult.data?.subjectResultList.length ?? 0) - index).toString(),
                      accountSession.trainingResult.data?.subjectResultList.reversed.elementAt(index).name ??
                          AppLocalizations.of(context).translate("data_nodata"),
                    ],
                  ),
                  description: StringUtils.formatString(
                    "{0}T10: {1} - T4: {2} - {3}: {4}",
                    [
                      accountSession.trainingResult.data?.subjectResultList.reversed.elementAt(index).isReStudy == true
                          ? "${AppLocalizations.of(context).translate("account_trainingstatus_subjectresult_restudiedsubject")}\n"
                          : "",
                      accountSession.trainingResult.data?.subjectResultList.reversed
                              .elementAt(index)
                              .resultT10
                              ?.toString() ??
                          AppLocalizations.of(context).translate("data_noscore"),
                      accountSession.trainingResult.data?.subjectResultList.reversed
                              .elementAt(index)
                              .resultT4
                              ?.toString() ??
                          AppLocalizations.of(context).translate("data_noscore"),
                      AppLocalizations.of(context).translate("account_trainingstatus_subjectresult_summary_bychar"),
                      accountSession.trainingResult.data?.subjectResultList.reversed
                              .elementAt(index)
                              .resultByCharacter ??
                          AppLocalizations.of(context).translate("data_noscore"),
                    ],
                  ),
                  showBorder: false,
                  onClick: () {},
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
