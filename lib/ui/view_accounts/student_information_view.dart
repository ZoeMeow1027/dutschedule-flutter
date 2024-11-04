import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/process_state.dart';
import '../../viewmodel/account_session_instance.dart';
import '../components/widget_account/student_info_item.dart';

class StudentInformationView extends StatelessWidget {
  const StudentInformationView({super.key});

  @override
  Widget build(BuildContext context) {
    final accountSession = Provider.of<AccountSessionInstance>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: const Text("Student Information"),
      ),
      floatingActionButton: (accountSession.studentInformation.state == ProcessState.running &&
              accountSession.studentInformation.data == null)
          ? null
          : FloatingActionButton(
              onPressed: () async => await accountSession.fetchStudentInformation(),
              child: accountSession.studentInformation.state == ProcessState.running
                  ? SizedBox(width: 24, height: 24, child: CircularProgressIndicator())
                  : const Icon(Icons.refresh),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endContained,
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Tooltip(
              message: 'Detailed information here',
              textStyle: TextStyle(color: Colors.white),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(8),
              ),
              waitDuration: Duration(milliseconds: 500), // Time before tooltip shows
              showDuration: Duration(seconds: 2), // Time tooltip stays visible
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(Icons.info),
                  Padding(
                    padding: const EdgeInsets.only(left: 7),
                    child: Text("Edit information?\n(Hold/long-tap for info)"),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SingleChildScrollView(
          child: Column(
            children: List.generate(
              (accountSession.studentInformation.data?.toMap().entries.length ?? 0),
              (index) {
                if (accountSession.studentInformation.data?.toMap().entries.elementAt(index).value != null) {
                  return StudentInfoItem(
                    name: accountSession.studentInformation.data?.toMap().entries.elementAt(index).key,
                    value: accountSession.studentInformation.data?.toMap().entries.elementAt(index).value,
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
