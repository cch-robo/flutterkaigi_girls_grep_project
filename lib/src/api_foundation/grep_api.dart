import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:grep_library/src/api_foundation/parameter_model.dart';

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
  RegExp regExp = param.regexps.first;
  File file = param.paths
      .firstWhere((unionPath) => unionPath.isFilePath)
      .filePath!;

  if (file.existsSync()) {
    final Stream<List<int>> byteStream = file.openRead();

    String path = file.path;
    int lineNumber = 1;

    final Stream<String> lineStream = byteStream
        .transform(utf8.decoder)
        .transform(LineSplitter());

    lineStream.listen(
      (String line) {
        if (regExp.hasMatch(line)) {
          streamDataController.add('$path[$lineNumber]: $line');
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
  return completer.future;
}
