/* Part1 - Definitions */
%{
    #include <stdio.h>
    #include <stdlib.h>
    
    void yyerror(char* s);
    int yylex();
%}

%union {
  int i;
}
%type <i> E T N
%token <i> INTEGER

/* End of Part1 */ 


/*Part2 - Production Rules*/
%%

S : E                 { printf("%d\n", $1); }
  ;


E : E '+' T           { $$ = $1 + $3; }
  | E '-' T           { $$ = $1 - $3; }
  | T                 { $$ = $1; }
  ;

T : T '*' N           { $$ = $1 * $3; }
  | T '/' N           { $$ = $1 / $3; }
  | N                 { $$ = $1; }
  ;

N : '(' E ')'         { $$ = $2; }
  | '-' N             { $$ = -1*$2; }
  | INTEGER           { $$ = $1; }
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