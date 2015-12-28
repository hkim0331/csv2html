all:
	@echo "'make sample' creates sample from sample.csv in public folder."
	@echo "'make start' starts webrick."
	@echo "'make stop' stops webrick."
	@echo "'make clean' do cleanup."

sample:
	./csv2html.rb --input sample.csv --outdir public --title sample --database sqlite3.db

# server は ruby の HTTP サーバ。
start:
	./server --root public 2>&1 | ./pid.rb &

stop:
	kill -INT `cat pid`
	${RM} pid

clean:
	${RM} *.bak
	${RM} -rf public
