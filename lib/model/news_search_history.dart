import 'package:dutwrapper/enums.dart';

class NewsSearchHistory {
  final String query;
  final NewsType newsType;
  final NewsSearchMethod searchMethod;
  final int lastRequest;

  const NewsSearchHistory({
    required this.query,
    required this.newsType,
    required this.searchMethod,
    required this.lastRequest,
  });

  NewsSearchHistory.fromJson(Map<String, dynamic> json)
      : query = json["query"] as String? ?? "",
        newsType =
            NewsType.values.where((p) => (p.value == (json["news_type"] as int? ?? 0))).firstOrNull ?? NewsType.global,
        searchMethod =
            NewsSearchMethod.values.where((p) => (p.value == (json["search_method"] as int? ?? 0))).firstOrNull ??
                NewsSearchMethod.byTitle,
        lastRequest = json["last_request"] as int? ?? 0;

  Map<String, dynamic> toJson() {
    return {
      "query": query,
      "news_type": newsType.value,
      "search_method": searchMethod.value,
      "last_request": lastRequest,
    };
  }

  bool equals(NewsSearchHistory value) {
    return query == value.query && newsType == value.newsType && searchMethod == value.searchMethod;
  }
}
