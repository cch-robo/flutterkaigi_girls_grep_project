# **[言語大乱闘! スマッシュシスターズ!](https://flutterkaigi.connpass.com/event/362550/)** (2025/08/02)

## FlutterKaigi girls x RustLadies コラボセッション

## つくってまなぶDart とRust 〜grepコマンドをつくって比較してみよう〜

## 概要
grepコマンドを実装したコードをながめながら、それぞれの言語の特徴をお話ししていきます。

### イベントページ
- [言語大乱闘! スマッシュシスターズ!](https://flutterkaigi.connpass.com/event/362550/) （FlutterKaigi girls)  
  [https://flutterkaigi.connpass.com/event/362550/](https://flutterkaigi.connpass.com/event/362550/)

- [言語大乱闘! スマッシュシスターズ!](https://rustladies.connpass.com/event/362634/) （RustLadies）  
  [https://rustladies.connpass.com/event/362634/](https://rustladies.connpass.com/event/362634/)

### dart版コマンド について
プロジェクトの`bin/`ディレクトリには、dart で作った以下のファイルが配置されています。
- bin/grep_cli.dart : dart で作った grep コマンドのエンドポイントです。  
   dart run grep_cli.dart コマンドを使って実行する必要があります。

下記は、grep_cli.dart を手軽に実行できようにする、起動ファイルです。
- bin/dgrep : dart run grep_cli.dart を実行するシェルスクリプトです。
- bin/dgrep_mac : intel mac 用のバイナリ実行ファイルです。(apple silicon mac でも起動できます)

### dart版コマンド実行環境設定
1. Flutter/Dart 開発環境をインストールした PCで、プロジェクトをクローンしてください。
2. ターミナルで dart コマンドが利用可能になるよう開発環境へのパスを通しておいてください。
3. 以下のようにして dart版コマンドの起動シェルスクリプトにパスを通して下さい。  
   export PATH=<プロジェクトディレクトリ>/bin:$PATH
4. 上記の設定が完了すれば、dgrep コマンドが実行できます。  
   オプションを何も指定しないで起動すると、Usage ヘルプが表示されます。

### コードの説明について
こちらの [コードの説明](https://github.com/cch-robo/flutterkaigi_girls_grep_project/blob/main/docs/code_description.md) ページを御参照下さい。

- [`docs/code_description.md`](https://github.com/cch-robo/flutterkaigi_girls_grep_project/blob/main/docs/code_description.md)
