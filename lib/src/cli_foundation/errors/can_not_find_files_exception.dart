import '../../api_foundation/abstract_exception.dart';

class CanNotFindFilesException extends AbstractException {
  CanNotFindFilesException()
    : super(message: 'Can not find files from directories.');
}
