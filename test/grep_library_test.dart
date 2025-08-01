import 'package:grep_library/src/cli_foundation/cli_options_parameter.dart';
import 'package:grep_library/src/cli_foundation/cli_options_parser.dart';
import 'package:grep_library/src/cli_foundation/errors/can_not_find_files_exception.dart';
import 'package:grep_library/src/cli_foundation/errors/invalid_path_exception.dart';
import 'package:grep_library/src/cli_foundation/errors/pattern_not_exist_exception.dart';
import 'package:test/test.dart';

void main() {
  test('no_options', () {
    // PATTERNS もファイルパスも指定なし
    final CliOptionParser parser = CliOptionParser(arguments: <String>[]);
    expect(
      () => createOptionsParameter(parser.argResults),
      throwsA(isA<PatternNotExistException>()),
    );
  });

  test('no_patterns_option', () {
    // PATTERNS にファイルパスが指定されている。
    final CliOptionParser parser = CliOptionParser(
      arguments: <String>['bin/grep_cli.dart'],
    );
    expect(
      () => createOptionsParameter(parser.argResults),
      throwsA(isA<PatternNotExistException>()),
    );
  });

  test('only_exist_patterns_option', () {
    // PATTERNS のみが指定されている。
    final CliOptionParser parser = CliOptionParser(
      arguments: <String>['hello world!'],
    );
    expect(
      createOptionsParameter(parser.argResults).regexps.first.pattern,
      'hello world!',
    );
  });

  test('no_filepath_option', () {
    // PATTERNS があるが、ファイルパスのファイルが存在しない。
    final CliOptionParser parser = CliOptionParser(
      arguments: <String>['hello world!', 'good morning!'],
    );
    expect(
          () => createOptionsParameter(parser.argResults),
      throwsA(isA<InvalidPathException>()),
    );
  });

  test('not_exist_filepath_option', () {
    // PATTERNS もファイルパスもあるが、ファイルパスのファイルが存在しない。
    final CliOptionParser parser = CliOptionParser(
      arguments: <String>['hello world!', 'dummy.txt'],
    );
    expect(
      () => createOptionsParameter(parser.argResults),
      throwsA(isA<InvalidPathException>()),
    );
  });

  test('no_recursive_directory_option', () {
    // PATTERNS もファイルパスのディレクトリも存在するが、再帰探索フラグがない。
    final CliOptionParser parser = CliOptionParser(
      arguments: <String>['hello world!', 'bin'],
    );
    expect(
      () => createOptionsParameter(parser.argResults),
      throwsA(isA<CanNotFindFilesException>()),
    );
  });

  test('exist_recursive_directory_option', () {
    // PATTERNS もファイルパスのディレクトリも存在し、再帰探索フラグも存在する。
    final CliOptionParser parser = CliOptionParser(
      arguments: <String>['-r', 'hello world!', 'bin'],
    );
    expect(createOptionsParameter(parser.argResults).paths.first.path, 'bin');
  });

  test('exist_both_option', () {
    // PATTERNS も存在するファイルへのファイルパスもある。
    final CliOptionParser parser = CliOptionParser(
      arguments: <String>['hello world!', 'bin/grep_cli.dart'],
    );
    expect(
      createOptionsParameter(parser.argResults).paths.first.path,
      'bin/grep_cli.dart',
    );
  });
}
