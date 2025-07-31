import 'package:grep_library/src/cli_foundation/cli_options_parser.dart';
import 'package:grep_library/src/cli_foundation/errors/file_not_exist_exception.dart';
import 'package:test/test.dart';

void main() {
  test('no_options', () {
    // ファイルパス指定なし
    expect(
      () => createOptionsParameters(getOptionsParser(), <String>[]),
      throwsA(isA<FileNotExistException>()),
    );
  });

  test('not_exist_option', () {
    // 存在しないファイルへのファイルパス
    expect(
      () => createOptionsParameters(getOptionsParser(), ['dummy.txt']),
      throwsA(isA<FileNotExistException>()),
    );
  });

  test('exist_option', () {
    // 存在するファイルへのファイルパス
    expect(
      createOptionsParameters(getOptionsParser(), [
        'bin/grep_cli.dart',
      ]).paths.first.path,
      'bin/grep_cli.dart',
    );
  });
}
