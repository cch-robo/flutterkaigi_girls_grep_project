# **コードの説明**
## つくってまなぶ Dart と Rust 〜grepコマンドをつくって比較してみよう〜

FlutterKaigi girls 版の grep コマンドの dartプログラムについての解説ページです。  

コード詳細については、GitHub リポジトリのプロジェクト・コードを直接確認して下さいね。


## コマンドライン・オプション
dart 言語は、Flutterによる iOS, Android, Web, Linux, macOS, Windows のデスクトップアプリ作成だけでなく、  
dart 単独で Linux, macOS, Windows のコマンドラインアプリも作れます。

このため`コマンドライン・アプリの作り方のページ`も公式サイトで説明されています。  
またコマンドライン・オプションの取り扱いを簡易にしてくれる`args ライブラリ`もあります。

- [Write command-line apps | Dart](https://dart.dev/tutorials/server/cmdline)  
  [https://dart.dev/tutorials/server/cmdline](https://dart.dev/tutorials/server/cmdline)

- [args library - Dart API](https://pub.dev/documentation/args/latest/args/)  
  [https://pub.dev/documentation/args/latest/args/](https://pub.dev/documentation/args/latest/args/)

  - [ArgParser class - args library - Dart API](https://pub.dev/documentation/args/latest/args/ArgParser-class.html)  
    [https://pub.dev/documentation/args/latest/args/ArgParser-class.html](https://pub.dev/documentation/args/latest/args/ArgParser-class.html)

  - [ArgResults class - args library - Dart API](https://pub.dev/documentation/args/latest/args/ArgResults-class.html)  
    [https://pub.dev/documentation/args/latest/args/ArgResults-class.html](https://pub.dev/documentation/args/latest/args/ArgResults-class.html)

- [dart create | Dart](https://dart.dev/tools/dart-create)  
  [https://dart.dev/tools/dart-create](https://dart.dev/tools/dart-create)  
  `$ dart create -t cli my_cli_app` で ArgParserテンプレート付きのプロジェクトも作れます。


### （脱線）
ArgParser オブジェクトを使えば、オプションフラグの追加も簡単だから、  
標準 grep オプションに合わせちゃおう ...そう思っていたことが私にもありました。

Ubuntu 24.04 LTS のターミナルで `$ grep --help`を実行した瞬間、私の心は砕けたのでした。

**Ubuntu 24.04 LTS の grep --help 出力**

```
$ grep --help
Usage: grep [OPTION]... PATTERNS [FILE]...
Search for PATTERNS in each FILE.
Example: grep -i 'hello world' menu.h main.c
PATTERNS can contain multiple patterns separated by newlines.

Pattern selection and interpretation:
  -E, --extended-regexp     PATTERNS are extended regular expressions
  -F, --fixed-strings       PATTERNS are strings
  -G, --basic-regexp        PATTERNS are basic regular expressions
  -P, --perl-regexp         PATTERNS are Perl regular expressions
  -e, --regexp=PATTERNS     use PATTERNS for matching
  -f, --file=FILE           take PATTERNS from FILE
  -i, --ignore-case         ignore case distinctions in patterns and data
      --no-ignore-case      do not ignore case distinctions (default)
  -w, --word-regexp         match only whole words
  -x, --line-regexp         match only whole lines
  -z, --null-data           a data line ends in 0 byte, not newline

その他:
  -s, --no-messages         エラーメッセージを抑止する
  -v, --invert-match        一致しない行を選択する
  -V, --version             バージョン情報を表示して終了する
      --help                このヘルプを表示して終了する

出力の制御:
  -m, --max-count=NUM       NUM 行一致後に中断する
  -b, --byte-offset         出力行と併せてバイトオフセットを表示する
  -n, --line-number         出力行と併せて行番号を表示する
      --line-buffered       行ごとに出力を flush する
  -H, --with-filename       出力行と併せてファイル名を表示する
  -h, --no-filename         出力の先頭にファイル名を付けない
      --label=LABEL         標準入力のファイル名の接頭辞として LABEL を使用する
  -o, --only-matching       show only nonempty parts of lines that match
  -q, --quiet, --silent     suppress all normal output
      --binary-files=TYPE   assume that binary files are TYPE;
                            TYPE is 'binary', 'text', or 'without-match'
  -a, --text                equivalent to --binary-files=text
  -I                        --binary-files=without-match と等価
  -d, --directories=ACTION  ディレクトリーの扱い方を指定する
                            ACTION は 'read'、'recurse' または 'skip'
  -D, --devices=ACTION      デバイス、FIFO およびソケットの扱い方を指定する
                            ACTION は `read' または `skip'
  -r, --recursive           --directories=recurse と等価
  -R, --dereference-recursive  上と同様だがシンボリックリンクを辿る
      --include=GLOB        search only files that match GLOB (a file pattern)
      --exclude=GLOB        skip files that match GLOB
      --exclude-from=FILE   skip files that match any file pattern from FILE
      --exclude-dir=GLOB    skip directories that match GLOB
  -L, --files-without-match  PATTERN に一致しない FILE の名前のみ表示する
  -l, --files-with-matches  PATTERN に一致する FILE の名前のみ表示する
  -c, --count               FILE ごとに一致した行数のみ表示する
  -T, --initial-tab         タブを使用して整列する (必要な場合)
  -Z, --null                FILE の名前を表示した後に値が 0 のバイトを出力する

前後の表示に関する制御:
  -B, --before-context=NUM  一致した前の NUM 行を表示する
  -A, --after-context=NUM   一致した後の NUM 行を表示する
  -C, --context=NUM         一致した前後 NUM 行を表示する
  -NUM                      same as --context=NUM
      --group-separator=SEP  print SEP on line between matches with context
      --no-group-separator  do not print separator for matches with context
      --color[=WHEN],
      --colour[=WHEN]       use markers to highlight the matching strings;
                            WHEN is 'always', 'never', or 'auto'
  -U, --binary              do not strip CR characters at EOL (MSDOS/Windows)

FILE が '-' の場合、標準入力から読み込みます。FILE を指定しない場合、ディレクトリーを再帰的に
処理する場合は '.'、それ以外は '-' となります。FILE を1個だけ指定した場合は -h も有効になります。
終了コードは、行が選択された場合は 0、それ以外は 1 です。エラーが発生して -q を指定していない
場合の終了コードは 2 になります。

Report bugs to: bug-grep@gnu.org
GNU grep のホームページ: <https://www.gnu.org/software/grep/>
General help using GNU software: <https://www.gnu.org/gethelp/>
```

気を取り直して、  
標準 grep の雰囲気を楽しむため最低限これは欲しいよねと欲張ってみました。

1. オプションフラグ無しで、検索パターンと複数ファイルパスの探索ができるようにする。  
   `$ grep ”hello world!” sampl1.txt sammple2.txt`をやりたい。
2. ファイルパスにディレクトリが指定されれば、ディレクトリ内の全ファイルの探索ができるようにする。  
   `$ grep -R ”hello world!” sample/`をやりたい。
3. ファイルパス指定がなければ、標準入力(STDIN)をデータソースにする。  
   `$ cat sample.txt | grep ”hello world!”`をやりたい。
4. パターンマッチ行だけでは寂しいから、ファイル名や行番号の説明追加もしたい。  
   `main.c[15]:    print("hello world!");`のように出力させたい。
5. パターンマッチ部を色付きにしたら視認性がよくなるよね。  
   `$ grep -colour=auto ”hello world!” sampl1.txt sammple2.txt`をやりたい。

この要望から、  
`--regexp`,`--recursive`,`--describe`,`--use-color` オプションを盛り込むことにしました。

- **dgrepのヘルプ出力例**
```
Usage: grep [OPTION]... PATTERNS [FILE]...
Search for PATTERN in each FILE.
Example: grep 'hello world' menu.h main.c
When FILE is not specified, the stdin stream is searched.
PATTERNS can contain multiple patterns separated by newlines.

-e, --regexp            Specifies the regular expression pattern to search.
-r, --recursive         Recursive file search flag for directories.
-d, --describe          Adds a description of the data source and line number.
    --[no-]use-color    Output color options for matched text patterns.
    --debug             Flag to run in the debug mode.
-h, --help              Print this usage information.
```


## 標準入力・標準出力・標準エラー出力を使う
dart言語は、コマンドライン・アプリの開発にも対応していますから、  
コマンドライン・アプリでの入出力は、標準入出力(`stdin`,`stdout`,`stderr`)を使います。

- [dart:io library - Dart API](https://api.dart.dev/dart-io/)
  [https://api.dart.dev/dart-io/](https://api.dart.dev/dart-io/)  

  - [stdin property - dart:io library - Dart API](https://api.dart.dev/dart-io/stdin.html)  
    [https://api.dart.dev/dart-io/stdin.html](https://api.dart.dev/dart-io/stdin.html)

  - [stdout property - dart:io library - Dart API](https://api.dart.dev/dart-io/stdout.html)  
    [https://api.dart.dev/dart-io/stdout.html](https://api.dart.dev/dart-io/stdout.html)  

  - [stderr property - dart:io library - Dart API](https://api.dart.dev/dart-io/stderr.html)  
    [https://api.dart.dev/dart-io/stderr.html](https://api.dart.dev/dart-io/stderr.html)

  - [Stdin class - dart:io library - Dart API](https://api.dart.dev/dart-io/Stdin-class.html)  
    [https://api.dart.dev/dart-io/Stdin-class.html](https://api.dart.dev/dart-io/Stdin-class.html)

  - [Stdout class - dart:io library - Dart API](https://api.dart.dev/dart-io/Stdout-class.html)  
    [https://api.dart.dev/dart-io/Stdout-class.html](https://api.dart.dev/dart-io/Stdout-class.html)


### 出力テキストへの色付けについて
ANSIエスケープシーケンスを使って、標準出力への出力に色付けを行います。

- [ASCII - Wikipedia](https://ja.wikipedia.org/wiki/ASCII)  
  [https://ja.wikipedia.org/wiki/ASCII](https://ja.wikipedia.org/wiki/ASCII)

- [ANSI escape code - Wikipedia](https://en.wikipedia.org/wiki/ANSI_escape_code)  
  [https://en.wikipedia.org/wiki/ANSI_escape_code](https://en.wikipedia.org/wiki/ANSI_escape_code)

```dart
import 'dart:io';

void main() {
  stdout.write('\x1B[31mThis text is red.\x1B[0m\n'); // Red
  stdout.write('\x1B[32mThis text is green.\x1B[0m\n'); // Green
  stdout.write('\x1B[34mThis text is blue.\x1B[0m\n'); // Blue
｝
```

## dart言語ならではのパッケージ公開工夫
前述の通り dart言語は、コマンドラインアプリだけでなくデスクトップやモバイルアプリも作れます。  

grepコマンドラインアプリの **検索パターンを使ってディレクトリ内の全ファイルを探索する中核機能** は、  
コマンドラインアプリにだけにかかわらず、デスクトップやモバイルアプリでも利用できそうです。

dart言語では、`lib/`ディレクトリ直下に配置したコードファイル ⇒ ライブラリ ⇒ パッケージが、  
外部からアクセス可能な公開パッケージ（公開ファイル）となります。

そこでコマンドラインアプリとして必要な API を公開する `lib/grep_cli.dart`ファイルと、  
grep中核機能に必要な API を公開する `lib/grep_api.dart`ファイルに公開パッケージを分けています。

- **備考**  
  `grep_cli.dart`と`grep_api.dart`のファイルの中身は、  
  いずれともに公開する`lib/src/`配下のファイルを`export`指定しているだけです。 


### コマンドラインアプリ API と 中核機能用 API の分離
プロジェクトでは、コマンドラインアプリ関連の機能を `lib/src/cli_foundation`ディレクトリに配置し、  
grep中核機能を `lib/src/api_foundation`ディレクトリに配置して、ドメイン機能を分離しています。


### 分離した API どうしの接合のため Stream を使っています。
コマンドラインアプリと中核機能を分離するにあたり、ユーザ入出力を抽象化 ⇒ 分離する必要があります。

コマンドラインアプリなら標準入出力を使ってユーザとの入出力を行いますが、  
デスクトップやモバイルアプリでは、専用のダイアログやユーザーインターフェースを用いるでしょう。

このため中核機能APIで、検索パターンに合致した行を出力する際に、標準出力への書き込みを直書きすると  
デスクトップやモバイルアプリからの利用に制限が出てしまうので、何らかの方法で分離する必要があります。  
さらにコマンドラインアプリでも、モバイルアプリであっても透過的に扱える ⇒ 接合できる必要もあります。

このためプロジェクトでは、Stream ⇒ StreamController を使って、入出力を中核機能APIから分離しています。


- [Asynchronous programming: Streams | Dart](https://dart.dev/libraries/async/using-streams)  
  [https://dart.dev/libraries/async/using-streams](https://dart.dev/libraries/async/using-streams)

  - [Stream class - dart:async library - Dart API](https://api.dart.dev/dart-async/Stream-class.html)  
    [https://api.dart.dev/dart-async/Stream-class.html](https://api.dart.dev/dart-async/Stream-class.html)

  - [StreamController class - dart:async library - Dart API](https://api.dart.dev/dart-async/StreamController-class.html)  
    [https://api.dart.dev/dart-async/StreamController-class.html](https://api.dart.dev/dart-async/StreamController-class.html)


## バイナリ実行ファイルを作る
dart言語で作成したコマンドラインアプリから、ネイティブのバイナリ実行ファイルも作れます。  
プロジェクトの`bin/dgrep_mac`の intel mac バイナリ実行ファイルは、dart compile コマンドで作りました。

各環境ネイティブのコマンドラインアプリのバイナリ実行ファイルを作るには、  
各プラットフォーム用の Dart/Flutter開発環境で、`dart compile exe`コマンドを実行するだけです。

- [dart compile | Dart](https://dart.dev/tools/dart-compile)  
  [https://dart.dev/tools/dart-compile](https://dart.dev/tools/dart-compile)

  - [Self-contained executables (exe)](https://dart.dev/tools/dart-compile#exe)  
    `dart compile exe`コマンドの説明項目です。


### バイナリ実行ファイル作成具体例
intel mac バイナリ実行ファイル `bin/dgrep_mac`の作成には、
1. intel mac 用の Dart/Flutter開発環境を構築してコマンドラインアプリを作り、  
2. `dart run bin/grep_cli.dart`でコマンドラインアプリが機能することを確認したら、
3. `dart compile exe bin/grep_cli.dart -o bin/dgrep_mac` を実行してください。
4. Ubuntu/Linux 上でDart/Flutter開発環境を構築されていれば、このプロジェクトをクローンして  
   `dart compile exe bin/grep_cli.dart -o bin/dgrep_ubuntu` を実行してみて下さい。



