import 'package:dutwrapper/news_object.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../l10n/app_localizations.dart';
import '../../../model/enum/news_fetching_type.dart';
import '../../../model/enum/news_tab_location.dart';
import '../../../utils/build_context_extension.dart';
import '../../../viewmodel/news_cache_instance_v2.dart';
import '../../../viewmodel/news_search_instance.dart';
import '../../components/widget_news/news_list.dart';
import '../../view_news/news_search_view.dart';
import '../../view_settings/settings_view.dart';

class NewsSummaryListView extends StatefulWidget {
  const NewsSummaryListView({
    super.key,
    this.onClick,
  });

  final Function(NewsCore, bool)? onClick;

  @override
  State<StatefulWidget> createState() => _NewsSummaryListView();
}

class _NewsSummaryListView extends State<NewsSummaryListView> with TickerProviderStateMixin {
  late NewsTabLocation _newsCurrentPage;
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _newsCurrentPage = NewsTabLocation.globalNews;
    _tabController = TabController(length: 6, vsync: this);
    _tabController.addListener(_newsTabChanged);
  }

  @override
  void dispose() {
    _tabController.removeListener(_newsTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  void _newsTabChanged() {
    setState(() {
      _newsCurrentPage = switch (_tabController.index) {
        0 => NewsTabLocation.globalNews,
        1 => NewsTabLocation.subjectNews,
        2 => NewsTabLocation.studentAffairs,
        3 => NewsTabLocation.examination,
        4 => NewsTabLocation.tuitionFee,
        5 => NewsTabLocation.statuteRegulation,
        _ => NewsTabLocation.globalNews,
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    final newsCacheInstance = Provider.of<NewsCacheInstanceV2>(context);
    final newsSearchInstance = Provider.of<NewsSearchInstance>(context);

    bool shouldFABRunning() {
      return switch (_newsCurrentPage) {
        NewsTabLocation.globalNews => newsCacheInstance.newsGlobal.isRunning,
        NewsTabLocation.subjectNews => newsCacheInstance.newsSubject.isRunning,
        NewsTabLocation.studentAffairs => newsCacheInstance.newsStudentAffairs.isRunning,
        NewsTabLocation.examination => newsCacheInstance.newsExamination.isRunning,
        NewsTabLocation.tuitionFee => newsCacheInstance.newsTuition.isRunning,
        NewsTabLocation.statuteRegulation => newsCacheInstance.newsStatuteRegulation.isRunning,
      };
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate("news_title")),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: FilledButton.tonalIcon(
              onPressed: () async {
                newsSearchInstance.resetQueryAndResult();
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NewsSearchView()),
                );
              },
              icon: Icon(Icons.search, size: 26),
              label: Text(AppLocalizations.of(context).translate("main_news_searchnews")),
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsView()),
              );
            },
            icon: const Icon(Icons.settings),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              child: Text(
                AppLocalizations.of(context).translate("news_tabname_global"),
                textAlign: TextAlign.center,
              ),
            ),
            Tab(
              child: Text(
                AppLocalizations.of(context).translate("news_tabname_subject"),
                textAlign: TextAlign.center,
              ),
            ),
            Tab(
              child: Text(
                AppLocalizations.of(context).translate("news_tabname_studentaffairs"),
                textAlign: TextAlign.center,
              ),
            ),
            Tab(
              child: Text(
                AppLocalizations.of(context).translate("news_tabname_examination"),
                textAlign: TextAlign.center,
              ),
            ),
            Tab(
              child: Text(
                AppLocalizations.of(context).translate("news_tabname_tuition"),
                textAlign: TextAlign.center,
              ),
            ),
            Tab(
              child: Text(
                AppLocalizations.of(context).translate("news_tabname_statuteregulation"),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 2, color: Theme.of(context).colorScheme.primary),
          borderRadius: BorderRadius.circular(20),
        ),
        child: shouldFABRunning()
            ? SizedBox(
                width: 25,
                height: 25,
                child: CircularProgressIndicator(),
              )
            : const Icon(Icons.refresh),
        onPressed: () {
          try {
            switch (_newsCurrentPage) {
              case NewsTabLocation.globalNews:
                newsCacheInstance.fetchNewsGlobal(
                  fetchType: NewsFetchingType.clearAndFetchFirstNewsPage,
                  forceRequest: true,
                );
                break;
              case NewsTabLocation.subjectNews:
                newsCacheInstance.fetchNewsSubject(
                  fetchType: NewsFetchingType.clearAndFetchFirstNewsPage,
                  forceRequest: true,
                );
                break;
              case NewsTabLocation.studentAffairs:
                newsCacheInstance.fetchNewsStudentAffairs(
                  fetchType: NewsFetchingType.clearAndFetchFirstNewsPage,
                  forceRequest: true,
                );
                break;
              case NewsTabLocation.examination:
                newsCacheInstance.fetchNewsExamination(
                  fetchType: NewsFetchingType.clearAndFetchFirstNewsPage,
                  forceRequest: true,
                );
                break;
              case NewsTabLocation.tuitionFee:
                newsCacheInstance.fetchNewsTuitionFee(
                  fetchType: NewsFetchingType.clearAndFetchFirstNewsPage,
                  forceRequest: true,
                );
                break;
              case NewsTabLocation.statuteRegulation:
                newsCacheInstance.fetchNewsStatuteRegulation(
                  fetchType: NewsFetchingType.clearAndFetchFirstNewsPage,
                  forceRequest: true,
                );
                break;
            }
          } catch (ex) {
            context.showCustomSnackBar(
              content: Text(AppLocalizations.of(context).translate("news_search_failed")),
              dismissOld: true,
            );
          }
        },
      ),
      body: TabBarView(
        controller: _tabController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          NewsList(
            newsList: newsCacheInstance.newsGlobal.data,
            isRefreshing: newsCacheInstance.newsGlobal.isRunning,
            isEndOfList: newsCacheInstance.newsGlobal.isEndOfList,
            onClick: (news) {
              widget.onClick?.call(news, false);
            },
            endListReached: () {
              newsCacheInstance.fetchNewsGlobal(
                fetchType: NewsFetchingType.nextPage,
                forceRequest: true,
              );
            },
            refreshRequested: () {
              try {
                newsCacheInstance.fetchNewsGlobal(
                  fetchType: NewsFetchingType.clearAndFetchFirstNewsPage,
                  forceRequest: true,
                );
              } catch (ex) {
                context.showCustomSnackBar(
                  content: Text(AppLocalizations.of(context).translate("news_search_failed")),
                  dismissOld: true,
                );
              }
            },
          ),
          NewsList(
            newsList: newsCacheInstance.newsSubject.data,
            isRefreshing: newsCacheInstance.newsSubject.isRunning,
            isEndOfList: newsCacheInstance.newsSubject.isEndOfList,
            onClick: (news) {
              widget.onClick?.call(news, true);
            },
            endListReached: () {
              newsCacheInstance.fetchNewsSubject(
                fetchType: NewsFetchingType.nextPage,
                forceRequest: true,
              );
            },
            refreshRequested: () {
              try {
                newsCacheInstance.fetchNewsSubject(
                  fetchType: NewsFetchingType.clearAndFetchFirstNewsPage,
                  forceRequest: true,
                );
              } catch (ex) {
                context.showCustomSnackBar(
                  content: Text(AppLocalizations.of(context).translate("news_search_failed")),
                  dismissOld: true,
                );
              }
            },
          ),
          NewsList(
            newsList: newsCacheInstance.newsStudentAffairs.data,
            isRefreshing: newsCacheInstance.newsStudentAffairs.isRunning,
            isEndOfList: newsCacheInstance.newsStudentAffairs.isEndOfList,
            onClick: (news) {
              widget.onClick?.call(news, false);
            },
            endListReached: () {
              newsCacheInstance.fetchNewsStudentAffairs(
                fetchType: NewsFetchingType.nextPage,
                forceRequest: true,
              );
            },
            refreshRequested: () {
              try {
                newsCacheInstance.fetchNewsStudentAffairs(
                  fetchType: NewsFetchingType.clearAndFetchFirstNewsPage,
                  forceRequest: true,
                );
              } catch (ex) {
                context.showCustomSnackBar(
                  content: Text(AppLocalizations.of(context).translate("news_search_failed")),
                  dismissOld: true,
                );
              }
            },
          ),
          NewsList(
            newsList: newsCacheInstance.newsExamination.data,
            isRefreshing: newsCacheInstance.newsExamination.isRunning,
            isEndOfList: newsCacheInstance.newsExamination.isEndOfList,
            onClick: (news) {
              widget.onClick?.call(news, false);
            },
            endListReached: () {
              newsCacheInstance.fetchNewsExamination(
                fetchType: NewsFetchingType.nextPage,
                forceRequest: true,
              );
            },
            refreshRequested: () {
              try {
                newsCacheInstance.fetchNewsExamination(
                  fetchType: NewsFetchingType.clearAndFetchFirstNewsPage,
                  forceRequest: true,
                );
              } catch (ex) {
                context.showCustomSnackBar(
                  content: Text(AppLocalizations.of(context).translate("news_search_failed")),
                  dismissOld: true,
                );
              }
            },
          ),
          NewsList(
            newsList: newsCacheInstance.newsTuition.data,
            isRefreshing: newsCacheInstance.newsTuition.isRunning,
            isEndOfList: newsCacheInstance.newsTuition.isEndOfList,
            onClick: (news) {
              widget.onClick?.call(news, false);
            },
            endListReached: () {
              newsCacheInstance.fetchNewsTuitionFee(
                fetchType: NewsFetchingType.nextPage,
                forceRequest: true,
              );
            },
            refreshRequested: () {
              try {
                newsCacheInstance.fetchNewsTuitionFee(
                  fetchType: NewsFetchingType.clearAndFetchFirstNewsPage,
                  forceRequest: true,
                );
              } catch (ex) {
                context.showCustomSnackBar(
                  content: Text(AppLocalizations.of(context).translate("news_search_failed")),
                  dismissOld: true,
                );
              }
            },
          ),
          NewsList(
            newsList: newsCacheInstance.newsStatuteRegulation.data,
            isRefreshing: newsCacheInstance.newsStatuteRegulation.isRunning,
            isEndOfList: newsCacheInstance.newsStatuteRegulation.isEndOfList,
            onClick: (news) {
              widget.onClick?.call(news, false);
            },
            endListReached: () {
              newsCacheInstance.fetchNewsStatuteRegulation(
                fetchType: NewsFetchingType.nextPage,
                forceRequest: true,
              );
            },
            refreshRequested: () {
              try {
                newsCacheInstance.fetchNewsStatuteRegulation(
                  fetchType: NewsFetchingType.clearAndFetchFirstNewsPage,
                  forceRequest: true,
                );
              } catch (ex) {
                context.showCustomSnackBar(
                  content: Text(AppLocalizations.of(context).translate("news_search_failed")),
                  dismissOld: true,
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
