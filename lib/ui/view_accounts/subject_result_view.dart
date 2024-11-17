import 'package:dutwrapper/account_object.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/process_state.dart';
import '../../utils/app_localizations.dart';
import '../../utils/string_utils.dart';
import '../../viewmodel/account_session_instance.dart';
import '../components/info_card.dart';
import '../components/widget_account/subject_result_bottom_sheet.dart';
import '../components/switch_button.dart';

class SubjectResultView extends StatefulWidget {
  const SubjectResultView({super.key});

  @override
  State<StatefulWidget> createState() => _SubjectResultViewState();
}

class _SubjectResultViewState extends State<SubjectResultView> {
  bool _isInitialized = false;
  bool _filterEnabled = false;
  List<String> _allFilters = [];
  int _selectedFilterIndex = 0;
  final TextEditingController _filterQueryController = TextEditingController();
  String _filterQuery = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final accountSession = Provider.of<AccountSessionInstance>(context);
    if (!_isInitialized) {
      setState(() {
        _allFilters = _getAllFilters(
          context,
          accountSession.trainingResult.data?.subjectResultList.reversed.toList() ?? [],
        );
        _selectedFilterIndex = 0;
        _isInitialized = true;
      });
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: Text(AppLocalizations.of(context).translate("account_trainingstatus_subjectresult_title")),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endContained,
      floatingActionButton: FloatingActionButton(
        onPressed: () async => await accountSession.fetchTrainingResult(forceRequest: true),
        child: accountSession.trainingResult.state == ProcessState.running
            ? SizedBox(width: 24, height: 24, child: CircularProgressIndicator())
            : const Icon(Icons.refresh),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SwitchButton(
              value: _filterEnabled,
              onPressed: () {
                setState(() {
                  _filterEnabled = !_filterEnabled;
                  _filterQueryController.text = "";
                });
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 2),
                      child: Icon(
                        Icons.filter_alt,
                        size: 30,
                      ),
                    ),
                    Text(AppLocalizations.of(context)
                        .translate("account_trainingstatus_subjectresult_searchfilterbutton")),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          (_filterEnabled || _selectedFilterIndex == 0)
              ? Container()
              : Text(StringUtils.formatString(
            AppLocalizations.of(context).translate("account_trainingstatus_subjectresult_filteredschyear"),
            [_allFilters.elementAt(_selectedFilterIndex)],
          )),
          (_filterEnabled || _filterQuery.isEmpty)
              ? Container()
              : Text(StringUtils.formatString(
            AppLocalizations.of(context).translate("account_trainingstatus_subjectresult_filteredquery"),
            [_filterQuery],
          )),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: List.generate(
                  _filterView(
                    source: accountSession.trainingResult.data?.subjectResultList.reversed.toList(),
                    schoolYear: _selectedFilterIndex == 0 ? null : _allFilters.elementAt(_selectedFilterIndex),
                    query: _filterQuery,
                  ).length,
                  (index) {
                    var dataItem = _filterView(
                      source: accountSession.trainingResult.data?.subjectResultList.reversed.toList(),
                      schoolYear: _selectedFilterIndex == 0 ? null : _allFilters.elementAt(_selectedFilterIndex),
                      query: _filterQuery,
                    ).elementAt(index);

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: InfoCard(
                        title: StringUtils.formatString(
                          "{0} - {1}",
                          [
                            ((accountSession.trainingResult.data?.subjectResultList.length ?? 0) - index).toString(),
                            dataItem.name ?? AppLocalizations.of(context).translate("data_nodata"),
                          ],
                        ),
                        description: StringUtils.formatString(
                          "{0}T10: {1} - T4: {2} - {3}: {4}",
                          [
                            dataItem.isReStudy == true
                                ? "${AppLocalizations.of(context).translate("account_trainingstatus_subjectresult_restudied")}\n"
                                : "",
                            dataItem.resultT10?.toString() ?? AppLocalizations.of(context).translate("data_noscore"),
                            dataItem.resultT4?.toString() ?? AppLocalizations.of(context).translate("data_noscore"),
                            AppLocalizations.of(context)
                                .translate("account_trainingstatus_subjectresult_summary_bychar"),
                            dataItem.resultByCharacter ?? AppLocalizations.of(context).translate("data_noscore"),
                          ],
                        ),
                        showBorder: false,
                        onClick: () async {
                          await showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            builder: (BuildContext context) => SubjectResultBottomSheet(
                              subjectName: dataItem.name,
                              subjectResult: dataItem,
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          !_filterEnabled
              ? Container()
              : Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 5),
                  child: TextField(
                    controller: _filterQueryController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText:
                          AppLocalizations.of(context).translate("account_trainingstatus_subjectresult_searchquery"),
                    ),
                    onChanged: (String? text) {
                      if (text == null) {
                        return;
                      }
                      setState(() {
                        _filterQuery = text;
                      });
                    },
                  ),
                ),
          !_filterEnabled
              ? Container()
              : DropdownButtonFormField<String>(
                  padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(), // Optional: for a boxed effect
                    contentPadding: EdgeInsets.all(12),
                    label: Text(
                      AppLocalizations.of(context).translate("account_trainingstatus_subjectresult_schoolyear"),
                    ),
                  ),
                  value: _allFilters.elementAt(_selectedFilterIndex),
                  onChanged: (String? str) {
                    if (str == null) {
                      return;
                    }
                    setState(() {
                      _selectedFilterIndex = _allFilters.indexOf(str) > 0 ? _allFilters.indexOf(str) : 0;
                    });
                  },
                  items: _convertAllToDropdownMenuItem(
                    context,
                    accountSession.trainingResult.data?.subjectResultList.reversed.toList() ?? [],
                  ),
                ),
          !_filterEnabled
              ? Container()
              : Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 5),
                  child: FilledButton(
                    onPressed: () => setState(() {
                      _selectedFilterIndex = 0;
                      _filterQueryController.text = "";
                      _filterQuery = "";
                    }),
                    child: Text("Reset all filters"),
                  ),
                ),
        ],
      ),
    );
  }

  List<SubjectResult> _filterView({
    List<SubjectResult>? source,
    String? schoolYear,
    String? query,
  }) {
    return source == null
        ? []
        : source.where((p) {
            if (schoolYear != null) {
              if (p.schoolYear.compareTo(schoolYear) != 0) {
                return false;
              }
            }
            if ((query ?? "").isNotEmpty) {
              if (!p.name.toLowerCase().contains(query!.toLowerCase())) {
                return false;
              }
            }
            return true;
          }).toList();
  }

  List<String> _getAllFilters(BuildContext context, List<SubjectResult> list) {
    var result = list.map((p) => p.schoolYear).toSet().toList();
    result.insert(0, AppLocalizations.of(context).translate("account_trainingstatus_subjectresult_allschoolyears"));
    return result;
  }

  List<DropdownMenuItem<String>> _convertAllToDropdownMenuItem(
    BuildContext context,
    List<SubjectResult> list,
  ) {
    return _getAllFilters(context, list).map((p) => DropdownMenuItem<String>(value: p, child: Text(p))).toList();
  }
}
