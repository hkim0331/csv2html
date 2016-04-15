all:
	@echo "'make sample' creates sample from sample.csv in public folder."
	@echo "'make start' starts webrick."
	@echo "'make clean' do cleanup."

sample:
	./csv2html.rb --input data/sample.csv --outdir public --title sample --database sqlite3.db

h28:
	./csv2html.rb --input data/h28_masters.csv --outdir public --title 'H28 博士課程前期' --database sqlite3.db

start:
	./server.rb --root public

clean:
	${RM} *.bak
	${RM} public/*
