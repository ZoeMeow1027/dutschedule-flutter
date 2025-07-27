import 'package:dutschedule/model/enum/news_fetching_type.dart';
import 'package:dutschedule/viewmodel/news_cache_instance_v2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('1', () async {
    NewsCacheInstanceV2 nci2 = NewsCacheInstanceV2();

    debugPrint('Fetching... Please wait...');
    await nci2.fetchNewsGlobal(
      fetchType: NewsFetchingType.clearAndFetchAllNews,
      onDone: (po) {
        debugPrint('News count: ${nci2.newsGlobal.data.length}');
      },
    );
  });
}
