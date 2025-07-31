import '../../api_foundation/abstract_exception.dart';

class FileNotExistException extends AbstractException {
  FileNotExistException({required String filePath})
    : super(message: 'File or Directory not exist. - filePath=$filePath');
}
