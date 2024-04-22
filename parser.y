/* Part1 - Definitions */
%{
    #include <stdio.h>
    #include <stdlib.h>
    
    void yyerror(char* s);
    int yylex();
%}

%union {
  int intg;
  char* str;
  float flt;
  char chr;
  bool bl;
  void voidd;

}
%type  E T N
%token <intg> INTGER_NUMBER
%token <flt> FLOAT_NUMBER
%token <str> STRING_IDENTIFIER
%token <chr> CHAR_IDENTIFIER
%token <bl> TRUE FALSE

%token INT FLOAT CHAR STRING BOOL VOID

%token NULL CONST

%token INCREMENT DECREMENT

%token GREATERTHANEQUAL LESSTHANEQUAL GREATERTHAN LESSTHAN NOTEQUAL EQUAL

%token AND OR NOT

%token IF ELSE WHILE FOR DO BREAK CONTINUE RETURN SWITCH CASE DEFAULT

%token IDENTIFIER
/* End of Part1 */ 
%left '='
%left '+' '-'
%left '*' '/'

/*Part2 - Production Rules*/
%%

S : Code                 { printf("%d\n", $1); }
  ;


Code : Code E ';' {}
     | E ';' {}
     ;


/* Variable Declaration */
E :  INT ID '=' INTGER_NUMBER';' { $$ = $4; }
  | FLOAT ID '=' FLOAT_NUMBER';' { $$ = $4; }
  | CHAR ID '=' STRING_IDENTIFIER';' { $$ = $4; }
  | STRING ID '=' CHAR_IDENTIFIER';' { $$ = $4; }
  | BOOL ID '=' TRUE';' { $$ = $4; }
  | BOOL ID '=' FALSE';' { $$ = $4; }
  | ID '=' INTGER_NUMBER';' { $$ = $3; }
  | ID '=' FLOAT_NUMBER';' { $$ = $3; }
  | ID '=' STRING_IDENTIFIER';' { $$ = $3; }
  | ID '=' CHAR_IDENTIFIER';' { $$ = $3; }
  | ID '=' TRUE';' { $$ = $3; }
  | ID '=' FALSE';' { $$ = $3; }
  | T { $$ = $1; }
  ;

T : T '+' N { $$ = $1 + $3; }
  | T '-' N { $$ = $1 - $3; }
  | N { $$ = $1; }
  ;

N : N '*' ID_OR_NUMBER { $$ = $1 * $3; }
  | N '/' ID_OR_NUMBER { $$ = $1 / $3; }
  | N '%' ID_OR_NUMBER { $$ = $1 % $3; }
  | ID_OR_NUMBER
  | '(' T ')' { $$ = $2; }
  | '-' ID_OR_NUMBER { $$ = -$2; }

ID_OR_NUMBER : INTGER_NUMBER {}
   | ID {}

   ;


ID : IDENTIFIER {}
   ;


%%  
/* End of Part2 */ 


/*Part3 - Subroutines*/
void yyerror(char *msg){
  fprintf(stderr, "%s\n", msg);
  exit(1);
}

int main(){
  yyparse();
  return 0;
}