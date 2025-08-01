import 'dart:io';

import 'package:args/args.dart';
import 'package:grep_library/src/api_foundation/abstract_exception.dart';
import 'package:grep_library/src/cli_foundation/cli_message.dart';
import 'package:grep_library/src/cli_foundation/cli_options_parser.dart';
import 'package:grep_library/src/cli_foundation/cli_parameter_model.dart';

void launchCliApp(List<String> arguments) {
  // TODO パラメータ・チェックが終われば削除すること。
  ArgResults argResults = getOptionsParserResults(arguments, getOptionsParser());
  argResults.options.forEach((String key) => print('options key=$key'));
  print('help=${argResults['help']}');
  print('regexp=${argResults['regexp']}');
  print('rest=${argResults.rest}');

  bool hasUsage = hasOptionsUsage(getOptionsParserResults(arguments, getOptionsParser()));
  if (hasUsage) {
    CliMessage help = CliMessage(isUseColor: true);
    help.putMessage(getOptionsUsage(getOptionsParser()));
    exit(0);
  }

  CliMessage errorMessage = CliMessage();
  try {
    CliParameter param = createOptionsParameters(getOptionsParser(), arguments);

    // TODO パラメータを使った処理を追加する。（現状は、コマンドライン・パラメータ取得確認のみ）
    CliMessage mes = CliMessage(isUseColor: true);
    mes.putMessage('ファイルパス=${param.paths.first.path}', color: TextColor.red);
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
