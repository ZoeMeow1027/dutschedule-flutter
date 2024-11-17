import 'package:dutwrapper/account_object.dart';
import 'package:flutter/material.dart';

import '../../../utils/app_localizations.dart';
import '../../../utils/object_to_map_utils.dart';
import '../info_card.dart';

class SubjectResultBottomSheet extends StatelessWidget {
  const SubjectResultBottomSheet({
    super.key,
    required this.subjectName,
    required this.subjectResult,
    this.onClickToCopy,
  });

  final String subjectName;
  final SubjectResult subjectResult;
  final Function()? onClickToCopy;

  @override
  Widget build(BuildContext context) {
    var data = ObjectToMapUtils.fromSubjectResult(context: context, sr: subjectResult);
    return FractionallySizedBox(
      heightFactor: 0.75,
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 15),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Text(
                  subjectName,
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
              ),
              subjectResult.isReStudy
                  ? Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: Text(
                        AppLocalizations.of(context).translate("account_trainingstatus_subjectresult_restudied"),
                        style: Theme.of(context).textTheme.titleMedium,
                        textAlign: TextAlign.center,
                      ),
                    )
                  : Container(),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: List.generate(
                      data.length,
                      (index) {
                        if (data.entries.elementAt(index).value == null) {
                          return Container();
                        } else {
                          return Padding(
                            padding: EdgeInsets.zero,
                            child: InfoCard(
                              title: data.entries.elementAt(index).key,
                              description: data.entries.elementAt(index).value,
                              showBorder: false,
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
                child: FilledButton(
                  onPressed: () {
                    onClickToCopy?.call();
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 3),
                          child: Icon(Icons.copy),
                        ),
                        Text(AppLocalizations.of(context)
                            .translate("account_trainingstatus_subjectresult_button_copyall"))
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
