import 'package:dutschedule/utils/build_context_extension.dart';
import 'package:dutwrapper/news_object.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../model/process_state.dart';
import '../../../viewmodel/main_view_model.dart';
import '../../../viewmodel/news_cache_instance.dart';
import '../../../viewmodel/news_search_instance.dart';
import '../../components/widget_news/news_list.dart';
import '../../../model/enum/news_tab_location.dart';
import '../../view_news/news_search_view.dart';

class NewsSummaryListView extends StatelessWidget {
  const NewsSummaryListView({
    super.key,
    this.onClick,
  });

  final Function(NewsGlobal, bool)? onClick;

  @override
  Widget build(BuildContext context) {
    final mainViewModel = Provider.of<MainViewModel>(context);
    final newsCacheInstance = Provider.of<NewsCacheInstance>(context);
    final newsSearchInstance = Provider.of<NewsSearchInstance>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("News"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: IconButton(
              onPressed: () async {
                newsSearchInstance.resetQueryAndResult();
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NewsSearchView()),
                );
              },
              icon: Icon(Icons.search),
            ),
          )
        ],
      ),
      body: Scaffold(
        body: PageView(
          controller: mainViewModel.newsPageController,
          physics: const AlwaysScrollableScrollPhysics(),
          onPageChanged: (page) {
            mainViewModel.setNewsCurrentPage(
              selectedPage: page == 0 ? NewsTabLocation.globalNews : NewsTabLocation.subjectNews,
            );
          },
          children: [
            NewsList(
              newsList: newsCacheInstance.newsGlobal.data,
              isRefreshing: newsCacheInstance.newsGlobal.state == ProcessState.running,
              onClick: (news) {
                onClick?.call(news, false);
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
                  context.clearSnackBars();
                  context.showSnackBar(const SnackBar(
                    content: Text(
                        "We ran into a issue prevent you refreshing news. Please try again or check your internet connection."),
                  ));
                }
              },
            ),
            NewsList(
              newsList: newsCacheInstance.newsSubject.data,
              isRefreshing: newsCacheInstance.newsSubject.state == ProcessState.running,
              onClick: (news) {
                onClick?.call(news, true);
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
                  context.clearSnackBars();
                  context.showSnackBar(const SnackBar(
                    content: Text(
                        "We ran into a issue prevent you refreshing news. Please try again or check your internet connection."),
                  ));
                }
              },
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: ((mainViewModel.newsCurrentPage == NewsTabLocation.globalNews &&
                      newsCacheInstance.newsGlobal.state == ProcessState.running) ||
                  (mainViewModel.newsCurrentPage == NewsTabLocation.subjectNews &&
                      newsCacheInstance.newsSubject.state == ProcessState.running))
              ? SizedBox(
                  width: 25,
                  height: 25,
                  child: CircularProgressIndicator(),
                )
              : const Icon(Icons.refresh),
          onPressed: () {
            try {
              switch (mainViewModel.newsCurrentPage) {
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
              }
            } catch (ex) {
              context.clearSnackBars();
              context.showSnackBar(const SnackBar(
                content: Text(
                    "We ran into a issue prevent you refreshing news. Please try again or check your internet connection."),
              ));
            }
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endContained,
        bottomNavigationBar: Padding(
          padding: EdgeInsets.only(right: 60),
          child: BottomAppBar(
            color: Colors.transparent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SegmentedButton<NewsTabLocation>(
                  segments: const [
                    ButtonSegment(
                      value: NewsTabLocation.globalNews,
                      label: Text("Global"),
                    ),
                    ButtonSegment(
                      value: NewsTabLocation.subjectNews,
                      label: Text("Subject"),
                    ),
                  ],
                  selected: <NewsTabLocation>{mainViewModel.newsCurrentPage},
                  onSelectionChanged: (selected) {
                    // setState(() {
                    //   // By default there is only a single segment that can be
                    //   // selected at one time, so its value is always the first
                    //   // item in the selected set.
                    //   _currentPage = selected.first;
                    //
                    //   _pageController.animateToPage(
                    //     _currentPage.value,
                    //     duration: const Duration(milliseconds: 400),
                    //     curve: Curves.fastOutSlowIn,
                    //   );
                    // });
                    mainViewModel.setNewsCurrentPage(selectedPage: selected.first);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
