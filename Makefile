sample:
	./csv2html.rb --input sample.csv --out out --title sample --database sqlite3.db

# server は ruby の HTTP サーバ。
run:
	server --root out

clean:
	rm -rf out
