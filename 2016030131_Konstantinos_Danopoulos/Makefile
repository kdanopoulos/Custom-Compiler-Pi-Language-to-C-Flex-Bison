

all: bison flex gcc

bison: myanalyzer.y
	bison -d -v -r all myanalyzer.y
flex: mylexer.l
	flex mylexer.l
gcc: myanalyzer.tab.c lex.yy.c cgen.c
	gcc -o mycompiler myanalyzer.tab.c lex.yy.c cgen.c -lfl
clean_some:
	rm -rf myanalyzer.tab.c
	rm -rf myanalyzer.tab.h
	rm -rf lex.yy.c
	rm -rf myanalyzer.output
clean:
	rm -rf mycompiler
	rm -rf myanalyzer.tab.c
	rm -rf myanalyzer.tab.h
	rm -rf lex.yy.c
	rm -rf myanalyzer.output