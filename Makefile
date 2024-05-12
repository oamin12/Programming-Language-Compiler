all: 	
		flex lexical.l
		bison -y -d parser.y
		g++ SymbolTable/SymbolTable.cpp SymbolTree/SymbolTree.cpp y.tab.c lex.yy.c -o compiler.exe

clean:  
		del *.o
		del y.tab.c y.tab.h y.tab.o lex.yy.c lex.yy.o
		del compiler.exe