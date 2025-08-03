import 'package:dutschedule/model/enum/process_state.dart';
import 'package:dutwrapper/news_object.dart';

import 'variable_state.dart';

class NewsData {
  NewsData();

  NewsData.fromCache(Map<String, dynamic> json) {
    fromMap(json);
  }

  final VariableListState<NewsCore> _newsList = VariableListState.from(
    data: [],
    lastRequest: 0,
    parameters: {'doneFetchingAllNews': '0', 'nextPage': '1'},
  );

  bool get isEndOfList {
    int isEndOfList = int.tryParse(_newsList.parameters['doneFetchingAllNews'] ?? '') ?? 1;
    return isEndOfList == 1;
  }

  set isEndOfList(bool isEndOfList) {
    _newsList.parameters['doneFetchingAllNews'] = (isEndOfList ? 1 : 0).toString();
  }

  int get nextPage {
    int nextPage = int.tryParse(_newsList.parameters['nextPage'] ?? '') ?? 1;
    return nextPage;
  }

  set nextPage(int nextPage) {
    _newsList.parameters['nextPage'] = nextPage.toString();
  }

  int get lastRequest {
    return _newsList.lastRequest;
  }

  set lastRequest(int value) {
    _newsList.lastRequest = value;
  }

  ProcessState get processState {
    return _newsList.state;
  }

  set processState(ProcessState value) {
    _newsList.state = value;
  }

  List<NewsCore> get data {
    return _newsList.data;
  }

  void resetValue() {
    _newsList.resetValue();
  }

  bool get isSuccessfulRequestExpired {
    return _newsList.isSuccessfulRequestExpired();
  }

  bool get isExpired {
    return _newsList.isExpired();
  }

  bool get isRunning {
    return _newsList.state == ProcessState.running;
  }

  Map<String, dynamic> toMap() {
    return {
      'data': _newsList.data.map((p) => p.toMap()).toList(),
      'last_request': _newsList.lastRequest,
      'parameters': _newsList.parameters,
    };
  }

  void fromMap(Map<String, dynamic> data) {
    _newsList.lastRequest = (data["last_request"] as int?) ?? 0;
    _newsList.data.addAll((data['data'] as List<dynamic>? ?? []).map((p) => NewsCore.fromMap(p)).toList());
    _newsList.parameters.addAll((data['parameters'] as Map<String, dynamic>? ?? {}).map((p, q) {
      return MapEntry(p, q);
    }));
  }
}
