import 'package:dutwrapper/enums.dart';
import 'package:dutwrapper/news.dart';
import 'package:dutwrapper/news_object.dart';

import '../model/enum/news_fetching_type.dart';
import '../model/enum/process_state.dart';
import '../model/news_data.dart';
import '../utils/app_utils.dart';
import 'base_view_model.dart';

class NewsCacheInstance2 extends BaseViewModel {
  @override
  void initializing() {}

  @override
  void timerAction() {}

  NewsData<NewsCore> newsGlobal = NewsData<NewsCore>();
  NewsData<NewsCore> newsSubject = NewsData<NewsCore>();
  NewsData<NewsCore> newsStudentAffairs = NewsData<NewsCore>();
  NewsData<NewsCore> newsExamination = NewsData<NewsCore>();
  NewsData<NewsCore> newsTuitions = NewsData<NewsCore>();
  NewsData<NewsCore> newsStatuteRegulation = NewsData<NewsCore>();

  Future<void> _fetchNews({
    required NewsType newsType,
    NewsFetchingType fetchType = NewsFetchingType.nextPage,
    bool forceRequest = false,
    Function(bool)? onDone,
    required NewsData<NewsCore> newsData,
    String debugSubTag = '',
  }) async {
    if (!newsData.isSuccessfulRequestExpired && !forceRequest) {
      AppUtils.showLogToDebug(
        resultTag: AppLogLevel.warning,
        tag: 'News',
        subTag: debugSubTag,
        message: 'Denied this task because of timeout. Force this request to continue.',
      );
      return;
    }
    if (newsData.isRunning) {
      AppUtils.showLogToDebug(
        resultTag: AppLogLevel.warning,
        tag: 'News',
        subTag: debugSubTag,
        message: 'Denied this task because another same task is running...',
      );
      return;
    }

    // if (!newsData.isEndOfList && fetchType == NewsFetchingType.firstPage) {
    //   AppUtils.showLogToDebug(
    //     resultTag: AppLogLevel.warning,
    //     tag: 'News',
    //     subTag: debugSubTag,
    //     message: "You need to fetch all news first. To do this, set 'fetchType' to 'NewsFetchingType.clearAndAllNews'.",
    //   );
    //   return;
    // }

    newsData.processState = ProcessState.running;
    notifyListeners();

    AppUtils.showLogToDebug(
      resultTag: AppLogLevel.info,
      tag: 'News',
      subTag: debugSubTag,
      message: "Running...",
    );

    try {
      // Fetch next page.
      if (fetchType == NewsFetchingType.nextPage) {
        // If 'isEndOfList' is true, just stop it.
        if (newsData.isEndOfList) {
          throw Exception(
              'You\'re reached "end of list" of this news. Clear and fetch first news to use this feature.');
        }

        // This will store temporary news.
        List<NewsCore> newsList = [];

        // Get 'nextPage' parameter.
        // Just confirm no news in temporary list.
        newsList.clear();

        // Fetch news with 'nextPage' parameter to temporary list.
        newsList.addAll(await News.getNews(newsType: newsType, page: newsData.nextPage));

        // Add to current list.
        newsData.data.addAll(newsList);

        // Increase 'nextPage' parameter.
        newsData.nextPage = newsData.nextPage + 1;

        // Set 'isEndOfList' to true if newsList fetched before is less than 30 items.
        if (newsList.length < 30) newsData.isEndOfList = true;

        // Clear 'newsList'
        newsList.clear();
      }
      // Clear cache and fetch first news page.
      else if (fetchType == NewsFetchingType.clearAndFetchFirstNewsPage) {
        // Set 'nextPage' parameter to 1 to begin fetching.
        newsData.nextPage = 1;

        // This will store temporary news.
        List<NewsCore> newsList = [];

        // Get 'nextPage' parameter.
        // Just confirm no news in temporary list.
        newsList.clear();

        // Fetch news with 'nextPage' parameter to temporary list.
        newsList.addAll(await News.getNews(newsType: newsType, page: newsData.nextPage));

        // Clear old news
        newsData.data.clear();
        // Add to current list.
        newsData.data.addAll(newsList);

        // Increase 'nextPage' parameter.
        newsData.nextPage = newsData.nextPage + 1;

        // Set 'isEndOfList' to true if newsList fetched before is less than 30 items.
        if (newsList.length < 30) newsData.isEndOfList = true;

        // Clear 'newsList'
        newsList.clear();
      }
      // Clear cache immediately fetch all news.
      else if (fetchType == NewsFetchingType.clearAndFetchAllNews) {
        // Set 'nextPage' parameter to 1 to begin fetching.
        newsData.nextPage = 1;

        // Clear old news
        newsData.data.clear();

        // This will store temporary news.
        List<NewsCore> newsList = [];

        // This variable for if loop should continue.
        bool shouldContinue = true;

        // If shouldContinue is true, just continue.
        while (shouldContinue) {
          // Get 'nextPage' parameter.
          // Just confirm no news in temporary list.
          newsList.clear();

          // Fetch news with 'nextPage' parameter to temporary list.
          newsList.addAll(await News.getNews(newsType: newsType, page: newsData.nextPage));

          // TEST HERE: Reduce loading - Method 1: Limit all news to 30 days.
          // Current date time in unix timestamp.
          // int currentDateUnix = DateTime.now().toUtc().millisecondsSinceEpoch;
          // // 30 days
          // int durationShouldRemove = 30 * 24 * 60 * 60 * 1000;
          // // Remove all news too old (with currentDatUnix - durationShouldRemove > newsDate)
          // newsList.removeWhere((p) => (currentDateUnix - durationShouldRemove > p.datePublished));

          // Add to current list.
          newsData.data.addAll(newsList);
          // Clear temporary list.
          newsList.clear();

          // Check if loop should continue.
          if (!(newsData.nextPage == 1 || newsList.length != 30)) {
            shouldContinue = false;
          }

          // TEST HERE: Reduce loading - Method 2: Limit news page to 5
          // if (newsData.nextPage >= 5) {
          //   shouldContinue = false;
          // }

          // Increase 'nextPage' parameter.
          newsData.nextPage = newsData.nextPage + 1;
        }

        // Set 'isEndOfList' to 1 to prevent more fetching last page.
        newsData.isEndOfList = true;
      }
      // Fetch only first news page.
      else if (fetchType == NewsFetchingType.firstPage) {
        // This will store temporary news.
        List<NewsCore> newsList = [];
        // This will store filtered temporary news.
        List<NewsCore> newsListFiltered = [];

        // Fetch news with '1' parameter to temporary list.
        newsList.addAll(await News.getNews(newsType: newsType, page: 1));

        // Find in current list to find new news, and add them to filtered list.
        for (var newsItem in newsList) {
          if (newsData.data.any((p) => AppUtils.isNewsEqual(p, newsItem))) {
            newsListFiltered.add(newsItem);
          }
        }

        // Add temporary list to current list.
        newsData.data.insertAll(0, newsListFiltered);

        // Sort news by date (older news date will below newer news date).
        newsData.data.sort((a, b) {
          int publishedCompare = b.datePublished.compareTo(a.datePublished);

          if (publishedCompare != 0) {
            return publishedCompare;
          } else {
            return b.dateFetched.compareTo(a.dateFetched);
          }
        });

        // Clear 'newsList' and 'newsListFiltered'
        newsList.clear();
        newsListFiltered.clear();
      }

      // Done here!
      newsData.processState = ProcessState.successful;
      newsData.lastRequest = DateTime.now().millisecondsSinceEpoch;
      AppUtils.showLogToDebug(
        resultTag: AppLogLevel.info,
        tag: 'News',
        subTag: debugSubTag,
        message: "Task done successfully!",
      );
    } catch (ex) {
      newsData.processState = ProcessState.failed;
      AppUtils.showLogToDebug(
        resultTag: AppLogLevel.error,
        tag: 'News',
        subTag: debugSubTag,
        message: 'Task failed: ${ex.toString()}.',
      );
    } finally {
      AppUtils.showLogToDebug(
        resultTag: AppLogLevel.debug,
        tag: 'News',
        subTag: debugSubTag,
        message: "Task done! News count: ${newsData.data.length}",
      );
      notifyListeners();

      onDone?.call(newsData.processState == ProcessState.successful);
    }
  }

