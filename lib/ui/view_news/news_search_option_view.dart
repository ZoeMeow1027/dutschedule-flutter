import 'package:dutwrapper/enums.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodel/news_search_instance.dart';
import '../components/widget_news/news_search_history_item.dart';

class NewsSearchOptionView extends StatelessWidget {
  const NewsSearchOptionView({super.key});

  @override
  Widget build(BuildContext context) {
    final newsSearchInstance = Provider.of<NewsSearchInstance>(context);

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: newsSearchInstance.newsSearchQueryTextControl,
          onChanged: (text) => newsSearchInstance.changeNewsSearchOption(query: text),
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: "Type here to search",
          ),
        ),
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: IconButton(
              onPressed: () {
                if (newsSearchInstance.searchQueryTemp.isNotEmpty) {
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
            Text(
              "News type",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Container(
              padding: const EdgeInsets.only(top: 5, bottom: 10, left: 15, right: 15),
              width: double.infinity,
              child: SegmentedButton<NewsType>(
                segments: <ButtonSegment<NewsType>>[
                  ButtonSegment(value: NewsType.global, label: Text("Global news")),
                  ButtonSegment(value: NewsType.subject, label: Text("Subject news")),
                ],
                selected: <NewsType>{newsSearchInstance.newsType},
                onSelectionChanged: (value) => newsSearchInstance.changeNewsSearchOption(newsType: value.first),
              ),
            ),
            Text(
              "Search by",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Container(
              padding: const EdgeInsets.only(top: 5, bottom: 10, left: 15, right: 15),
              width: double.infinity,
              child: SegmentedButton<NewsSearchMethod>(
                segments: <ButtonSegment<NewsSearchMethod>>[
                  ButtonSegment(value: NewsSearchMethod.byTitle, label: Text("By title")),
                  ButtonSegment(value: NewsSearchMethod.byContent, label: Text("By content")),
                ],
                selected: <NewsSearchMethod>{newsSearchInstance.searchMethod},
                onSelectionChanged: (value) => newsSearchInstance.changeNewsSearchOption(searchMethod: value.first),
              ),
            ),
            Text(
              "Search history",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 5, bottom: 10),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: List.generate(
                      newsSearchInstance.newsHistoryList.length,
                      (index) => NewsSearchHistoryItem(
                        query: newsSearchInstance.newsHistoryList.elementAt(index).query,
                        newsType: newsSearchInstance.newsHistoryList.elementAt(index).newsType,
                        searchMethod: newsSearchInstance.newsHistoryList.elementAt(index).searchMethod,
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
    );
  }
}
