/* Define If-then-else statement, while loops, repeat-until loops, for loops, switch
statement. */
/* Define the following operators: +, -, *, /, %, =, ==, !=, <, >, <=, >=, &&, ||, !, ++, -- */
/* Define the following data types: int, float, char, string, array, pointer */
/* Define the following functions: printf, scanf, malloc, free, exit, return, main */
/* Define the following preprocessor directives: #include, #define, #ifdef, #endif, #ifndef, #else */
/* Define the following standard libraries: stdio.h, stdlib.h, string.h, math.h, time.h */
/* Define the following standard constants: NULL, EOF, TRUE, FALSE, PI, E, EXIT_SUCCESS, EXIT_FAILURE */
/* Define the following standard functions: abs, atof, atoi, atol, cos, sin, tan, exp, log, pow, sqrt, ceil, floor, rand, srand, time, clock, difftime, mktime, localtime, asctime, ctime, strftime, memcpy, memmove, memset, memcmp, strcmp, strncmp, strcpy, strncpy, strcat, strncat, strlen, strchr, strrchr, strstr, strtok, atoi, atol, atof, itoa, ltoa, ftoa, atoi, atol, atof, itoa, ltoa, ftoa, malloc, calloc, realloc, free, exit, return, main */
/* Define the following standard macros: NULL, EOF, TRUE, FALSE, PI, E, EXIT_SUCCESS, EXIT_FAILURE */


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


"NULL" {return NULL;}
"const" {return CONST;}
"TRUE" {return TRUE;}
"FALSE" {return FALSE;}


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




";" {return SEMICOLON;}
":" {return COLON;}
"," {return COMMA;}


[()]     { return *yytext; }

[ \t]       ; 


"//" {while(input() != '\n'); return EOL;}
"/*" {char c; char p = 0; while((c = input()) != 0) {if(p == '*' && c == '/') break; p = c;} return EOL;}

[a-zA-Z][a-zA-Z0-9_]* {yylval = strdup(yytext); return IDENTIFIER;}
(0|[1-9][0-9]*) {yylval.intg = atoi(yytext); return INTGER_NUMBER;}
[0-9]*\.[0-9]+ | [0-9]+\.[0-9]* {yylval = atof(yytext); return FLOAT_NUMBER;}
\"[^\"]*\" {yylval = strdup(yytext); return STRING_IDENTIFIER;}
\'[^\'\"]\' {yylval = yytext[0]; return CHAR_IDENTIFIER;}
. {return yytext[0];}

%%


int yywrap() {return 1;}



