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
    #include "Parser.tab.h"
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
"short" {return SHORT;}
"long" {return LONG;}   
"double" {return DOUBLE;}
"void" {return VOID;}
"unsigned" {return UNSIGNED;}


"if" {return IF;}
"else" {return ELSE;}
"while" {return WHILE;}
"do" {return DO;}
"for" {return FOR;}
"switch" {return SWITCH;}
"case" {return CASE;}
"break" {return BREAK;}
"continue" {return CONTINUE;}
"return" {return RETURN;}
"printf" {return PRINTF;}
"scanf" {return SCANF;}
"function" {return FUNCTION;}



"define" {return DEFINE;}
"ifdef" {return IFDEF;}
"endif" {return ENDIF;}
"ifndef" {return IFNDEF;}


"NULL" {return NULL;}

"TRUE" {return TRUE;}
"FALSE" {return FALSE;}


"abs" {return ABS;}
"atof" {return ATOF;}
"atoi" {return ATOI;}
"atol" {return ATOL;}
"cos" {return COS;}
"sin" {return SIN;}
"tan" {return TAN;}
"exp" {return EXP;}
"log" {return LOG;}
"pow" {return POW;}
"sqrt" {return SQRT;}
"ceil" {return CEIL;}
"floor" {return FLOOR;}
"rand" {return RAND;}


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

"+" {return PLUS;}
"-" {return MINUS;}
"*" {return MULTIPLY;}
"/" {return DIVIDE;}
"%" {return MODULO;}
"=" {return ASSIGN;}

[()]     { return *yytext; }

[ \t]       ; 

";" {return SEMICOLON;}
":" {return COLON;}
"," {return COMMA;}


"//" {while(input() != '\n'); return EOL;}
"/*" {char c; char p = 0; while((c = input()) != 0) {if(p == '*' && c == '/') break; p = c;} return EOL;}

[a-zA-Z][a-zA-Z0-9_]* {yylval = strdup(yytext); return IDENTIFIER;}
(0|[1-9][0-9]*) {yylval = atoi(yytext); return NUMBER;}
[0-9]*\.[0-9]+ | [0-9]+\.[0-9]* {yylval = atof(yytext); return FLOAT_NUMBER;}
0b[01]+ {yylval = strtol(yytext, NULL, 2); return BINARY_NUMBER;} 
0[0-7]+ {yylval = strtol(yytext, NULL, 8); return OCTAL_NUMBER;}
0x[0-9a-fA-F]+ {yylval = strtol(yytext, NULL, 16); return HEXADECIMAL_NUMBER;}
\"[^\"]*\" {yylval = strdup(yytext); return STRING_IDENTIFIER;}
. {return yytext[0];}




%%


int yywrap() {return 1;}
int yyerror(char *s) {
    fprintf(stderr, "Error: %s at line %d\n", s, yylineno);
    return 0;
}
int main() {
    yyparse();
    return 0;
}


