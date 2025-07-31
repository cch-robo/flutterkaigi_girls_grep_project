import '../../api_foundation/abstract_exception.dart';

class CanNotFindFilesError extends AbstractException {
  CanNotFindFilesError()
    : super(message: 'Can not find files from directories.');
}
