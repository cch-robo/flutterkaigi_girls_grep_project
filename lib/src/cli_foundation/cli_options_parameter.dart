import 'dart:io';

import 'package:args/args.dart';
import 'package:grep_library/src/cli_foundation/cli_parameter_model.dart';
import 'package:grep_library/src/cli_foundation/errors/can_not_find_files_error.dart';

import 'cli_options_parser.dart';
import 'errors/file_not_exist_exception.dart';

/// コマンドライン・オプションのパラメータモデルを生成
///
/// _ファイルパス一覧が取得できなかったり空の場合は、
/// [FileNotExistException] や [CanNotFindFilesError] が投げられます。_
CliParameter createOptionsParameter(ArgResults argResults) {
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

/// ファイルパス・チェック
///
/// _[filePath] で指定したファイルやディレクトリが存在しない場合は、
/// [FileNotExistException] が投げられます。_
bool _isFilePath(String filePath) {
  final File file = File(filePath);
  return file.existsSync();
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
  bool isRecursive = argResults[CliOptionParser.recursive] as bool;
  bool isUseColor = argResults[CliOptionParser.useColor] as bool;
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

  // TODO 現状の検索パラメータとファイルパス並びの取得は仮実装なので、修正すること。
  // 残りの引数一覧を取得。
  final List<String> params = argResults.rest;

  if (params.isEmpty) {
    // ファイルパス並びがなかった場合
    throw FileNotExistException(filePath: '(none)');
  }

  // 検索パターン・オプションの取得
  List<RegExp> regexps = [];
  String? regexp = argResults[CliOptionParser.regexp] as String?;
  String? pattern = (!_isFilePath(params.first) ? params.first : null);
  if (regexp != null) {
    regexps.add(RegExp(regexp));
  }
  if (pattern != null) {
    regexps.add(RegExp(pattern));
  }
  if (regexps.isEmpty) {
    // 検索パターンがなかった場合
    throw CanNotFindFilesError();
  }

  return CliParameter(
    regexps: regexps,
    paths: filePaths,
    isRecursive: isRecursive,
    isUseColor: isUseColor,
  );
}
