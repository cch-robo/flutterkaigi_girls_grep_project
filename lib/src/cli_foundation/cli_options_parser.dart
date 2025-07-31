import 'dart:io';

import 'package:args/args.dart';
import 'package:grep_library/src/cli_foundation/cli_parameter_model.dart';
import 'package:grep_library/src/cli_foundation/errors/can_not_find_files_error.dart';

import 'errors/file_not_exist_exception.dart';

/// コマンドライン・オプション --help
///
/// コマンドライン・ヘルプ表示
///
/// オプション `-h` または `--help` の指定を表します。
const String help = 'help';

/// コマンドライン・オプション --directory-recursive
///
/// ファイルパス・ディレクトリ再帰的探索オプション
///
/// オプション `-R` または `--directory-recursive` の指定を表します。
///
/// _通常の grep では、`-r`, `--recursive`, `-R`, `--directory-recursive` を選びます。_
const String recursive = 'directory-recursive';

/// コマンドライン・オプション --use-color
///
/// マッチテキスト行・マッチパターン色付出力オプション
///
/// オプション --use-color か --no-use-color の指定を表します。
///
/// _通常の grep では、--color の WHEN に 'always', 'never', 'auto' が選べます。_
const String useColor = 'use-color';

/// コマンドライン・オプションのパーサー取得
ArgParser getOptionsParser() {
  final ArgParser argParser = ArgParser()
    // コマンドライン・ヘルプ表示の省略表記は、-h とします。
    ..addFlag(
      help,
      abbr: 'h',
      negatable: false,
      help: 'Print this usage information.',
    )
    // ファイルパス・ディレクトリ再帰的探索オプションの省略表記は、-R とします。
    ..addFlag(
      recursive,
      negatable: false,
      abbr: 'R',
      help: 'Recursive file search flag for directories.',
    )
    // マッチテキスト行・マッチパターン色付出力オプション
    ..addFlag(
      useColor,
      negatable: true,
      help: 'Output color options for matched text patterns.',
    );

  return argParser;
}

/// コマンドライン・オプション一覧取得
String getOptionsUsage() {
  return getOptionsParser().usage;
}

/// コマンドライン・オプションのパラメータモデルを生成
///
/// _ファイルパス一覧が取得できなかったり空の場合は、
/// [FileNotExistException] や [CanNotFindFilesError] が投げられます。_
CliParameter createOptionsParameters(
  ArgParser argParser,
  List<String> arguments,
) {
  // コマンドライン・オプション指定パース
  final ArgResults argResults = argParser.parse(arguments);

  // 残りのオプション指定は、全てファイルパス並びとします。
  final List<String> paths = argResults.rest;
  List<File> filePaths = _createFilePaths(paths);

  // コマンドライン・オプションモデルを返す。
  return _createCliParameter(filePaths, argResults);
}

/// ファイルパス一覧生成
///
/// _[filePath] で指定したファイルやディレクトリが存在しなかったり、
/// ファイルパス一覧が空の場合は、[FileNotExistException] が投げられます。_
List<File> _createFilePaths(List<String> paths) {
  List<File> filePaths = paths
      .map((String filePath) => _createFilePath(filePath))
      .toList();
  if (filePaths.isEmpty) {
    throw FileNotExistException(filePath: '(none)');
  }
  return filePaths;
}

/// ファイルパス生成
///
/// _[filePath] で指定したファイルやディレクトリが存在しない場合は、
/// [FileNotExistException] が投げられます。_
File _createFilePath(String filePath) {
  final File file = File(filePath);
  if (!file.existsSync()) {
    throw FileNotExistException(filePath: filePath);
  }
  return file;
}

/// コマンドライン・パラメータモデル生成
///
/// _[filePath] からファイルが取得できない場合は、[CanNotFindFilesError] が投げられます。_
CliParameter _createCliParameter(List<File> filePaths, ArgResults argResults) {
  bool isRecursive = argResults[recursive] as bool;
  bool isUseColor = argResults[useColor] as bool;
  if (!isRecursive) {
    List<File> directories = filePaths
        .where(
          (File filePath) =>
              filePath.statSync().type == FileSystemEntityType.directory,
        )
        .toList();
    // -R オプション指定がないのに、Directory しか指定されていないので検索ファイルを特定できない。
    if (filePaths.length == directories.length) {
      throw CanNotFindFilesError();
    }
  }
  return CliParameter(
    paths: filePaths,
    isRecursive: isRecursive,
    isUseColor: isUseColor,
  );
}
