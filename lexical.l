%{
    #include "y.tab.h"
    #include <stdlib.h>
    #include <stdio.h>
    #include<string.h>
    // int yylval;
    int yyerror(char *s); 
    extern int yylineno;
	int yylex();
%}


%%

"int" {yylval.stringValue = strdup(yytext); return INT;}
"float" {yylval.stringValue = strdup(yytext); return FLOAT;}
"char" {yylval.stringValue = strdup(yytext); return CHAR;}
"string" {yylval.stringValue = strdup(yytext); return STRING;}
"bool" {yylval.stringValue = strdup(yytext); return BOOL;}
"void" {yylval.stringValue = strdup(yytext); return VOID;}

"if" {yylval.stringValue = strdup(yytext); return IF;}
"else" {yylval.stringValue = strdup(yytext); return ELSE;}
"while" {yylval.stringValue = strdup(yytext); return WHILE;}
"do" {yylval.stringValue = strdup(yytext); return DO;}
"for" {yylval.stringValue = strdup(yytext); return FOR;}
"switch" {yylval.stringValue = strdup(yytext); return SWITCH;}
"case" {yylval.stringValue = strdup(yytext); return CASE;}
"default" {yylval.stringValue = strdup(yytext); return DEFAULT;}
"break" {yylval.stringValue = strdup(yytext); return BREAK;}
"continue" {yylval.stringValue = strdup(yytext); return CONTINUE;}
"return" {yylval.stringValue = strdup(yytext); return RETURN;}


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

[a-zA-Z][a-zA-Z0-9_]* {yylval.idValue = strdup(yytext); return IDENTIFIER;}
((0)|([1-9][0-9]*)) {yylval.intValue = atoi(yytext); return INTGER_NUMBER;}
[0-9]*\.[0-9]+ | [0-9]+\.[0-9]* {yylval.floatValue = atof(yytext); return FLOAT_NUMBER;}
\"[^\"]*\" {yylval.stringValue = strdup(yytext); return STRING_IDENTIFIER;}
\'[^\'\"]\' {yylval.chrValue = yytext[0]; return CHAR_IDENTIFIER;}
. {return yytext[0];}

%%


int yywrap() {return 1;}



