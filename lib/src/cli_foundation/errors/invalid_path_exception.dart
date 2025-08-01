import '../../api_foundation/abstract_exception.dart';

class InvalidPathException extends AbstractException {
  InvalidPathException({required String path})
    : super(message: 'Path File or Directory not exist. - path=$path');
}
