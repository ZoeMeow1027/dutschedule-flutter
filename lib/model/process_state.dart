enum ProcessState {
  notRunYet(-1),
  running(0),
  failed(1),
  successful(2);

  final int value;

  const ProcessState(this.value);
}