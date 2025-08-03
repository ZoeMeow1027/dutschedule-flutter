enum AppLogLevel {
  error(4, 'ERROR'),
  warning(3, 'WARN'),
  info(2, 'INFO'),
  debug(1, 'DEBUG'),
  verbose(0, 'VERBOSE');

  final int value;
  final String _text;
  
  @override
  String toString() {
    return _text;
  }

  String toChar() {
    return _text.isNotEmpty ? _text.substring(0, 1) : '-';
  }
  
  const AppLogLevel(this.value, this._text);
}