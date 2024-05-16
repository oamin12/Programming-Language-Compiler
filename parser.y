/* Part1 - Definitions */
%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include "SymbolTree/SymbolTree.h"
    #include "SemanticChecks/SemanticChecker.h"
    #include "utils.cpp"
    #include "Quadraples/Quadraples.h"
    
    void yyerror(char* s);
    int yylex();

    Quadraples quad;

    SymbolTree MotherSymbolTree;
    SemanticChecker sc;
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

%token <stringValue> NULLL CONST

%token <stringValue> INCREMENT DECREMENT

%token <stringValue> GREATERTHANEQUAL LESSTHANEQUAL GREATERTHAN LESSTHAN NOTEQUAL EQUAL

%token <stringValue> AND OR NOT

%token <stringValue> IF ELSE WHILE FOR DO BREAK CONTINUE RETURN SWITCH CASE DEFAULT

%token <idValue> IDENTIFIER

%type <stringValue> dataTypes boolComparators STRING_LITERALS mathExpression boolExpression expression functionCall blockScope returnStatement forLoopIncDecExpression beginScope
%type <boolValue> boolean
%type <idValue> ID
%type <intValue> INT_LITERAL caseIdentifierInt
%type <floatValue> FLOAT_LITERAL math1 math2 math3
%type <chrValue> CHAR_LITERAL caseIdentifierChar 

/* End of Part1 */ 
%right '='
%right ELSE
%left '+' '-'
%left '*' '/' '%'




/*Part2 - Production Rules*/
%%

S : Code                 {}
  ;


Code : line { 
            quad.printQuadraples();
            }
     | Code line {}
     ;


