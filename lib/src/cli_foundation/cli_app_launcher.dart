import 'dart:io';

import 'package:grep_library/src/api_foundation/abstract_exception.dart';
import 'package:grep_library/src/cli_foundation/cli_message.dart';
import 'package:grep_library/src/cli_foundation/cli_options_parameter.dart';
import 'package:grep_library/src/cli_foundation/cli_options_parser.dart';
import 'package:grep_library/src/cli_foundation/cli_parameter_model.dart';

void launchCliApp(List<String> arguments) {
  CliOptionParser parser = CliOptionParser(arguments: arguments);
  if (arguments.isEmpty || parser.hasOptionsUsage) {
    // ヘルプ表示が必要な場合は、優先的に表示して処理を終了する。
    CliMessage help = CliMessage(isUseColor: true);
    help.putMessage(parser.optionsUsage);
    exit(1);
  }

  CliMessage errorMessage = CliMessage();
  try {
    CliParameter param = createOptionsParameter(parser.argResults);

    // TODO パラメータを使った処理を追加する。（現状は、コマンドライン・パラメータ取得確認のみ）
    CliMessage mes = CliMessage(isUseColor: true);
    mes.putMessage('ファイルパス=${param.paths.first.path}', color: TextColor.red);
    mes.putMessage(
      'regexps=${param.regexps.map((RegExp regexp) => regexp.pattern)}',
      color: TextColor.green,
    );
    mes.putMessage('isUseColor=${param.isUseColor}', color: TextColor.blue);
    mes.putMessage('isRecursive=${param.isRecursive}', color: TextColor.yellow);
    print(mes.getMessage() ?? '');

    exit(0);
  } on AbstractException catch (exception) {
    errorMessage.putErrorMessage(exception.message ?? exception.toString());
    errorMessage.putMessage(exception.stackTrace.toString());
    exit(1);
  } catch (e) {
    errorMessage.putErrorMessage(e.toString());
    if (e is Error) {
      print(e.stackTrace);
    }
    exit(1);
  }
}
