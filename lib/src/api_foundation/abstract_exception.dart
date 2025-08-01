abstract class AbstractException implements Exception {
  AbstractException({this.message, StackTrace? stackTrace})
    : _stackTrace = stackTrace ?? StackTrace.current;

  final StackTrace _stackTrace;

  /// メッセージ
  final String? message;

  /// スタックトレース
  StackTrace get stackTrace => _stackTrace;
}
