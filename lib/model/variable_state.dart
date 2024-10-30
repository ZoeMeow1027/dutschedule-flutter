import '../global_variables.dart';
import 'process_state.dart';

class VariableState<T> {
  VariableState();

  VariableState.from({
    required this.data,
    required this.lastRequest,
    required this.parameters,
    this.state = ProcessState.notRunYet,
  });

  T? data;
  int lastRequest = 0;
  ProcessState state = ProcessState.notRunYet;
  Map<String, String> parameters = {};

  bool isExpired() {
    return lastRequest + GlobalVariables.requestExpiredDuration < DateTime.now().millisecondsSinceEpoch;
  }

  bool isSuccessfulRequestExpired() {
    return state == ProcessState.successful ? isExpired() : false;
  }

  void resetValue() {
    if (state != ProcessState.running) {
      lastRequest = 0;
      state = ProcessState.notRunYet;
    }
  }
}

class VariableListState<T> {
  VariableListState();

  VariableListState.from({
    required this.data,
    required this.lastRequest,
    required this.parameters,
    this.state = ProcessState.notRunYet,
  });

  List<T> data = [];
  int lastRequest = 0;
  ProcessState state = ProcessState.notRunYet;
  Map<String, String> parameters = {};

  bool isExpired() {
    return lastRequest + GlobalVariables.requestExpiredDuration < DateTime.now().millisecondsSinceEpoch;
  }

  bool isSuccessfulRequestExpired() {
    return state == ProcessState.successful ? isExpired() : false;
  }

  void resetValue() {
    if (state != ProcessState.running) {
      data.clear();
      lastRequest = 0;
      state = ProcessState.notRunYet;
    }
  }
}