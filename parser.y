/* Part1 - Definitions */
%{
    #include <stdio.h>
    #include <stdlib.h>
    
    void yyerror(char* s);
    int yylex();
%}

/* %union {
  int intg;
  char* str;
  float flt;
  char chr;
  bool bl;
  void voidd;

} */

%start S

%token  INTGER_NUMBER
%token  FLOAT_NUMBER
%token  STRING_IDENTIFIER
%token  CHAR_IDENTIFIER
%token  TRUEE FALSEE

%token INT FLOAT CHAR STRING BOOL VOID

%token NULLL CONST

%token INCREMENT DECREMENT

%token GREATERTHANEQUAL LESSTHANEQUAL GREATERTHAN LESSTHAN NOTEQUAL EQUAL

%token AND OR NOT

%token IF ELSE WHILE FOR DO BREAK CONTINUE RETURN SWITCH CASE DEFAULT

%token IDENTIFIER
/* End of Part1 */ 
%left '='
%left '+' '-'
%left '*' '/' '%'


/*Part2 - Production Rules*/
%%

S : Code                 {}
  ;


Code : line {}
     | Code line {}
     ;


/* Variable Declaration */
line : dataTypes ID '=' expression';' {}
      | CONST dataTypes ID '=' expression';' {}
      | ID '=' expression';' {}
      | ifStatement {}
      | forLoop {}
      | whileLoop {}
      ;

dataTypes : INT {}
          | FLOAT {}
          | CHAR {}
          | STRING {}
          | BOOL {}
          | VOID {}
          ;

/* Expression */
expression : mathExpression {}
            | boolExpression {}
            ;

mathExpression : math1 {}
               ;

/* ########################## MATHEMATICAL EXPRESSIONS  ##########################*/
/* math1 is + - */
/* math2 is * / */
/* math3 is ( ) -ID -NUMBER */
math1 : math1 '+' math2 {}
      | math1 '-' math2 {}
      | math2 {}
      ;

math2 : math2 '*' ID_OR_NUMBER {}
      | math2 '/' ID_OR_NUMBER {}
      | math2 '%' ID_OR_NUMBER {}
      | math3 {}
      ;

math3 : '(' math1 ')' {}
      | '-'math1 {}
      | ID_OR_NUMBER {}
      ;


ID_OR_NUMBER : INTGER_NUMBER {}
              | FLOAT_NUMBER {}
              | CHAR_IDENTIFIER {}
              | STRING_IDENTIFIER {}
              | ID {}
              ;


/* ########################## BOOLEAN EXPRESSIONS  ##########################*/
/* bool1 is > < >= <= */
boolExpression : boolExpression AND boolExpression {}
                | boolExpression OR boolExpression {}
                | NOT boolExpression {}
                | expression boolComaparitors expression {}
                | boolean {}
                ;

boolean : TRUEE {}
        | FALSEE {}
        ;

boolComaparitors : GREATERTHANEQUAL {}
                | LESSTHANEQUAL {}
                | GREATERTHAN {}
                | LESSTHAN {}
                | NOTEQUAL {}
                | EQUAL {}
                ;

/* ########################## IF-ELSE EXPRESSIONS  ##########################*/
ifStatement : IF '(' boolExpression ')' '{' Code '}' { }
            | IF '(' boolExpression ')' '{' Code '}' ELSE '{' Code '}' {  }
            | IF '(' boolExpression ')' '{' Code '}' ELSE ifStatement {  }
            ;


/* ########################## LOOPS  ##########################*/
forLoop : FOR '(' mathExpression | epsilon  ';' boolExpression ';' line ')' '{' Code '}' { }
        ;

whileLoop : WHILE '(' boolExpression ')' '{' Code '}' { }
          ;

epsilonOrExpression : epsilon {}
                    | expression {}
                    ;

epsilon : {}
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