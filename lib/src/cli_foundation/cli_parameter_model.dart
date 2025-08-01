import 'package:grep_library/src/api_foundation/union_path_model.dart';

/// grep CLI のコマンドライン・パラメータを表すモデル
class CliParameter {
  const CliParameter({
    required this.regexps,
    required this.paths,
    this.isRecursive = false,
    this.isUseColor = false,
    this.isDebug = false,
  });

  /// 検索パターン・リスト
  ///
  /// _パターンマッチに使う、正規表現パターン・リストを指定します。_
  final List<RegExp> regexps;

  /// パターンマッチ検索対象・ファイル/ディレクトリ・ユニオンパス一覧
  ///
  /// _[isRecursive] が true であれば、ディレクトリもファイルパスとして許容されます。_
  final List<UnionPath> paths;

  /// ディレクトリ再帰探索フラグ
  ///
  /// オプション `-R` または `--directory-recursive` の指定を表します。
  ///
  /// true であれば、パターンマッチ検索対象ファイルパスがディレクトリの場合、再帰的にファイル探索を行います。
  ///
  /// _通常の grep では、`-r`, `--recursive`, `-R`, `--directory-recursive` が選べます。_
  final bool isRecursive;

  /// 出力テキスト行・パターンマッチ部色付フラグ
  ///
  /// オプション --use-color か --no-use-color の指定を表します。
  ///
  /// true であれば、出力テキスト行のパターン・マッチ部を色付にして識別可能にします。
  ///
  /// _通常の grep では、--color の WHEN に 'always', 'never', 'auto' が選べます。_
  final bool isUseColor;

  /// デバッグ実行・フラグ
  final bool isDebug;
}
