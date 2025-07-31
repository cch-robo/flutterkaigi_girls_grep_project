import 'dart:io';

/// grep CLI のコマンドライン・パラメータを表すモデル
class CliParameter {
  const CliParameter({
    required this.paths,
    this.isRecursive = false,
    this.isUseColor = false,
  });

  /// パターンマッチ検索対象・ファイルパス一覧
  ///
  /// _[isRecursive] が true であれば、ディレクトリもファイルパスとして許容されます。_
  final List<File> paths;

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
}
