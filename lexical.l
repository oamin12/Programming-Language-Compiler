%{
    #include "parser.tab.h"
    #include <stdlib.h>
    #include <stdio.h>
    #include<string.h>
    // int yylval;
    int yyerror(char *s); 
    extern int yylineno;
	int yylex();
%}


%%

"int" {return INT;}
"float" {return FLOAT;}
"char" {return CHAR;}
"string" {return STRING;}
"bool" {return BOOL;}
"void" {return VOID;}

"if" {return IF;}
"else" {return ELSE;}
"while" {return WHILE;}
"do" {return DO;}
"for" {return FOR;}
"switch" {return SWITCH;}
"case" {return CASE;}
"default" {return DEFAULT;}
"break" {return BREAK;}
"continue" {return CONTINUE;}
"return" {return RETURN;}


"NULL" {return NULLL;}
"const" {return CONST;}
"TRUE" {return TRUEE;}
"FALSE" {return FALSEE;}


"++" {return INCREMENT;}
"--" {return DECREMENT;}
"==" {return EQUAL;}
"!=" {return NOTEQUAL;}

"<" {return LESSTHAN;}
">" {return GREATERTHAN;}
"<=" {return LESSTHANEQUAL;}
">=" {return GREATERTHANEQUAL;}

"&&" {return AND;}
"||" {return OR;}
"!" {return NOT;}

    /* "+" {return PLUS;}
    "-" {return MINUS;}
    "*" {return MULTIPLY;}
    "/" {return DIVIDE;}
    "=" {return ASSIGN;} */
    /* "%" {return MODULO;} */




";" {return ';';}
":" {return ':';}
"," {return ',';}


[()]     { return *yytext; }

[ \t]       ; 


    /* "//" {while(input() != '\n'); return EOL;}
    "/*" {char c; char p = 0; while((c = input()) != 0) {if(p == '*' && c == '/') break; p = c;} return EOL;} */

[a-zA-Z][a-zA-Z0-9_]* {yylval = strdup(yytext); return IDENTIFIER;}
((0)|([1-9][0-9]*)) {yylval = atoi(yytext); return INTGER_NUMBER;}
[0-9]*\.[0-9]+ | [0-9]+\.[0-9]* {yylval = atof(yytext); return FLOAT_NUMBER;}
\"[^\"]*\" {yylval = strdup(yytext); return STRING_IDENTIFIER;}
\'[^\'\"]\' {yylval = yytext[0]; return CHAR_IDENTIFIER;}
. {return yytext[0];}

%%


int yywrap() {return 1;}



