import 'dart:io';

import 'package:args/args.dart';
import 'package:grep_library/src/cli_foundation/cli_parameter_model.dart';
import 'package:grep_library/src/cli_foundation/errors/can_not_find_files_error.dart';

import 'errors/file_not_exist_exception.dart';

/// オプション --regexp
const String regexp = 'regexp';

/// オプション・フラグ --recursive
const String recursive = 'recursive';

/// オプション・フラグ --use-color
const String useColor = 'use-color';

/// オプション・フラグ --help
const String help = 'help';

/// コマンドライン Usage のヘッダテキスト
const String usage = '''Usage: grep [OPTION]... PATTERNS [FILE]...
Search for PATTERN in each FILE.
Example: grep 'hello world' menu.h main.c
When FILE is not specified, the stdin stream is searched.
PATTERNS can contain multiple patterns separated by newlines.
''';

/// コマンドライン・オプションのパーサー取得
ArgParser getOptionsParser() {
  final ArgParser argParser = ArgParser()
    // grep で検索する正規表現パターン(PATTERNS)を追加するオプション
    // オプション -e PATTERNS または --regexp PATTERNS の指定を表します。
    // （注）通常の grep では、-e, --regexp, -E, --extended-regexp が使えます。
    ..addOption(
      regexp,
      abbr: 'e',
      help: 'Specifies the regular expression pattern to search.',
    )
    // ファイルパス・ディレクトリ再帰的探索のオプション・フラグ
    // フラグ -r または --recursive の指定を表します。
    // （注）通常の grep では、-r, --recursive, -R, --directory-recursive が使えます。
    ..addFlag(
      recursive,
      negatable: false,
      abbr: 'r',
      help: 'Recursive file search flag for directories.',
    )
    // マッチテキスト行・マッチパターン色付出力のオプション・フラグ
    // フラグ --use-color か --no-use-color の指定を表します。
    // （注）通常の grep では、--color であり、WHEN に 'always', 'never', 'auto' が選べます。
    ..addFlag(
      useColor,
      negatable: true,
      help: 'Output color options for matched text patterns.',
    )
    // Usage ヘルプ表示のオプション・フラグ
    // フラグ -h または --help の指定を表します。
    ..addFlag(
      help,
      abbr: 'h',
      negatable: false,
      help: 'Print this usage information.',
    );

  return argParser;
}

/// コマンドライン・オプションのパーサー解析結果取得
ArgResults getOptionsParserResults(List<String> args, ArgParser argParser) {
  ArgResults argResults = argParser.parse(args);
  return argResults;
}

/// オプション・Usage ヘルプの存在チェック
bool hasOptionsUsage(ArgResults argResults) {
  bool hasHelp = argResults[help] as bool;
  return hasHelp;
}

/// オプション・Usage ヘルプのヘッダ＋オプション一覧取得
String getOptionsUsage(ArgParser argParser) {
  return '$usage\n${argParser.usage}';
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
