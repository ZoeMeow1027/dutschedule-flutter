import 'package:dutwrapper/enums.dart';
import 'package:dutwrapper/news_object.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/process_state.dart';
import '../../utils/app_localizations.dart';
import '../../utils/string_utils.dart';
import '../../viewmodel/news_search_instance.dart';
import '../components/widget_news/news_list.dart';
import 'news_detail_view.dart';
import 'news_search_option_view.dart';

class NewsSearchView extends StatelessWidget {
  const NewsSearchView({super.key});

  @override
  Widget build(BuildContext context) {
    final newsSearchInstance = Provider.of<NewsSearchInstance>(context);

    return Scaffold(
      appBar: AppBar(
        title: _titleBar(
            context: context,
            newsSearchInstance: newsSearchInstance,
            onTap: () async {
              newsSearchInstance.newsSearchQueryTextControl.clear();
              await Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) => NewsSearchOptionView(),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    final fadeInOut = CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeInOut,
                    );

                    return FadeTransition(
                      opacity: fadeInOut,
                      child: child,
                    );
                  },
                ),
              );
            }),
        actions: [
          newsSearchInstance.searchQuery.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: IconButton(
                    onPressed: () async {
                      newsSearchInstance.newsSearchQueryTextControl.clear();
                      await Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation, secondaryAnimation) => NewsSearchOptionView(),
                          transitionsBuilder: (context, animation, secondaryAnimation, child) {
                            final fadeInOut = CurvedAnimation(
                              parent: animation,
                              curve: Curves.easeInOut,
                            );

                            return FadeTransition(
                              opacity: fadeInOut,
                              child: child,
                            );
                          },
                        ),
                      );
                    },
                    icon: newsSearchInstance.searchProcessState == ProcessState.running
                        ? SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(),
                          )
                        : Icon(Icons.search),
                  ),
                )
              : Container(),
        ],
      ),
      body: newsSearchInstance.searchResult.isNotEmpty
          ? _haveResults(
              context: context,
              newsList: newsSearchInstance.searchResult,
              isRefreshing: newsSearchInstance.searchProcessState == ProcessState.running,
              endListReached: () => newsSearchInstance.fetchSearchRun(),
              refreshRequired: () => newsSearchInstance.fetchSearchRun(startOver: true),
              onClick: (news) async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NewsDetailView(
                      newsItem: news,
                      isNewsSubject: newsSearchInstance.newsType == NewsType.global,
                    ),
                  ),
                );
              },
            )
          : newsSearchInstance.searchProcessState == ProcessState.running
              ? _loading(context)
              : newsSearchInstance.searchProcessState == ProcessState.notRunYet
                  ? _notRunYet(context)
                  : _noAnyResult(context),
    );
  }

  Widget _titleBar({
    required BuildContext context,
    required NewsSearchInstance newsSearchInstance,
    Function()? onTap,
  }) {
    if (newsSearchInstance.searchProcessState != ProcessState.notRunYet) {
      return InkWell(
        onTap: onTap,
        child: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                newsSearchInstance.searchQuery.isNotEmpty
                    ? newsSearchInstance.searchQuery
                    : AppLocalizations.of(context).translate("data_nodata"),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Text(
                StringUtils.capitalizeFirstLetter(StringUtils.formatString(
                  AppLocalizations.of(context).translate("news_search_searchoption_history_data"),
                  [
                    newsSearchInstance.searchMethod == NewsSearchMethod.byTitle
                        ? AppLocalizations.of(context).translate("news_search_searchoption_method_bytitle")
                        : AppLocalizations.of(context).translate("news_search_searchoption_method_bycontent"),
                    newsSearchInstance.newsType == NewsType.global
                        ? AppLocalizations.of(context).translate("news_search_searchoption_type_byglobal")
                        : AppLocalizations.of(context).translate("news_search_searchoption_type_bysubject"),
                  ],
                )),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      );
    } else {
      return TextField(
        controller: TextEditingController(text: newsSearchInstance.searchQuery),
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: AppLocalizations.of(context).translate("news_search_searchbox_placeholder"),
        ),
        readOnly: true,
        onTap: onTap,
      );
    }
  }

  Widget _notRunYet(BuildContext context) {
    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: [
          Spacer(),
          Text(
            AppLocalizations.of(context).translate("news_search_getstarted"),
            textAlign: TextAlign.center,
          ),
          Spacer(),
        ],
      ),
    );
  }

  Widget _noAnyResult(BuildContext context) {
    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: [
          Spacer(),
          Text(
            AppLocalizations.of(context).translate("news_search_noavailablenews"),
            textAlign: TextAlign.center,
          ),
          Spacer(),
        ],
      ),
    );
  }

  Widget _loading(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          Spacer(),
          CircularProgressIndicator(),
          Spacer(),
        ],
      ),
    );
  }

  Widget _haveResults({
    required BuildContext context,
    required List<NewsGlobal> newsList,
    bool isRefreshing = false,
    Function()? endListReached,
    Function()? refreshRequired,
    Function(NewsGlobal)? onClick,
  }) {
    return SizedBox(
      width: double.infinity,
      child: NewsList(
        newsList: newsList,
        isRefreshing: isRefreshing,
        endListReached: endListReached,
        onClick: onClick,
        refreshRequested: refreshRequired,
        showDateInHeader: false,
      ),
    );
  }
}
