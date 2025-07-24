import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../model/enum/background_image_option.dart';
import '../../model/enum/process_state.dart';
import '../../utils/app_localizations.dart';
import '../../utils/build_context_extension.dart';
import '../../utils/string_utils.dart';
import '../../viewmodel/account_session_instance.dart';
import '../../viewmodel/settings_instance.dart';
import '../components/widget_account/graduate_summary.dart';
import '../components/widget_account/training_summary.dart';
import 'subject_result_view.dart';

class TrainingResultView extends StatefulWidget {
  const TrainingResultView({super.key});

  @override
  State<StatefulWidget> createState() => _TrainingResultView();
}

class _TrainingResultView extends State<TrainingResultView> {
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
    await accountSession.fetchTrainingResult();
  }

  @override
  Widget build(BuildContext context) {
    final accountSession = Provider.of<AccountSessionInstance>(context);
    final settingsInstance = Provider.of<SettingsInstance>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: Text(AppLocalizations.of(context).translate("account_trainingstatus_title")),
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
                              accountSession.trainingResult.lastRequest == 0
                                  ? AppLocalizations.of(context).translate("data_unknown")
                                  : DateFormat("dd/MM/yyyy HH:mm").format(
                                      DateTime.fromMillisecondsSinceEpoch(
                                        accountSession.trainingResult.lastRequest,
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
              onPressed: () async => await accountSession.fetchTrainingResult(forceRequest: true),
              child: accountSession.trainingResult.state == ProcessState.running
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.refresh, size: 24),
            ),
          ],
        ),
      ),
      // bottomNavigationBar: BottomAppBar(color: Colors.transparent),
      body: accountSession.trainingResult.data != null
          ? _onData(context, accountSession)
          : accountSession.trainingResult.state == ProcessState.running
              ? _onLoading(context)
              : _onNoData(context),
    );
  }

  Widget _onData(BuildContext context, AccountSessionInstance accountSession) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 15),
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
          SizedBox(height: 15),
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
    );
  }

  Widget _onLoading(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 48,
        height: 48,
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _onNoData(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
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
