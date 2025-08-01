import 'package:args/args.dart';

class CliOptionParser {
  CliOptionParser({required List<String> arguments}) {
    argParser = _getOptionsParser();
    argResults = _getOptionsParserResults(arguments, argParser);
  }

  /// オプション --regexp
  static const String regexp = 'regexp';

  /// オプション・フラグ --recursive
  static const String recursive = 'recursive';

  /// オプション・フラグ --use-color
  static const String useColor = 'use-color';

  /// オプション・フラグ --debug
  static const String debug = 'debug';

  /// オプション・フラグ --help
  static const String help = 'help';

  /// コマンドライン Usage のヘッダテキスト
  static const String usage = '''Usage: grep [OPTION]... PATTERNS [FILE]...
Search for PATTERN in each FILE.
Example: grep 'hello world' menu.h main.c
When FILE is not specified, the stdin stream is searched.
PATTERNS can contain multiple patterns separated by newlines.
''';

  late final ArgParser argParser;
  late final ArgResults argResults;

  /// コマンドライン・オプションのパーサー取得
  ArgParser _getOptionsParser() {
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
      // デバッグ実行明示のオプション・フラグ
      // フラグ --debug の指定を表します。
      ..addFlag(
        debug,
        negatable: false,
        help: 'Flag of running in the debug mode.',
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
  ArgResults _getOptionsParserResults(List<String> args, ArgParser argParser) {
    ArgResults argResults = argParser.parse(args);
    return argResults;
  }

  /// オプション・Usage ヘルプの存在チェック
  bool get hasOptionsUsage {
    bool hasHelp = argResults[help] as bool;
    return hasHelp;
  }

  /// オプション・Usage ヘルプのヘッダ＋オプション一覧取得
  String get optionsUsage => '$usage\n${argParser.usage}';
}
