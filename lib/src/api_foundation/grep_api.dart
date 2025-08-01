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
/// - [streamDataController] : パターンマッチした行を受け取る SteamController
Future<void> grep(
  CliParameter param,
  StreamController<String> streamDataController,
) async {
  final Completer<void> completer = Completer<void>();

  bool isUseColor = param.isUseColor;
  List<RegExp> regexps = param.regexps;
  for (UnionPath path in param.paths) {
    if (path.isFilePath) {
      // ファイル内を探索
      _submitPatternMatchedLines(
        completer,
        regexps,
        path.filePath!,
        streamDataController,
      );
    } else {
      // ディレクトリ配下の全ファイル内を探索
      List<File> files = _getFiles(path.dirPath!);
      for (File file in files) {
        _submitPatternMatchedLines(
          completer,
          regexps,
          file,
          streamDataController,
        );
      }
    }
  }
  return completer.future;
}

/// ディレクトリ内の全てのファイルを取得します。
List<File> _getFiles(Directory directory) {
  final List<File> filePaths = <File>[];
  List<FileSystemEntity> entries = directory.listSync(
    recursive: true,
    followLinks: false,
  );
  for (final FileSystemEntity entity in entries) {
    if (entity is File) {
      filePaths.add(entity);
    }
  }
  return filePaths;
}

/// ファイル内の検索パターンが含まれている行をストリームに投入します。
///
/// - [completer] : 非同期処理完了通知用
/// - [regexps] : 検索パターン一覧
/// - [file] : パターンマッチ行を探索するファイル
/// - [streamDataController] : マッチした行を受け取る SteamController
void _submitPatternMatchedLines(
  Completer<void> completer,
  List<RegExp> regexps,
  File file,
  StreamController<String> streamDataController,
) {
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
