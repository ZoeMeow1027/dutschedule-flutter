import 'package:dutschedule/utils/build_context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../model/process_state.dart';
import '../../utils/app_localizations.dart';
import '../../viewmodel/account_session_instance.dart';
import '../components/widget_account/graduate_summary.dart';
import '../components/widget_account/training_summary.dart';
import 'subject_result_view.dart';

class TrainingResultView extends StatelessWidget {
  const TrainingResultView({super.key});

  @override
  Widget build(BuildContext context) {
    final accountSession = Provider.of<AccountSessionInstance>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: Text(AppLocalizations.of(context).translate("account_trainingstatus_title")),
      ),
      body: !_shouldShowLoadingScreen(accountSession)
          ? _mainScreenData(context, accountSession)
          : accountSession.trainingResult.state == ProcessState.running
              ? _mainScreenLoading(context)
              : _mainScreenNoData(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.endContained,
      floatingActionButton: FloatingActionButton(
        onPressed: () async => await accountSession.fetchTrainingResult(forceRequest: true),
        child: accountSession.trainingResult.state == ProcessState.running
            ? SizedBox(width: 24, height: 24, child: CircularProgressIndicator())
            : const Icon(Icons.refresh),
      ),
      // bottomNavigationBar: BottomAppBar(color: Colors.transparent),
    );
  }

  bool _shouldShowLoadingScreen(AccountSessionInstance instance) {
    return instance.trainingResult.data != null ? false : instance.trainingResult.state == ProcessState.running;
  }

  Widget _mainScreenData(BuildContext context, AccountSessionInstance accountSession) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TrainingSummary(
              score: accountSession.trainingResult.data?.trainingSummary.avgTrainingScore4 ?? 0,
              schoolYearUpdated: accountSession.trainingResult.data?.trainingSummary.schoolYearCurrent,
              onClick: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SubjectResultView()),
                );
              },
            ),
            GraduateSummary(
              graduateStatus: accountSession.trainingResult.data?.graduateStatus,
              onCopy: (copiedString) {
                if (copiedString.isNotEmpty) {
                  Clipboard.setData(ClipboardData(text: copiedString));
                  context.showCustomSnackBar(
                    content: Text(AppLocalizations.of(context).translate("clipboard_copied")),
                    dismissOld: true,
                  );
                } else {
                  context.showCustomSnackBar(
                    content: Text(AppLocalizations.of(context).translate("clipboard_copynothing")),
                    dismissOld: true,
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _mainScreenLoading(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 48,
        height: 48,
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _mainScreenNoData(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Center(
        child: Text(
          AppLocalizations.of(context).translate("account_trainingstatus_nodata"),
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
