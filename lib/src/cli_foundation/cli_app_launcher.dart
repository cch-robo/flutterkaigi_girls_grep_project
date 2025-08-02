import 'dart:async';
import 'dart:io';

import 'package:grep_library/src/api_foundation/abstract_exception.dart';
import 'package:grep_library/src/api_foundation/parameter_model.dart';
import 'package:grep_library/src/cli_foundation/cli_message.dart';
import 'package:grep_library/src/cli_foundation/cli_options_parameter.dart';
import 'package:grep_library/src/cli_foundation/cli_options_parser.dart';

import '../../grep_api.dart';

Future<void> launchCliApp(List<String> arguments) async {
  CliOptionParser parser = CliOptionParser(arguments: arguments);
  CliMessage err = CliMessage(isDebug: parser.isDebug);
  if (arguments.isEmpty || parser.hasOptionsUsage) {
    // ヘルプ表示が必要な場合は、優先的に表示して処理を終了する。
    err.putErrorMessage(parser.optionsUsage);
    exit(1);
  }

  try {
    // コマンドライン・オプションパラメータを取得する。
    CliParameter param = createOptionsParameter(parser.argResults);

    // ターミナルの標準出力に、受け取った検索結果を出力する SteamController を作成する。
    CliMessage std = CliMessage(isUseColor: param.isUseColor);
    StreamController<String> streamDataController = StreamController<String>();
    streamDataController.stream.listen((String data) {
      std.putMessage(data);
    });

    // grep 検索を行わせて、StreamController にヒット行を投入させます。
    await grep(param, streamDataController);
    streamDataController.close();

    exit(0);
  } on AbstractException catch (exception) {
    err.putErrorMessage(exception.message ?? exception.toString());
    err.putDebugErrorMessage(exception.stackTrace.toString());
    exit(1);
  } catch (e) {
    err.putErrorMessage(e.toString());
    if (e is Error) {
      err.putDebugErrorMessage(e.stackTrace.toString());
    }
    exit(1);
  }
}