/* Variable Declaration */
line : dataTypes ID '=' expression';'         { 
                                                printf("Variable Declaration: Name: %s, Type: %s, value: %s\n", $2, $1, $4);
                                                
                                                bool isContained = MotherSymbolTree.currentTable->contains($2);
                                                if(isContained){
                                                  printf("Variable already declared\n");
                                                }else{
                                                  char* expressionType = sc.determineType($4);

                                                  if(sc.matchTypes($1, expressionType)){
                                                    printf("Type Match type1 = %s, type2 = %s\n", $1, expressionType);
                                                    // $2 is the ID and $1 is the data type
                                                    SymbolEntry* entry = new SymbolEntry($2, $1, $4, true);
                                                    //add to quadruple
                                                    printf("Inserting variable: %s\n", $2);
                                                    quad.unaryOperation("MOV", $2);
                                                    quad.resetCount();
                                                    quad.clearVariablesStack();
                                                    

                                                    // Add the entry to the symbol table
                                                    MotherSymbolTree.currentTable->insert(entry); 
                                                    printf("Variable added to the symbol table\n");
                                                    // MotherSymbolTree.currentTable->printTable();
                                                  }
                                                  else
                                                    printf("Type Mismatch type1 = %s, type2 = %s\n", $1, expressionType);
                                                }                                      
                                                

                                              }
      | CONST dataTypes ID '=' expression';' {
                                                printf("Constant Declaration: Name: %s, Type: %s\n", $3, $2);
                                                
                                                bool isContained = MotherSymbolTree.currentTable->contains($3);
                                                if(isContained){
                                                  printf("Variable already declared\n");
                                                }else{
                                                  // $3 is the ID and $2 is the data type
                                                  SymbolEntry* entry = new SymbolEntry($3, $2, $5, true, true);
                                                  //add to quadruple
                                                  quad.unaryOperation("MOV", $2);
                                                  quad.resetCount();
                                                  quad.clearVariablesStack();
                                                  // Add the entry to the symbol table
                                                  MotherSymbolTree.currentTable->insert(entry); 
                                                  printf("Variable added to the symbol table\n");
                                                }
                                              }
      | ID '=' expression';' {
                                printf("Variable Assignment: Name: %s\n", $1);
                                
                                SymbolTable* table = MotherSymbolTree.getScopeSymbolTable($1);
                                if(table == NULL){
                                  printf("Variable is not declared\n");
                                }else{
                                  SymbolEntry* entry = table->getEntry($1);
                                  //add to quadruple
                                  
                                  if(entry->isConstant){
                                    printf("Error! Variable is constant\n");
                                  }else{
                                    quad.unaryOperation("MOV", $1);
                                    quad.printQuadraples();
                                    quad.resetCount();
                                    quad.clearVariablesStack();
                                    printf("Variable is not constant\n");
                                    entry->value = $3;
                                    entry->isInitialised = true;
                                    printf("Variable intialized to the symbol table\n");
                                    MotherSymbolTree.currentTable->printTable();
                                  }
                                }
                              }
      | dataTypes ID ';' { 
                            printf("Variable Declaration: Name: %s, Type: %s\n", $2, $1);
                            
                            bool isContained = MotherSymbolTree.currentTable->contains($2);
                            if(isContained){
                              printf("Variable already declared\n");
                            }else{
                              // $2 is the ID and $1 is the data type
                              SymbolEntry* entry = new SymbolEntry($2, $1, "-12345", false);
                              // Add the entry to the symbol table
                              MotherSymbolTree.currentTable->insert(entry); 
                              printf("Variable added to the symbol table\n");
                            }
                          }
      | BREAK ';'
      | CONTINUE ';'
      | ifStatement {}
      | forLoop {}
      | whileLoop {}
      | doWhileLoop {}
      | switchCase {}
      | function {}
      | blockScope {}
      | functionCall ';' {} 
      | returnStatement ';' {}
      | INCREMENT ID ';' {
                            SymbolEntry* entry = MotherSymbolTree.getEntryByName($2);
                            if(entry == NULL)
                              printf("Variable is not declared\n");
                            else if (entry->variableType != "int") 
                              printf("Variable is not of type int\n");
                            else if (entry->isConstant == true)
                              printf("Variable is constant\n");
                            else if(entry->isInitialised == false)
                              printf("Variable is not initialized\n");
                            else{
                                entry->value = std::to_string(stoi(entry->value) + 1);
                                printf("Variable incremented\n");
                                MotherSymbolTree.currentTable->printTable();
                            }
                          }
      | DECREMENT ID ';' {
                            SymbolEntry* entry = MotherSymbolTree.getEntryByName($2);
                            if(entry == NULL)
                              printf("Variable is not declared\n");
                            else if (entry->variableType != "int") 
                              printf("Variable is not of type int\n");
                            else if (entry->isConstant == true)
                              printf("Variable is constant\n");
                            else if(entry->isInitialised == false)
                              printf("Variable is not initialized\n");
                            else{
                                entry->value = std::to_string(stoi(entry->value) - 1);
                                printf("Variable decremented\n");
                                MotherSymbolTree.currentTable->printTable();
                            }
                          }
      | ID INCREMENT ';' {
                            SymbolEntry* entry = MotherSymbolTree.getEntryByName($1);
                            if(entry == NULL)
                              printf("Variable is not declared\n");
                            else if (entry->variableType != "int") 
                              printf("Variable is not of type int\n");
                            else if (entry->isConstant == true)
                              printf("Variable is constant\n");
                            else if(entry->isInitialised == false)
                              printf("Variable is not initialized\n");
                            else{
                                entry->value = std::to_string(stoi(entry->value) + 1);
                                printf("Variable incremented\n");
                                MotherSymbolTree.currentTable->printTable();
                            }
                          }
      | ID DECREMENT ';' {
                            SymbolEntry* entry = MotherSymbolTree.getEntryByName($1);
                            if(entry == NULL)
                              printf("Variable is not declared\n");
                            else if (entry->variableType != "int") 
                              printf("Variable is not of type int\n");
                            else if (entry->isConstant == true)
                              printf("Variable is constant\n");
                            else if(entry->isInitialised == false)
                              printf("Variable is not initialized\n");
                            else{
                                entry->value = std::to_string(stoi(entry->value) - 1);
                                printf("Variable decremented\n");
                                MotherSymbolTree.currentTable->printTable();
                            }
                          }
      ;

dataTypes : INT { $$ = $1;}
          | FLOAT {$$ = $1;}
          | CHAR {$$ = $1;}
          | STRING {$$ = $1;}
          | BOOL {$$ = $1;}
          | VOID {$$ = $1;}
          ;

/* Expression */
expression : mathExpression {$$ = $1;}
            | boolExpression {$$ = $1;}
            | functionCall {}
            | CHAR_LITERAL { $$ = ConvertFromCharToString($1);}
            | STRING_LITERALS {$$ = $1;}
            ;

