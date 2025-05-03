import 'package:dutwrapper/news_object.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../model/enum/news_tab_location.dart';
import '../../../model/process_state.dart';
import '../../../utils/app_localizations.dart';
import '../../../utils/build_context_extension.dart';
import '../../../viewmodel/news_cache_instance.dart';
import '../../../viewmodel/news_search_instance.dart';
import '../../components/widget_news/news_list.dart';
import '../../view_news/news_search_view.dart';
import '../../view_settings/settings_view.dart';

class NewsSummaryListView extends StatefulWidget {
  const NewsSummaryListView({
    super.key,
    this.onClick,
  });

  final Function(NewsGlobal, bool)? onClick;

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
    _tabController = TabController(length: 5, vsync: this);
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
        _ => NewsTabLocation.globalNews,
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    final newsCacheInstance = Provider.of<NewsCacheInstance>(context);
    final newsSearchInstance = Provider.of<NewsSearchInstance>(context);

    bool shouldFABRunning() {
      return switch (_newsCurrentPage) {
        NewsTabLocation.globalNews => newsCacheInstance.newsGlobal.state == ProcessState.running,
        NewsTabLocation.subjectNews => newsCacheInstance.newsSubject.state == ProcessState.running,
        _ => false,
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
            Tab(icon: Icon(Icons.cloud_outlined)),
            Tab(icon: Icon(Icons.cloud_outlined)),
            Tab(icon: Icon(Icons.cloud_outlined)),
            Tab(icon: Icon(Icons.cloud_outlined)),
            Tab(icon: Icon(Icons.cloud_outlined)),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endContained,
      floatingActionButton: FloatingActionButton(
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
                newsCacheInstance.fetchGlobalNews(
                  fetchType: NewsFetchType.clearCacheAndFirstPage,
                  forceRequest: true,
                );
                break;
              case NewsTabLocation.subjectNews:
                newsCacheInstance.fetchSubjectNews(
                  fetchType: NewsFetchType.clearCacheAndFirstPage,
                  forceRequest: true,
                );
                break;
              default:
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
        children: [
          NewsList(
            newsList: newsCacheInstance.newsGlobal.data,
            isRefreshing: newsCacheInstance.newsGlobal.state == ProcessState.running,
            onClick: (news) {
              widget.onClick?.call(news, false);
            },
            endListReached: () {
              newsCacheInstance.fetchGlobalNews(
                fetchType: NewsFetchType.nextPage,
                forceRequest: true,
              );
            },
            refreshRequested: () {
              try {
                newsCacheInstance.fetchGlobalNews(
                  fetchType: NewsFetchType.clearCacheAndFirstPage,
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
            isRefreshing: newsCacheInstance.newsSubject.state == ProcessState.running,
            onClick: (news) {
              widget.onClick?.call(news, true);
            },
            endListReached: () {
              newsCacheInstance.fetchSubjectNews(
                fetchType: NewsFetchType.nextPage,
                forceRequest: true,
              );
            },
            refreshRequested: () {
              try {
                newsCacheInstance.fetchSubjectNews(
                  fetchType: NewsFetchType.clearCacheAndFirstPage,
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
          // TODO: Add news here
          Center(child: Text("It's cloudy here")),
          Center(child: Text("It's rainy here")),
          Center(child: Text("It's sunny here")),
        ],
      ),
    );
  }
}
