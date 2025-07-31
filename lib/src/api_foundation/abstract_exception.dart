abstract class AbstractException implements Exception {
  AbstractException({this.message});

  /// メッセージ
  final String? message;
}