mathExpression : math1 { $$ = ConvertFromNumberToString($1);}
               ;

/* ########################## MATHEMATICAL EXPRESSIONS  ##########################*/
/* math1 is + - */
/* math2 is * / */
/* math3 is ( ) -ID -NUMBER ++ID --ID */
math1 : math1 '+' math2 {
                          $$ = $1 + $3;
                          char* label = quad.getCurrentLabel();
                          quad.binaryOperation("ADD", label);
                          printf("ADD Label: %s\n", label);
                          }
      | math1 '-' math2 {$$ = $1 - $3;
                          char* label = quad.getCurrentLabel();
                          quad.binaryOperation("SUB", label);
                          printf("SUB Label: %s\n", label);
                          }
      | math2 {$$ = $1;}
      ;

math2 : math2 '*' math3 {
                          $$ = $1 * $3;
                          char* label = quad.getCurrentLabel();
                          quad.binaryOperation("MUL", label);
                          printf("MUL Label: %s\n", label);
                          }
      | math2 '/' math3 {$$ = $1 / $3;
                          char* label = quad.getCurrentLabel();
                          quad.binaryOperation("DIV", label);
                          printf("DIV Label: %s\n", label);}
      | math2 '%' math3 { $$ = (int)$1 % (int)$3;
                          char* label = quad.getCurrentLabel();
                          quad.binaryOperation("MOD", label);
                          printf("MOD Label: %s\n", label);}
      | math3 {$$ = $1;}
      ;

math3 : '(' math1 ')' {$$ = $2;}
      | '-'math1 {$$ = -1 * $2;
                  char* label = quad.getCurrentLabel();
                  quad.unaryOperation("NEG", label);
                  printf("NEG Label: %s\n", label);
                  }
      | INT_LITERAL {$$ = $1;}
      | FLOAT_LITERAL {$$ = $1;}
      | ID {
              SymbolEntry* entry1 = MotherSymbolTree.getEntryByName($1);    
              if(!entry1)
                printf("Variable %s is not declared\n", $1);
              else if(entry1->variableType != "int" && entry1->variableType != "float")
                printf("Variable %s is not a number\n", $1);
              else
              {
                $$ = stof(entry1->value);
                quad.insertVariable($1); 
              }
                   
      }
      ;

INT_LITERAL : INTGER_NUMBER {
                              $$ = $1; printf("Number is: %d\n", $1);
                              quad.insertVariable(std::to_string($1));
                              printf("Inserted int variable: %d\n", $1);
                              
                            } 
            | INCREMENT ID  { 
                              SymbolEntry* entry = MotherSymbolTree.getEntryByName($2);
                              if(entry == NULL)
                                printf("Variable is not declared\n");
                              else if (entry->variableType != "int") 
                                printf("Variable is not of type int\n");
                              else if (entry->isConstant == true)
                                printf("Variable is constant\n");
                              else if(entry->isInitialised == false)
                                printf("Variable is not initialized\n");
                              else{
                                  $$ = stoi(entry->value) + 1;
                                  entry->value = std::to_string(stoi(entry->value) + 1);
                              }
                            }
            | DECREMENT ID  {
                              SymbolEntry* entry = MotherSymbolTree.getEntryByName($2);
                              if(entry == NULL)
                                printf("Variable is not declared\n");
                              else if (entry->variableType != "int") 
                                printf("Variable is not of type int\n");
                              else if (entry->isConstant == true)
                                printf("Variable is constant\n");
                              else if(entry->isInitialised == false)
                                printf("Variable is not initialized\n");
                              else{
                                  $$ = stoi(entry->value) - 1;
                                  entry->value = std::to_string(stoi(entry->value) - 1);
                                }
                            }
            | ID INCREMENT {
                              SymbolEntry* entry = MotherSymbolTree.getEntryByName($1);
                              if(entry == NULL)
                                printf("Variable is not declared\n");
                              else if (entry->variableType != "int") 
                                printf("Variable is not of type int\n");
                              else if (entry->isConstant == true)
                                printf("Variable is constant\n");
                              else if(entry->isInitialised == false)
                                printf("Variable is not initialized\n");
                              else{
                                  $$ = stoi(entry->value);
                                  entry->value = std::to_string(stoi(entry->value) + 1);
                                }
            }
            | ID DECREMENT {
                              SymbolEntry* entry = MotherSymbolTree.getEntryByName($1);
                              if(entry == NULL)
                                printf("Variable is not declared\n");
                              else if (entry->variableType != "int") 
                                printf("Variable is not of type int\n");
                              else if (entry->isConstant == true)
                                printf("Variable is constant\n");
                              else if(entry->isInitialised == false)
                                printf("Variable is not initialized\n");
                              else{
                                  $$ = stoi(entry->value);
                                  entry->value = std::to_string(stoi(entry->value) - 1);
                                }
            }
            ;

