import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:grep_library/src/api_foundation/parameter_model.dart';
import 'package:grep_library/src/api_foundation/union_path_model.dart';

/// 検索パターンが含まれている行をストリームに投入します。
///
/// - [param] : コマンドライン・パラメータモデル<br/>
///   検索パターンや検索ファイルなどのコマンドライン・オプションデータを保持する。
///
/// - [streamDataController] : ヒットした行を受け取る SteamController
Future<void> grep(
  CliParameter param,
  StreamController<String> streamDataController,
) async {
  final Completer<void> completer = Completer<void>();

  bool isUseColor = param.isUseColor;
  List<RegExp> regexps = param.regexps;
  for (UnionPath path in param.paths) {
    if (!path.isFilePath) continue;

    File file = path.filePath!;
    if (file.existsSync()) {
      final Stream<List<int>> byteStream = file.openRead();

      String path = file.path;
      int lineNumber = 1;

      final Stream<String> lineStream = byteStream
          .transform(utf8.decoder)
          .transform(LineSplitter());

      lineStream.listen(
        (String line) {
          for (RegExp regexp in regexps) {
            if (regexp.hasMatch(line)) {
              streamDataController.add('$path[$lineNumber]: $line');
              break;
            }
          }
          lineNumber++;
        },
        onDone: () {
          completer.complete();
        },
        onError: (Object? error) {
          completer.completeError(
            error!,
            (error is Error) ? error.stackTrace : StackTrace.current,
          );
        },
      );
    }
  }
  return completer.future;
}
