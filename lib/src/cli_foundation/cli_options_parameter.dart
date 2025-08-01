import 'dart:io';

import 'package:args/args.dart';
import 'package:grep_library/src/api_foundation/parameter_model.dart';
import 'package:grep_library/src/api_foundation/union_path_model.dart';
import 'package:grep_library/src/cli_foundation/errors/can_not_find_files_exception.dart';

import 'cli_options_parser.dart';
import 'errors/invalid_path_exception.dart';
import 'errors/pattern_not_exist_exception.dart';

/// コマンドライン・オプションのパラメータモデルを生成
///
/// _ファイルパス一覧が取得できなかったり空の場合は、
/// [PatternNotExistException] や [InvalidPathException] および
/// [CanNotFindFilesException] が投げられます。_
CliParameter createOptionsParameter(ArgResults argResults) {
  // 残りのオプション指定に、パターンが含まれているかチェックする。
  if (argResults.rest.isEmpty || _isExistPath(argResults.rest.first)) {
    // パターンが存在しなかった場合
    throw PatternNotExistException();
  }

  // 検索パターン(PATTERNS)を取得
  final String pattern = argResults.rest.first;

  // ファイルパス一覧を取得
  final List<String> arguments = argResults.rest.sublist(1);
  final int errIndex = _searchInvalidPath(arguments);
  if (errIndex != -1) {
    // ファイルやディレクトリのパスでない argument が存在した場合
    throw InvalidPathException(path: arguments[errIndex]);
  }

  // ファイル＋ディレクトリのユニオンパス一覧作成
  List<UnionPath> unionPaths = _createUnionPaths(arguments);

  // ディレクトリ再帰的探索のチェック
  bool isRecursive = argResults[CliOptionParser.recursive] as bool;
  if (unionPaths.isNotEmpty && !isRecursive) {
    List<UnionPath> directories = unionPaths
        .where((UnionPath path) => path.isDirPath)
        .toList();
    // -r オプション指定がないのに、Directory があるので検索ファイルを特定できない。
    if (directories.isNotEmpty) {
      throw CanNotFindFilesException();
    }
  }

  // コマンドライン・オプションモデルを返す。
  return _createCliParameter(pattern, unionPaths, argResults);
}

/// パス([path])にファイルかディレクトリが存在するかチェックする。
bool _isExistPath(String path) {
  final File file = File(path);
  final Directory dir = Directory(path);
  return file.existsSync() || dir.existsSync();
}

/// パスでない argument が含まれているかチェックする。
///
/// - 返却値<br/>
///   ファイルやディレクトリがなかった argument の index 値が返ります。<br/>
///   全てがファイルパスの場合は、-1が返ります。
int _searchInvalidPath(List<String> arguments) {
  List<int> indexList = List.generate(arguments.length, (int index) => index);
  return indexList.firstWhere(
    (int index) => !_isExistPath(arguments[index]),
    orElse: () => -1,
  );
}

/// ファイル/ディレクトリ・ユニオンパス一覧生成
List<UnionPath> _createUnionPaths(List<String> arguments) {
  return arguments.map((String path) {
    FileSystemEntityType fileType = File(path).statSync().type;
    if (fileType == FileSystemEntityType.file) {
      return UnionPath.createFilePath(path);
    }
    if (fileType == FileSystemEntityType.directory) {
      return UnionPath.createDirPath(path);
    }
    throw UnsupportedError(
      'Unsupported fileType:${fileType.toString()}, path:$path.',
    );
  }).toList();
}

/// コマンドライン・パラメータモデル生成
CliParameter _createCliParameter(
  String pattern,
  List<UnionPath> unionPaths,
  ArgResults argResults,
) {
  String? regexp = argResults[CliOptionParser.regexp] as String?;
  bool isRecursive = argResults[CliOptionParser.recursive] as bool;
  bool isDescribe = argResults[CliOptionParser.describe] as bool;
  bool isUseColor = argResults[CliOptionParser.useColor] as bool;

  // 検索パターン・オプションの取得
  List<RegExp> regexps = [];
  regexps.add(RegExp(pattern));
  if (regexp != null) {
    regexps.add(RegExp(regexp));
  }

  return CliParameter(
    regexps: regexps,
    paths: unionPaths,
    isRecursive: isRecursive,
    isDescribe: isDescribe,
    isUseColor: isUseColor,
  );
}