FLOAT_LITERAL : FLOAT_NUMBER {
                              $$ = $1;
                              quad.insertVariable(std::to_string($1));
                              printf("Inserted float variable: %f\n", $1);
                              }
              ;

CHAR_LITERAL : CHAR_IDENTIFIER {
                                $$ = $1;
                                quad.insertVariable(std::to_string($1));
                                printf("Inserted char variable: %c\n", $1);
                                }
             ;

STRING_LITERALS : STRING_IDENTIFIER {
                                    $$ = $1;
                                    quad.insertVariable($1);
                                    printf("Inserted string variable: %s\n", $1);
                                    }
                | NULLL {$$ = $1;}
                | ID {}
                ;


/* ########################## BOOLEAN EXPRESSIONS  ##########################*/
/* bool1 is > < >= <= */

/*
if (a > b) {
  c = 1;
} else {
  c = 2;
}

then

cmp a b
jgt Line0
c = 2
jmp Line1
Line0: 
c = 1
Line1:

cmp a b
jlt Line0
c = 1
jmp Line1
Line0:
c = 2
Line1:

*/

boolExpression : boolExpression AND boolExpression { $$ = ANDing($1, $3);}
                | boolExpression OR boolExpression { $$ = ORing($1, $3);}
                | NOT boolExpression { $$ = NOTing($2);}
                | expression boolComparators expression { $$ = CompareValues($1, $3, $2);
                                                              quad.branchingOperation($2);}
                | boolean { $$ = ConvertFromNumberToString($1);}
                | ID {
                        SymbolEntry* entry1 = MotherSymbolTree.getEntryByName($1);    
                        if(!entry1)
                          printf("Variable %s is not declared\n", $1);
                        else if (entry1->isInitialised == false)
                          printf("Variable %s is not initialized\n", $1);
                        else if(entry1->variableType != "int" && entry1->variableType != "float" && entry1->variableType != "bool")
                          printf("Variable %s is not a boolean\n", $1);
                        else
                          $$ = ConvertFromNumberToString(stoi(entry1->value));     
                      }
                ;

boolean : TRUEE {$$ = $1;}
        | FALSEE {$$ = $1;}
        ;

boolComparators : GREATERTHANEQUAL {$$ = $1;}
                | LESSTHANEQUAL {$$ = $1;}
                | GREATERTHAN {$$ = $1;}
                | LESSTHAN {$$ = $1;}
                | NOTEQUAL {$$ = $1;}
                | EQUAL {$$ = $1;}
                ;

/* ########################## IF-ELSE EXPRESSIONS  ##########################*/
ifStatement : ifScope { quad.addLine2();}
            | ifScope elseScope 
            ;

ifScope : IF OPENPARENTIF boolExpression CLOSEPARENTIF blockScope  { MotherSymbolTree.endCurrentScope("if"); 
                                                  printf("Scope End\n"); 
                                                  MotherSymbolTree.currentTable->printTable();
                                                  

                                                }
        ;

OPENPARENTIF : '(' {}
            ;

CLOSEPARENTIF : ')' {
                    }
                  ;

elseScope : ElseLabel blockScope { MotherSymbolTree.endCurrentScope("else"); 
                              printf("Scope End\n"); 
                              MotherSymbolTree.currentTable->printTable();
                              quad.addLine2();
                            }

          | ElseLabel ifStatement { }
          ;
ElseLabel : ELSE { 
                    quad.jumpOperation();
                    quad.addLine2();
                  }
          ;

