abstract class AbstractException implements Exception {
  AbstractException({this.message, StackTrace? stackTrace})
    : _stackTrace = stackTrace ?? StackTrace.current;

  /// メッセージ
  final String? message;

  final StackTrace _stackTrace;

  /// スタックトレース
  StackTrace get stackTrace => _stackTrace;
}
