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

### （脱線）
ArgParser オブジェクトを使えば、オプションフラグの追加も簡単だから、  
標準 grep オプションに合わせちゃおう ...そう思っていたことが私にもありました。

Ubuntu 24.04 LTS のターミナルで `$ grep --help`を実行した瞬間、私の心は砕けたのでした。

**Ubuntu 24.04 LTS の grep --help 出力**

```bash
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