/* ########################## SWITCH CASE ########################## */ 
switchCase : SWITCH '(' ID ')' beginScope caseStatements endScope { 
                                                                    SymbolEntry* entry = MotherSymbolTree.getEntryByName($3);
                                                                    if(entry == NULL)
                                                                      printf("Variable is not declared\n");
                                                                    else if(entry->variableType != "int" && entry->variableType != "char")
                                                                      printf("Variable is not of type int or char\n");
                                                                    else
                                                                    {
                                                                    MotherSymbolTree.endCurrentScope("switch"); 
                                                                    printf("Scope End\n"); 
                                                                    MotherSymbolTree.currentTable->printTable();}
                                                                  }
           ;

caseStatements : caseStatements caseStatement {}
               | caseStatement {}
               ;

caseStatement : CASE caseIdentifierInt beginCase Code {
                                                MotherSymbolTree.endCurrentScope("case"); 
                                                printf("Scope End\n"); 
                                                MotherSymbolTree.currentTable->printTable();
                                                }
              | CASE caseIdentifierChar beginCase Code { 
                                                MotherSymbolTree.endCurrentScope("case"); 
                                                printf("Scope End\n"); 
                                                MotherSymbolTree.currentTable->printTable();
                                                }
              | DEFAULT beginCase Code {
                                  MotherSymbolTree.endCurrentScope("case"); 
                                  printf("Scope End\n"); 
                                  MotherSymbolTree.currentTable->printTable();
                                  }
              ;

beginCase : ':' { MotherSymbolTree.addSymbolTableAndBeginScope(); 
                  printf("Scope Begin\n"); 
                  MotherSymbolTree.currentTable->printTable();}
          ;

caseIdentifierInt : INTGER_NUMBER {$$ = $1;}
                  ;

caseIdentifierChar : CHAR_IDENTIFIER {$$ = $1;}
                   ;


/* ########################## LOOPS  ##########################*/
/* ########################## FOR LOOP  ##########################*/
forLoop : FORLabel bracketBegin forLoopExpression  ';' forLoopCondition ';' forLoopIncDecExpression ')' blockScope  {  
                                                                                                        MotherSymbolTree.endCurrentScope("for"); 
                                                                                                        printf("Scope End\n"); 
                                                                                                        MotherSymbolTree.currentTable->printTable();

                                                                                                        MotherSymbolTree.endCurrentScope("for_initialization"); 
                                                                                                        printf("Scope End\n"); 
                                                                                                        MotherSymbolTree.currentTable->printTable();
                                                                                                      }
        ;
        
FORLabel : FOR { 
                  quad.startLoop();
                }
        ;

bracketBegin : '(' { MotherSymbolTree.addSymbolTableAndBeginScope(); 
                    printf("Scope Begin\n"); 
                    MotherSymbolTree.currentTable->printTable();}
             ;
forLoopCondition : boolExpression {}
                 | epsilon {}
                 ;

forLoopIncDecExpression : ID '=' expression {$$ = $3;}
                        | INCREMENT ID  {
                          {
                              SymbolEntry* entry = MotherSymbolTree.getEntryByName($2);
                              if(entry == NULL)
                                printf("Variable is not declared\n");
                              else if (entry->variableType != "int") 
                                printf("Variable is not of type int\n");
                              else if (entry->isConstant == true)
                                printf("Variable is constant\n");
                              else if(entry->isInitialised == false)
                                printf("Variable is not initialized\n");
                              else{
                                  $$ = ConvertFromNumberToString(stoi(entry->value) + 1);
                                  entry->value = std::to_string(stoi(entry->value) + 1);
                                }
                          }
                        }
                        | DECREMENT ID  {
                          {
                              SymbolEntry* entry = MotherSymbolTree.getEntryByName($2);
                              if(entry == NULL)
                                printf("Variable is not declared\n");
                              else if (entry->variableType != "int") 
                                printf("Variable is not of type int\n");
                              else if (entry->isConstant == true)
                                printf("Variable is constant\n");
                              else if(entry->isInitialised == false)
                                printf("Variable is not initialized\n");
                              else{
                                  $$ = ConvertFromNumberToString(stoi(entry->value) - 1);
                                  entry->value = std::to_string(stoi(entry->value) - 1);
                                }
                          }
                        }
                        | ID INCREMENT {
                          {
                              SymbolEntry* entry = MotherSymbolTree.getEntryByName($1);
                              if(entry == NULL)
                                printf("Variable is not declared\n");
                              else if (entry->variableType != "int") 
                                printf("Variable is not of type int\n");
                              else if (entry->isConstant == true)
                                printf("Variable is constant\n");
                              else if(entry->isInitialised == false)
                                printf("Variable is not initialized\n");
                              else{
                                  $$ = ConvertFromNumberToString(stoi(entry->value));
                                  entry->value = std::to_string(stoi(entry->value) + 1);
                                }
                          }
                        }
                        | ID DECREMENT {
                          {
                              SymbolEntry* entry = MotherSymbolTree.getEntryByName($1);
                              if(entry == NULL)
                                printf("Variable is not declared\n");
                              else if (entry->variableType != "int") 
                                printf("Variable is not of type int\n");
                              else if (entry->isConstant == true)
                                printf("Variable is constant\n");
                              else if(entry->isInitialised == false)
                                printf("Variable is not initialized\n");
                              else{
                                  $$ = ConvertFromNumberToString(stoi(entry->value));
                                  entry->value = std::to_string(stoi(entry->value) - 1);
                                }
                          }
                        }
                        | epsilon {}
                        ;

