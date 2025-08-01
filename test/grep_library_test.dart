import 'package:grep_library/src/cli_foundation/cli_options_parameter.dart';
import 'package:grep_library/src/cli_foundation/cli_options_parser.dart';
import 'package:grep_library/src/cli_foundation/errors/file_not_exist_exception.dart';
import 'package:test/test.dart';

void main() {
  test('no_options', () {
    // ファイルパス指定なし
    final CliOptionParser parser = CliOptionParser(arguments: <String>[]);
    expect(
      () => createOptionsParameter(parser.argResults),
      throwsA(isA<FileNotExistException>()),
    );
  });

  test('not_exist_option', () {
    // 存在しないファイルへのファイルパス
    final CliOptionParser parser = CliOptionParser(
      arguments: <String>['dummy.txt'],
    );
    expect(
      () => createOptionsParameter(parser.argResults),
      throwsA(isA<FileNotExistException>()),
    );
  });

  test('exist_option', () {
    // 存在するファイルへのファイルパス
    final CliOptionParser parser = CliOptionParser(
      arguments: <String>['bin/grep_cli.dart'],
    );
    expect(
      createOptionsParameter(parser.argResults).paths.first.path,
      'bin/grep_cli.dart',
    );
  });
}
