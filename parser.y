/* Part1 - Definitions */
%{
    #include <stdio.h>
    #include <stdlib.h>
    #include "SymbolTree/SymbolTree.h"
    
    void yyerror(char* s);
    int yylex();

    SymbolTree MotherSymbolTree;
%}

%union {
  int intValue;
  char* stringValue;
  float floatValue;
  char chrValue;
  int boolValue;
  char* idValue;
}

%start S

%token <intValue> INTGER_NUMBER
%token <floatValue> FLOAT_NUMBER
%token <stringValue> STRING_IDENTIFIER
%token <chrValue> CHAR_IDENTIFIER
%token <boolValue> TRUEE FALSEE

%token <stringValue> INT FLOAT CHAR STRING BOOL VOID

%token NULLL CONST

%token INCREMENT DECREMENT

%token GREATERTHANEQUAL LESSTHANEQUAL GREATERTHAN LESSTHAN NOTEQUAL EQUAL

%token AND OR NOT

%token IF ELSE WHILE FOR DO BREAK CONTINUE RETURN SWITCH CASE DEFAULT

%token <idValue> IDENTIFIER

%type <stringValue> dataTypes
%type <idValue> ID

/* End of Part1 */ 
%right '='
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
line : dataTypes ID '=' expression';'         { 
                                                printf("Variable Declaration: Name: %s, Type: %s\n", $2, $1);
                                                
                                                bool isContained = MotherSymbolTree.currentTable->contains($2);
                                                if(isContained){
                                                  printf("Variable already declared\n");
                                                }else{
                                                  // $2 is the ID and $1 is the data type
                                                  SymbolEntry* entry = new SymbolEntry($2, $1);
                                            
                                                  // Add the entry to the symbol table
                                                  MotherSymbolTree.currentTable->insert(entry); 
                                                  printf("Variable added to the symbol table\n");
                                                }
                                              }
      | CONST dataTypes ID '=' expression';' {
                                                printf("Constant Declaration: Name: %s, Type: %s\n", $3, $2);
                                                
                                                bool isContained = MotherSymbolTree.currentTable->contains($3);
                                                if(isContained){
                                                  printf("Variable already declared\n");
                                                }else{
                                                  // $3 is the ID and $2 is the data type
                                                  SymbolEntry* entry = new SymbolEntry($3, $2);
                                                  entry->isConstant = true;
                                            
                                                  // Add the entry to the symbol table
                                                  MotherSymbolTree.currentTable->insert(entry); 
                                                  printf("Variable added to the symbol table\n");
                                                }
                                              }
      | ID '=' expression';' {
                                printf("Variable Assignment: Name: %s\n", $1);
                                
                                SymbolTable* table = MotherSymbolTree.getScopeSymbolTable($1);
                                if(table == NULL){
                                  printf("Variable not declared\n");
                                }else{
                                  SymbolEntry* entry = table->getEntry($1);
                                  if(entry->isConstant){
                                    printf("Variable is constant\n");
                                  }else{
                                    printf("Variable is not constant\n");
                                  }
                                }
                              }
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

dataTypes : INT { $$ = $1; 
                  printf("Data Type: %s\n", $1);
                }
          | FLOAT {$$ = $1;}
          | CHAR {$$ = $1;}
          | STRING {$$ = $1;}
          | BOOL {$$ = $1;}
          | VOID {$$ = $1;}
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

ID : IDENTIFIER {$$ = $1;}
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