  Future<void> fetchNewsGlobal({
    NewsFetchingType fetchType = NewsFetchingType.firstPage,
    bool forceRequest = false,
    Function(bool)? onDone,
  }) async {
    await _fetchNews(
      newsData: newsGlobal,
      newsType: NewsType.global,
      debugSubTag: 'Global',
      fetchType: fetchType,
      forceRequest: forceRequest,
      onDone: onDone,
    );
  }

  Future<void> fetchNewsSubject({
    NewsFetchingType fetchType = NewsFetchingType.firstPage,
    bool forceRequest = false,
    Function(bool)? onDone,
  }) async {
    await _fetchNews(
      newsData: newsSubject,
      newsType: NewsType.subject,
      debugSubTag: 'Subject',
      fetchType: fetchType,
      forceRequest: forceRequest,
      onDone: onDone,
    );
  }

  Future<void> fetchNewsStudentAffairs({
    NewsFetchingType fetchType = NewsFetchingType.firstPage,
    bool forceRequest = false,
    Function(bool)? onDone,
  }) async {
    await _fetchNews(
      newsData: newsStudentAffairs,
      newsType: NewsType.studentAffairs,
      debugSubTag: 'Student Affairs',
      fetchType: fetchType,
      forceRequest: forceRequest,
      onDone: onDone,
    );
  }

  Future<void> fetchNewsExamination({
    NewsFetchingType fetchType = NewsFetchingType.firstPage,
    bool forceRequest = false,
    Function(bool)? onDone,
  }) async {
    await _fetchNews(
      newsData: newsExamination,
      newsType: NewsType.examination,
      debugSubTag: 'Examination',
      fetchType: fetchType,
      forceRequest: forceRequest,
      onDone: onDone,
    );
  }

  Future<void> fetchNewsTuitionFee({
    NewsFetchingType fetchType = NewsFetchingType.firstPage,
    bool forceRequest = false,
    Function(bool)? onDone,
  }) async {
    await _fetchNews(
      newsData: newsTuitions,
      newsType: NewsType.tuitionFee,
      debugSubTag: 'Tuition fee',
      fetchType: fetchType,
      forceRequest: forceRequest,
      onDone: onDone,
    );
  }

  Future<void> fetchNewsStatuteRegulation({
    NewsFetchingType fetchType = NewsFetchingType.firstPage,
    bool forceRequest = false,
    Function(bool)? onDone,
  }) async {
    await _fetchNews(
      newsData: newsTuitions,
      newsType: NewsType.statuteRegulation,
      debugSubTag: 'Statute & regulation',
      fetchType: fetchType,
      forceRequest: forceRequest,
      onDone: onDone,
    );
  }
}
