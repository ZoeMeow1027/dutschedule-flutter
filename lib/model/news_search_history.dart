import 'package:dutwrapper/enums.dart';

class NewsSearchHistory {
  final String query;
  final NewsType newsType;
  final NewsSearchMethod searchMethod;

  const NewsSearchHistory({
    required this.query,
    required this.newsType,
    required this.searchMethod,
  });

  bool equals(NewsSearchHistory value) {
    return query == value.query && newsType == value.newsType && searchMethod == value.searchMethod;
  }
}
