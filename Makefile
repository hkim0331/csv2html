sample:
	./csv2html.rb --input sample.csv --out out --title sample --database sqlite3.db

# server は ruby の HTTP サーバ。
start:
	./server --root out 2>&1 | ./pid.rb &

stop:
	kill -INT `cat pid`
	${RM} pid

clean:
	${RM} *.bak
	${RM} -rf out
