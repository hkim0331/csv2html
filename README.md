# csv2html

巷の csv2html は csv ファイルの内容を html のテーブルに変換するものがほとんど。
これだと、複数のユーザでテーブルを共有し、書き換えるのに十分ではない。

ユーザ全員が Google や iCloud のアカウントを持っており、
書類を共有できればおしまいなのだが、そうでないユーザグループのために作成。

csv の内容を RDB (sqlite3) に反映し、cgi でそのテーブルを書き換える。

## require

* ruby
* sqlite3
* sequel

## usage

ファイル input.csv の内容を public/index.cgi に変換する。
データベースは public/sqlite3.db。

````
$ ./csv2html.rb --input input.csv --outdir public --db sqlite3.db --title title
````

この後、http サーバから public/index.cgi をブラウズできる。
ページのタイトル(h1で囲み）は title。
表示したページ上、目的のセルのテキストを書き換え後、
リターンキーでデータベースに反映する。

## TODO

* ノート、キャプション？補足説明 --- テーブルのほかに表示したいテキストもある。
* アップデートしたのがわかりにくい。
* 行幅をコマンドライン、あるいは、ページ上から指定できるようにする。
* 行番号、列番号を表示するか？ -- 列番号 done. 行のタイトルもデータベースに？
* [SOLVED: CSS --- テーブルの列の間が上下に広すぎる。by form {margin:0px;}]
* [SOLVED: 実行の度に rm -r out はめんどくさいぞ。by 'make clean'.]

## author

hiroshi.kimura.0331@gmail.com
