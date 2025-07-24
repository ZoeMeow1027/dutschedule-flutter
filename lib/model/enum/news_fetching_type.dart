enum NewsFetchingType {
  /// Fetch next page with 'nextPage' variable.
  nextPage,

  /// Fetch first page (to find latest news).
  firstPage,

  /// Clear cache and fetch first page
  /// (only clear cache and add new list after successfully fetched first page).
  clearAndFetchFirstNewsPage,

  /// Clear cache immediately and fetch all news
  /// (WARNING: This will fetch all news page and not recommended).
  clearAndFetchAllNews,
}
