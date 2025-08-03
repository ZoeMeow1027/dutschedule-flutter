import 'package:dutwrapper/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../viewmodel/news_search_instance.dart';
import '../components/expandable_choice.dart';
import '../components/widget_news/news_search_history_item.dart';

class NewsSearchOptionView extends StatefulWidget {
  const NewsSearchOptionView({super.key});

  @override
  State<StatefulWidget> createState() => _NewsSearchOptionView();
}

class _NewsSearchOptionView extends State<NewsSearchOptionView> {
  final _searchQueryControl = TextEditingController();

  // focus node to capture keyboard events
  final FocusNode _focusNode = FocusNode();
  // focus node for detect TextField is focus.
  final FocusNode _focusNodeTextField = FocusNode();

  // Temporary query for placeholder.
  String _searchQuery = "";
  NewsType _newsType = NewsType.global;
  NewsSearchMethod _searchMethod = NewsSearchMethod.byTitle;

  // Search option show state
  bool _newsTypeComboBoxShown = false;
  bool _newsSearchMethodComboBoxShown = false;

  @override
  Widget build(BuildContext context) {
    final newsSearchInstance = Provider.of<NewsSearchInstance>(context);

    return KeyboardListener(
      autofocus: true,
      onKeyEvent: (event) {
        if (event is KeyDownEvent &&
            (event.logicalKey == LogicalKeyboardKey.enter || event.logicalKey == LogicalKeyboardKey.numpadEnter)) {
          if (_focusNodeTextField.hasFocus) {
            if (_searchQuery.isNotEmpty) {
              newsSearchInstance.changeNewsSearchOption(
                query: _searchQuery,
                newsType: _newsType,
                searchMethod: _searchMethod,
              );
              newsSearchInstance.fetchSearchRun(startOver: true);
              Navigator.pop(context);
            }
          }
        } else if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.escape) {
          Navigator.pop(context);
        }
      },
      focusNode: _focusNode,
      child: Scaffold(
        appBar: AppBar(
          title: TextField(
            controller: _searchQueryControl,
            onChanged: (text) => setState(() {
              _searchQuery = text;
            }),
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: AppLocalizations.of(context).translate("news_search_searchbox_placeholder"),
            ),
            focusNode: _focusNodeTextField,
          ),
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 5),
              child: IconButton(
                onPressed: () {
                  if (_searchQuery.isNotEmpty) {
                    newsSearchInstance.changeNewsSearchOption(
                      query: _searchQuery,
                      newsType: _newsType,
                      searchMethod: _searchMethod,
                    );
                    newsSearchInstance.fetchSearchRun(startOver: true);
                    Navigator.pop(context);
                  }
                },
                icon: Icon(Icons.search),
              ),
            ),
          ],
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              ExpandableChoice<NewsType>(
                title: AppLocalizations.of(context).translate("news_search_searchoption_type"),
                currentValue: _newsType,
                hideCurrentValueIfExpanded: false,
                isExpanded: _newsTypeComboBoxShown,
                valueList: [
                  ExpandableChoiceItem(
                    text: AppLocalizations.of(context).translate("news_search_searchoption_type_byglobal"),
                    value: NewsType.global,
                  ),
                  ExpandableChoiceItem(
                    text: AppLocalizations.of(context).translate("news_search_searchoption_type_bysubject"),
                    value: NewsType.subject,
                  ),
                  ExpandableChoiceItem(
                    text: AppLocalizations.of(context).translate("news_search_searchoption_type_bystudentaffairs"),
                    value: NewsType.studentAffairs,
                  ),
                  ExpandableChoiceItem(
                    text: AppLocalizations.of(context).translate("news_search_searchoption_type_byexamination"),
                    value: NewsType.examination,
                  ),
                  ExpandableChoiceItem(
                    text: AppLocalizations.of(context).translate("news_search_searchoption_type_bytuitionfee"),
                    value: NewsType.tuitionFee,
                  ),
                  ExpandableChoiceItem(
                    text: AppLocalizations.of(context).translate("news_search_searchoption_type_bystatuteregulation"),
                    value: NewsType.statuteRegulation,
                  ),
                ],
                onExpandChanged: (shown) => setState(() {
                  _newsTypeComboBoxShown = shown;
                  _newsSearchMethodComboBoxShown = false;
                }),
                onClick: (newsType) => setState(() {
                  _newsType = newsType;
                  _newsTypeComboBoxShown = false;
                }),
              ),
              SizedBox(height: 5),
              ExpandableChoice<NewsSearchMethod>(
                title: AppLocalizations.of(context).translate("news_search_searchoption_method"),
                currentValue: _searchMethod,
                hideCurrentValueIfExpanded: false,
                isExpanded: _newsSearchMethodComboBoxShown,
                valueList: [
                  ExpandableChoiceItem(
                    text: AppLocalizations.of(context).translate("news_search_searchoption_method_bytitle"),
                    value: NewsSearchMethod.byTitle,
                  ),
                  ExpandableChoiceItem(
                    text: AppLocalizations.of(context).translate("news_search_searchoption_method_bycontent"),
                    value: NewsSearchMethod.byContent,
                  ),
                ],
                onExpandChanged: (shown) => setState(() {
                  _newsTypeComboBoxShown = false;
                  _newsSearchMethodComboBoxShown = shown;
                }),
                onClick: (newsSearchMethod) => setState(() {
                  _searchMethod = newsSearchMethod;
                  _newsSearchMethodComboBoxShown = false;
                }),
              ),
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    AppLocalizations.of(context).translate("news_search_searchoption_history"),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      newsSearchInstance.clearHistory();
                    },
                  ),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 5, bottom: 10),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      spacing: 3,
                      children: List.generate(
                        newsSearchInstance.newsHistoryList.length,
                        (index) => NewsSearchHistoryItem(
                          query: newsSearchInstance.newsHistoryList.elementAt(index).query,
                          newsType: newsSearchInstance.newsHistoryList.elementAt(index).newsType,
                          searchMethod: newsSearchInstance.newsHistoryList.elementAt(index).searchMethod,
                          shouldRadiusOnTop: index == 0,
                          shouldRadiusOnBottom: index == (newsSearchInstance.newsHistoryList.length - 1),
                          onClick: () {
                            newsSearchInstance.changeNewsSearchOption(
                              query: newsSearchInstance.newsHistoryList.elementAt(index).query,
                              newsType: newsSearchInstance.newsHistoryList.elementAt(index).newsType,
                              searchMethod: newsSearchInstance.newsHistoryList.elementAt(index).searchMethod,
                            );
                            newsSearchInstance.fetchSearchRun(startOver: true);
                            Navigator.pop(context);
                          },
                        ),
                      ),
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
