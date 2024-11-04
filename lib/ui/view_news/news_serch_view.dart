import 'package:dutwrapper/enums.dart';
import 'package:dutwrapper/news_object.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/process_state.dart';
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
        title: TextField(
          controller: TextEditingController(text: newsSearchInstance.searchQuery),
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: "Type here to search",
          ),
          readOnly: true,
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
            newsSearchInstance.newsSearchQueryTextControl.clear();
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: IconButton(
              onPressed: () {},
              icon: Icon(Icons.search),
            ),
          ),
        ],
      ),
      body: newsSearchInstance.searchResult.data.isNotEmpty
          ? _haveResults(
              context: context,
              newsList: newsSearchInstance.searchResult.data,
              isRefreshing: newsSearchInstance.searchResult.state == ProcessState.running,
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
          : newsSearchInstance.searchResult.state == ProcessState.notRunYet
              ? _notRunYet(context)
              : _noAnyResult(context),
    );
  }

  Widget _notRunYet(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          Spacer(),
          Text("Tap search box at the top of screen to continue."),
          Spacer(),
        ],
      ),
    );
  }

  Widget _noAnyResult(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          Spacer(),
          Text("No results."),
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
