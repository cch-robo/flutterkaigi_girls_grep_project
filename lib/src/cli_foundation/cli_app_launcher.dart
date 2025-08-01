import 'dart:io';

import 'package:grep_library/src/api_foundation/abstract_exception.dart';
import 'package:grep_library/src/cli_foundation/cli_message.dart';
import 'package:grep_library/src/cli_foundation/cli_options_parameter.dart';
import 'package:grep_library/src/cli_foundation/cli_options_parser.dart';
import 'package:grep_library/src/cli_foundation/cli_parameter_model.dart';

void launchCliApp(List<String> arguments) {
  // TODO パラメータ・チェックが終われば削除すること。
  CliOptionParser parser = CliOptionParser(arguments: arguments);
  parser.argResults.options.forEach((String key) => print('options key=$key'));
  print('help=${parser.argResults['help']}');
  print('regexp=${parser.argResults['regexp']}');
  print('rest=${parser.argResults.rest}');

  bool hasUsage = parser.hasOptionsUsage;
  if (hasUsage) {
    CliMessage help = CliMessage(isUseColor: true);
    help.putMessage(parser.optionsUsage);
    exit(0);
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
    exit(1);
  } catch (e) {
    errorMessage.putErrorMessage(e.toString());
    exit(1);
  }
}
