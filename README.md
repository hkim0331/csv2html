# csv2html

巷の csv2html は csv ファイルの内容を html のテーブルに変換するものがほとんど。
これだと、複数のユーザでテーブルを書き換えるのに十分ではない。

ユーザ全員が Google や iCloud のアカウントを持っており、
書類を共有できればおしまいなのだが、そうでないユーザグループのために作成。

csv の内容を RDB (sequel) に反映し、cgi でそのテーブルを書き換える。

## require

* ruby
* sqlite3
* sequel

## usage

ファイル input.csv の内容を out/index.cgi に変換する。

````
$ ./csv2html.rb --input input.csv --out out
````

この後、http サーバから out/index.cgi をブラウズし、目的のセルを書き換え、
リターンキーでデータベースに反映する。

## author

hiroshi.kimura.0331@gmail.com

