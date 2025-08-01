import '../../api_foundation/abstract_exception.dart';

class PatternNotExistException extends AbstractException {
  PatternNotExistException() : super(message: 'PATTERN not exist.');
}