forLoopExpression : dataTypes ID '=' expression {
                                                bool isContained = MotherSymbolTree.currentTable->contains($2);
                                                if(isContained){
                                                  printf("Variable already declared\n");
                                                }else{
                                                  char* expressionType = sc.determineType($4);

                                                  if(sc.matchTypes($1, expressionType)){
                                                    printf("Type Match type1 = %s, type2 = %s\n", $1, expressionType);
                                                    // $2 is the ID and $1 is the data type
                                                    SymbolEntry* entry = new SymbolEntry($2, $1, $4, true);
                                              
                                                    // Add the entry to the symbol table
                                                    MotherSymbolTree.currentTable->insert(entry); 
                                                    printf("Variable added to the symbol table\n");
                                                    MotherSymbolTree.currentTable->printTable();
                                                  }
                                                  else
                                                    printf("Type Mismatch type1 = %s, type2 = %s\n", $1, expressionType);
                                                }
                                              }
                  | ID '=' expression {
                            SymbolTable* table = MotherSymbolTree.getScopeSymbolTable($1);
                                if(table == NULL){
                                  printf("Variable is not declared\n");
                                }else{
                                  SymbolEntry* entry = table->getEntry($1);
                                  if(entry->isConstant){
                                    printf("Error! Variable is constant\n");
                                  }else{
                                    printf("Variable is not constant\n");
                                    entry->value = $3;
                                    entry->isInitialised = true;
                                    printf("Variable intialized to the symbol table\n");
                                    MotherSymbolTree.currentTable->printTable();
                                  }
                                }
                          }
                  | epsilon {}
                  ;

/* ########################## WHILE LOOP  ##########################*/
whileLoop : whileLabel '(' boolExpression ')' blockScope {
                                                      MotherSymbolTree.endCurrentScope("while"); 
                                                      printf("Scope End\n"); 
                                                      MotherSymbolTree.currentTable->printTable();
                                                      char* label = quad.getCurrentLine();
                                                      quad.insertEntry("JMP", label, "", "");
                                                      quad.endLoop();
                                                    }
          ;
whileLabel : WHILE { 
                    quad.startLoop();
                  }
          ;

doWhileLoop : DOLabel blockScope WHILE '(' boolExpression ')' {
                                                      MotherSymbolTree.endCurrentScope("do_while"); 
                                                      printf("Scope End\n"); 
                                                      MotherSymbolTree.currentTable->printTable();
                                                      quad.endLoop();
                                                    }
            ;

DOLabel : DO { 
                quad.startLoop();
              }
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
blockScope : beginScope Code endScope {
                                        $$ = $1;
                                      }
           | beginScope endScope { 
                                      $$ = $1;
                                  }
           ;

beginScope : '{' { 
                    MotherSymbolTree.addSymbolTableAndBeginScope(); 
                    printf("Scope Begin\n"); 
                    MotherSymbolTree.currentTable->printTable();
                    $$ = quad.getCurrentLine();
                    // quad.addLineStart();
                  }
           ;

endScope : '}' {
                }
         ;

/* ########################## RETURN ##########################*/
returnStatement : RETURN expression { $$ = $2;}
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