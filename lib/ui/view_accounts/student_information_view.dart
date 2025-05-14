import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../model/enum/background_image_option.dart';
import '../../model/process_state.dart';
import '../../utils/app_localizations.dart';
import '../../utils/build_context_extension.dart';
import '../../utils/object_to_map_utils.dart';
import '../../utils/string_utils.dart';
import '../../viewmodel/account_session_instance.dart';
import '../../viewmodel/settings_instance.dart';
import '../components/widget_account/student_info_item.dart';

class StudentInformationView extends StatefulWidget {
  const StudentInformationView({super.key});

  @override
  State<StatefulWidget> createState() => _StudentInformationView();
}

class _StudentInformationView extends State<StudentInformationView> {
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
    await accountSession.fetchStudentInformation();
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
        title: Text(AppLocalizations.of(context).translate("account_accinfo_title")),
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
                  InkWell(
                    onTap: () async {
                      showDialog<void>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: Text(AppLocalizations.of(context).translate("account_accinfo_editinfo")),
                          content: SingleChildScrollView(
                            child: Column(
                              children: [
                                Text(AppLocalizations.of(context).translate("account_accinfo_description")),
                              ],
                            ),
                          ),
                          actions: [
                            TextButton(
                              child: Text(AppLocalizations.of(context).translate("action_ok")),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ],
                        ),
                      );
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.info),
                        Padding(
                          padding: const EdgeInsets.only(left: 7),
                          child: Text(AppLocalizations.of(context).translate("account_accinfo_editinfo")),
                        ),
                      ],
                    ),
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
                              accountSession.studentInformation.lastRequest == 0
                                  ? AppLocalizations.of(context).translate("data_unknown")
                                  : DateFormat("dd/MM/yyyy HH:mm").format(
                                      DateTime.fromMillisecondsSinceEpoch(
                                        accountSession.studentInformation.lastRequest,
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
              onPressed: () async => await accountSession.fetchStudentInformation(forceRequest: true),
              child: accountSession.subjectInformationList.state == ProcessState.running
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.refresh, size: 24),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SingleChildScrollView(
          child: Column(
            children: List.generate(
              ObjectToMapUtils.fromStudentInformation(
                context: context,
                st: accountSession.studentInformation.data,
              ).entries.length,
              // (accountSession.studentInformation.data?.toMap().entries.length ?? 0),
              (index) {
                if (ObjectToMapUtils.fromStudentInformation(
                      context: context,
                      st: accountSession.studentInformation.data,
                    ).entries.elementAt(index).value !=
                    null) {
                  return StudentInfoItem(
                    name: ObjectToMapUtils.fromStudentInformation(
                      context: context,
                      st: accountSession.studentInformation.data,
                    ).entries.elementAt(index).key,
                    value: ObjectToMapUtils.fromStudentInformation(
                      context: context,
                      st: accountSession.studentInformation.data,
                    ).entries.elementAt(index).value,
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
                  );
                } else {
                  return Container();
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
