import 'dart:convert';
import 'dart:io';

/// コマンドラインアプリの標準入出力クラス
class CliMessage {
  CliMessage({this.isUseColor = false});

  /// 文字色を使うか否かのフラグ
  ///
  /// - true: 文字色を使う<br/>
  ///   エスケープコードを使って文字に色をつける
  /// - false: 文字色を使わない<br/>
  ///   エスケープコードを使いません。
  final bool isUseColor;

  /// メッセージ入力
  ///
  /// 標準入力からメッセージを取得します。
  String? getMessage() {
    try {
      return stdin.readLineSync(encoding: utf8);
    } on FormatException catch (exception) {
      // 文字削除等で破壊されたマルチバイト文字など、
      // UTF-8 文字としてデコードできなかった場合。
      _inputErrorNotice('[${exception.message}]');
    } catch (e) {
      // 何らかの異常があった場合。
      _inputErrorNotice('[${e.runtimeType.toString()}]');
    }
    return null;
  }

  void _inputErrorNotice(String message) {
    if (stdin.supportsAnsiEscapes) {
      putErrorMessage(
        '${TextColor.red.fgColorCode}$message${TextColor.defaultColor.fgColorCode}',
      );
    } else {
      putErrorMessage(message);
    }
  }

  /// メッセージ出力
  ///
  /// 標準出力にメッセージを出力します。
  ///
  /// - [message] : 表示するメッセージ
  /// - [isNewLine] : （オプション）改行フラグ<br/>
  ///   （デフォルトは true）
  /// - [color] : （オプション）文字色<br/>
  ///   （デフォルトは、[TextCode.defaultColor]）
  void putMessage(
    String message, {
    bool isNewLine = true,
    TextColor color = TextColor.defaultColor,
  }) {
    // ANSI escape が使えて、かつ文字色を使う場合のみ色情報を付加します。
    String coloredMessage = isUseColor && stdout.supportsAnsiEscapes
        ? '${color.fgColorCode}$message${TextColor.defaultColor.fgColorCode}'
        : message;
    if (isNewLine) {
      _putMessage(coloredMessage, isNewLine: true);
    } else {
      _putMessage(coloredMessage, isNewLine: false);
    }
  }

  void _putMessage(String message, {bool isNewLine = true}) {
    if (isNewLine) {
      stdout.writeln(message);
    } else {
      stdout.write(message);
    }
  }

  /// エラーメッセージ出力
  ///
  /// 標準エラー出力にメッセージを出力します。
  ///
  /// - [message] : 表示するメッセージ
  void putErrorMessage(String message) {
    stderr.writeln(message);
  }
}

/// Text Color - ANSI escape code
enum TextColor {
  // ANSI Escape code については、以下の資料を参照下さい。
  //
  // ASCII control characters
  // https://en.wikipedia.org/wiki/ASCII
  //
  // ANSI escape code
  // https://en.wikipedia.org/wiki/ANSI_escape_code
  black(30, 40),
  red(31, 41),
  green(32, 42),
  yellow(33, 43),
  blue(34, 44),
  magenta(35, 45),
  cyan(36, 46),
  white(37, 47),
  defaultColor(39, 49);

  const TextColor(this.foreground, this.background);

  final int foreground;
  final int background;

  /// 文字前面色のエスケープコード
  String get fgColorCode => '\x1B[${foreground}m';

  /// 文字背景色のエスケープコード
  String get bgColorCode => '\x1B[${background}m';
}
