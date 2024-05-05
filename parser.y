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
      | BREAK ';'
      | CONTINUE ';'
      | ifStatement {}
      | forLoop {}
      | whileLoop {}
      | doWhileLoop ';' {}
      | switchCase {}
      | function {}
      | blockScope {}
      | functionCall ';' {} 
      | returnStatement ';' {}
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
            | functionCall {}
            ;

mathExpression : math1 {}
               ;

/* ########################## MATHEMATICAL EXPRESSIONS  ##########################*/
/* math1 is + - */
/* math2 is * / */
/* math3 is ( ) -ID -NUMBER ++ID --ID */
math1 : math1 '+' math2 {}
      | math1 '-' math2 {}
      | math2 {}
      ;

math2 : math2 '*' math3 {}
      | math2 '/' math3 {}
      | math2 '%' math3 {}
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
              | NULLL {}
              | INCREMENT ID {}
              | DECREMENT ID {}
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
ifStatement : IF '(' boolExpression ')' blockScope { }
            | IF '(' boolExpression ')' blockScope ELSE blockScope {  }
            | IF '(' boolExpression ')' blockScope ELSE ifStatement {  }
            ;

/* ########################## SWITCH CASE ########################## */ 
switchCase : SWITCH '(' ID ')' '{' caseStatements '}' { }
           ;

caseStatements : caseStatements caseStatement {}
               | caseStatement {}
               ;

caseStatement : CASE caseIdentifier ':' Code {}
              | DEFAULT ':' Code {}
              ;

caseIdentifier : INTGER_NUMBER {}
               | CHAR_IDENTIFIER {}
               ;


/* ########################## LOOPS  ##########################*/
forLoop : FOR '(' forLoopExpression  ';' forLoopCondition ';' forLoopIncDecExpression ')' blockScope { }
        ;

forLoopCondition : boolExpression {}
                 | epsilon {}
                 ;

forLoopIncDecExpression : ID '=' expression {}
                        | INCREMENT ID  {}
                        | DECREMENT ID  {}
                        | ID INCREMENT {}
                        | ID DECREMENT {}
                        | epsilon {}
                        ;

forLoopExpression : expression {}
                  | dataTypes ID '=' expression {}
                  | ID '=' expression {}
                  | epsilon {}
                  ;

whileLoop : WHILE '(' boolExpression ')' blockScope { }
          ;

doWhileLoop : DO blockScope WHILE '(' boolExpression ')' { }
            ;


/* ########################## FUNCTIONS ##########################*/
function : dataTypes ID '(' functionParameters ')' blockScope { }
         | dataTypes ID '(' functionParameters ')' ';' { }
         ;

functionParameters : functionParameters ',' dataTypes ID {}
                   | dataTypes ID {}
                   | epsilon {}
                   ;

functionCall : ID '(' functionCallParameters ')'{ }
             ;

functionCallParameters : functionCallParameters ',' expression {}
                       | expression {}
                       | epsilon {}
                       ;

/* ########################## BLOCK SCOPES ##########################*/
blockScope : '{' Code '}' { }
           | '{' '}' { }
           ;

/* ########################## RETURN ##########################*/
returnStatement : RETURN expression { }
                | RETURN { }
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