import 'dart:io';

import 'package:grep_library/src/api_foundation/abstract_exception.dart';
import 'package:grep_library/src/cli_foundation/cli_message.dart';
import 'package:grep_library/src/cli_foundation/cli_options_parser.dart';
import 'package:grep_library/src/cli_foundation/cli_parameter_model.dart';

void launchCliApp(List<String> arguments) {
  if (arguments.isEmpty) {
    // オプション指定がないので、コマンドライン・オプション一覧 ⇒ ヘルプ表示を行います。
    CliMessage help = CliMessage(isUseColor: true);
    help.putMessage('Usage: dart run grep_cli.dart [options] <file path>\n');
    help.putMessage(getOptionsUsage());
    exit(1);
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
