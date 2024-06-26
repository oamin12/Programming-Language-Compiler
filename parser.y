/* Part1 - Definitions */
%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include "SymbolTree/SymbolTree.h"
    #include "SemanticChecks/SemanticChecker.h"
    #include "utils.h"
    #include "Quadraples/Quadraples.h"
    
    void yyerror(char* s);
    void yywarn(char* s);
    int yylex();
    extern FILE* yyin;                          
    extern FILE* yyout;  
    int yylineno = 1;                
    char* caseIdentifier;
    char* switchIdentifier;
    int flagFunction = 0;
    int assignFunToVar = 0;

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

%type <stringValue> dataTypes boolComparators STRING_LITERALS mathExpression boolExpression expression functionCall blockScope returnStatement forLoopIncDecExpression beginScope functionParameters functionCallParameters CHAR_LITERAL
%type <boolValue> boolean
%type <idValue> ID IDCase
%type <intValue> INT_LITERAL caseIdentifierInt
%type <floatValue> FLOAT_LITERAL math1 math2 math3
%type <chrValue>  caseIdentifierChar 

/* End of Part1 */ 
%right '='
%left '+' '-'
%left '*' '/' '%'




/*Part2 - Production Rules*/
%%

S : Code                 {}
  ;


Code : line { 
              quad.printQuadraples();
              quad.printQuadraplesToFile("output.txt");
            }
     | Code line {
                  quad.printQuadraples();
                  quad.printQuadraplesToFile("output.txt");
     }
     ;


/* Variable Declaration */
line : dataTypes ID '=' expression';'         { 
                                                bool isContained = MotherSymbolTree.currentTable->contains($2);
                                                if(isContained){
                                                  yyerror("Variable already declared");
                                                }else{
                                                  
                                                    SymbolEntry* entry = new SymbolEntry($2, $1, $4, true);
                                                    //add to quadruple
                                                    // printf("Inserting variable: %s\n", $2);
                                                    quad.unaryOperation("MOV", $2);
                                                    quad.popVariable();
                                                    quad.resetCount();
                                                    //quad.clearVariablesStack();
                                                    

                                                    // Add the entry to the symbol table
                                                    MotherSymbolTree.currentTable->insert(entry); 
                                                    // printf("Variable added to the symbol table\n");
                                                    MotherSymbolTree.currentTable->printTable();
                                                    
                                                }                                      
                                                

                                              }
      | CONST dataTypes ID '=' expression';' {
                                                bool isContained = MotherSymbolTree.currentTable->contains($3);
                                                if(isContained){
                                                  yyerror("Variable already declared\n");
                                                }else{
                                                  // $3 is the ID and $2 is the data type
                                                  SymbolEntry* entry = new SymbolEntry($3, $2, $5, true, true);
                                                  //add to quadruple
                                                  quad.unaryOperation("MOV", $2);
                                                  quad.popVariable();
                                                  quad.resetCount();
                                                  // Add the entry to the symbol table
                                                  MotherSymbolTree.currentTable->insert(entry); 
                                                  // printf("Constant added to the symbol table\n");
                                                }
                                              }
      | ID '=' expression';' {
                                
                                SymbolTable* table = MotherSymbolTree.getScopeSymbolTable($1);
                                if(table == NULL){
                                  yyerror("Variable is not declared\n");
                                }else{
                                  SymbolEntry* entry = table->getEntry($1);
                                  //add to quadruple
                                  
                                  if(entry->isConstant){
                                    yyerror("Error! Variable is constant\n");
                                  }else{
                                    quad.unaryOperation("MOV", $1);
                                    quad.popVariable();
                                    quad.resetCount();
                                    bool isMismatch = MotherSymbolTree.assignVariables($3, entry);
                                    if (!isMismatch)
                                    {
                                        string errorMsg = "Type mismatch in initialization of " + entry->variableName;
                                        yyerror(errorMsg.data());
                                    }
                                    else
                                      MotherSymbolTree.currentTable->printTable();
                                  }
                                }
                              }
      | dataTypes ID ';' { 
                            bool isContained = MotherSymbolTree.currentTable->contains($2);
                            if(isContained){
                              yyerror("Variable already declared\n");
                            }else{
                              SymbolEntry* entry = new SymbolEntry($2, $1, "-12345", false);
                              // Add the entry to the symbol table
                              MotherSymbolTree.currentTable->insert(entry); 
                              // printf("Variable added to the symbol table\n");
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
      | functionCall ';' {quad.insertEntry("Call",$1,"","");} 
      | returnStatement ';' {}
      | INCREMENT ID ';' {
                            SymbolEntry* entry = MotherSymbolTree.getEntryByName($2);
                            if(entry == NULL)
                              yyerror("Variable is not declared\n");
                            else if (entry->variableType != "int") 
                              yyerror("Variable is not of type int\n");
                            else if (entry->isConstant == true)
                              yyerror("Variable is constant\n");
                            else if(entry->isInitialised == false)
                              yywarn("Variable is not initialized\n");
                            else{
                                entry->value = std::to_string(stoi(entry->value) + 1);
                                MotherSymbolTree.currentTable->printTable();
                            }
                          }
      | DECREMENT ID ';' {
                            SymbolEntry* entry = MotherSymbolTree.getEntryByName($2);
                            if(entry == NULL)
                              yyerror("Variable is not declared\n");
                            else if (entry->variableType != "int") 
                              yyerror("Variable is not of type int\n");
                            else if (entry->isConstant == true)
                              yyerror("Variable is constant\n");
                            else if(entry->isInitialised == false)
                              yywarn("Variable is not initialized\n");
                            else{
                                entry->value = std::to_string(stoi(entry->value) - 1);
                                MotherSymbolTree.currentTable->printTable();
                            }
                          }
      | ID INCREMENT ';' {
                            SymbolEntry* entry = MotherSymbolTree.getEntryByName($1);
                            if(entry == NULL)
                              yyerror("Variable is not declared\n");
                            else if (entry->variableType != "int") 
                              yyerror("Variable is not of type int\n");
                            else if (entry->isConstant == true)
                              yyerror("Variable is constant\n");
                            else if(entry->isInitialised == false)
                              yywarn("Variable is not initialized\n");
                            else{
                                entry->value = std::to_string(stoi(entry->value) + 1);
                                MotherSymbolTree.currentTable->printTable();
                            }
                          }
      | ID DECREMENT ';' {
                            SymbolEntry* entry = MotherSymbolTree.getEntryByName($1);
                            if(entry == NULL)
                              yyerror("Variable is not declared\n");
                            else if (entry->variableType != "int") 
                              yyerror("Variable is not of type int\n");
                            else if (entry->isConstant == true)
                              yyerror("Variable is constant\n");
                            else if(entry->isInitialised == false)
                              yywarn("Variable is not initialized\n");
                            else{
                                entry->value = std::to_string(stoi(entry->value) - 1);
                                MotherSymbolTree.currentTable->printTable();
                            }
                          }
      | epsilon {}
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
            | functionCall {$$ = $1;
                            char* label = quad.getCurrentLabel();
                            quad.binaryOperation("call", label);
                            }
            | CHAR_LITERAL { $$ = $1;}
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
                          //printf("ADD Label: %s\n", label);
                          }
      | math1 '-' math2 {$$ = $1 - $3;
                          char* label = quad.getCurrentLabel();
                          quad.binaryOperation("SUB", label);
                          //printf("SUB Label: %s\n", label);
                          }
      | math2 {$$ = $1;}
      ;

math2 : math2 '*' math3 {
                          $$ = $1 * $3;
                          char* label = quad.getCurrentLabel();
                          quad.binaryOperation("MUL", label);
                          //printf("MUL Label: %s\n", label);
                          }
      | math2 '/' math3 {$$ = $1 / $3;
                          char* label = quad.getCurrentLabel();
                          quad.binaryOperation("DIV", label);
                          //printf("DIV Label: %s\n", label);
                          }
      | math2 '%' math3 { $$ = (int)$1 % (int)$3;
                          char* label = quad.getCurrentLabel();
                          quad.binaryOperation("MOD", label);
                          // printf("MOD Label: %s\n", label);
                          }
      | math3 {$$ = $1;}
      ;

math3 : '(' math1 ')' {$$ = $2;}
      | '-'math1 {$$ = -1 * $2;
                  char* label = quad.getCurrentLabel();
                  quad.unaryOperation("NEG", label);
                  // printf("NEG Label: %s\n", label);
                  }
      | INT_LITERAL {$$ = $1;}
      | FLOAT_LITERAL {$$ = $1;}
      | ID {
              SymbolEntry* entry1 = MotherSymbolTree.getEntryByName($1);    
              if(!entry1)
                yyerror("Variable is not declared\n");
              else
              {
                $$ = stof(entry1->value);
                entry1->isUsed = true;
                quad.insertVariable($1); 
              }
                   
      }
      ;

INT_LITERAL : INTGER_NUMBER {
                              $$ = $1;
                              quad.insertVariable(std::to_string($1));
                            
                            } 
            | INCREMENT ID  { 
                              SymbolEntry* entry = MotherSymbolTree.getEntryByName($2);
                              if(entry == NULL)
                                yyerror("Variable is not declared\n");
                              else if (entry->variableType != "int") 
                                yyerror("Variable is not of type int\n");
                              else if (entry->isConstant == true)
                                yyerror("Variable is constant\n");
                              else if(entry->isInitialised == false)
                                yywarn("Variable is not initialized\n");
                              else{
                                  $$ = stoi(entry->value) + 1;
                                  entry->isUsed = true;
                                  entry->value = std::to_string(stoi(entry->value) + 1);
                              }
                            }
            | DECREMENT ID  {
                              SymbolEntry* entry = MotherSymbolTree.getEntryByName($2);
                              if(entry == NULL)
                                yyerror("Variable is not declared\n");
                              else if (entry->variableType != "int") 
                                yyerror("Variable is not of type int\n");
                              else if (entry->isConstant == true)
                                yyerror("Variable is constant\n");
                              else if(entry->isInitialised == false)
                                yywarn("Variable is not initialized\n");
                              else{
                                  $$ = stoi(entry->value) - 1;
                                  entry->isUsed = true;
                                  entry->value = std::to_string(stoi(entry->value) - 1);
                                }
                            }
            | ID INCREMENT {
                              SymbolEntry* entry = MotherSymbolTree.getEntryByName($1);
                              if(entry == NULL)
                                yyerror("Variable is not declared\n");
                              else if (entry->variableType != "int") 
                                yyerror("Variable is not of type int\n");
                              else if (entry->isConstant == true)
                                yyerror("Variable is constant\n");
                              else if(entry->isInitialised == false)
                                yywarn("Variable is not initialized\n");
                              else{
                                  $$ = stoi(entry->value);
                                  entry->isUsed = true;
                                  entry->value = std::to_string(stoi(entry->value) + 1);
                                }
            }
            | ID DECREMENT {
                              SymbolEntry* entry = MotherSymbolTree.getEntryByName($1);
                              if(entry == NULL)
                                yyerror("Variable is not declared\n");
                              else if (entry->variableType != "int") 
                                yyerror("Variable is not of type int\n");
                              else if (entry->isConstant == true)
                                yyerror("Variable is constant\n");
                              else if(entry->isInitialised == false)
                                yywarn("Variable is not initialized\n");
                              else{
                                  $$ = stoi(entry->value);
                                  entry->isUsed = true;
                                  entry->value = std::to_string(stoi(entry->value) - 1);
                                }
            }
            ;

FLOAT_LITERAL : FLOAT_NUMBER {
                              $$ = $1;
                              quad.insertVariable(std::to_string($1));
                              // printf("Inserted float variable: %f\n", $1);
                              }
              ;

CHAR_LITERAL : CHAR_IDENTIFIER {
                                  string sym(1, $1);
                                  $$ = sym.data();
                                  // printf("Char Literal HEREee: %c\n", $$);
                                  quad.insertVariable(std::to_string($1));
                                // printf("Inserted char variable: %c\n", $1);
                                }
             ;

STRING_LITERALS : STRING_IDENTIFIER {
                                    $$ = $1;
                                    quad.insertVariable($1);
                                    // printf("Inserted string variable: %s\n", $1);
                                    }
                | NULLL {$$ = $1;}
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
                | boolean { $$ = ConvertFromNumberToString($1);
                            quad.insertVariable($$);}
                | ID {
                        SymbolEntry* entry1 = MotherSymbolTree.getEntryByName($1);    
                        if(!entry1)
                          yyerror("Variable is not declared\n");
                        else if (entry1->isInitialised == false)
                          yywarn("Variable is not initialized\n");
                        else if(entry1->variableType != "int" && entry1->variableType != "float" && entry1->variableType != "bool")
                          yyerror("Variable is not a boolean\n");
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
ifStatement : ifScope { 
                        quad.currentListIndex -= 1;
                        if(quad.currentListIndex != -1)
                        {                         
                           quad.addLine2();
                        }
                      }
            | ifScope elseScope { 
                                  quad.currentListIndex -= 1;
                                  if(quad.currentListIndex != -1){
                                    quad.addLine2();}
                                    
                                  }
            ;

ifScope : IfLabel '(' boolExpression ')' blockScope  { MotherSymbolTree.endCurrentScope("if"); 
                                                  MotherSymbolTree.currentTable->printTable();
                                                }
        ;

IfLabel : IF { 
                quad.currentListIndex += 1;
             }
        ;

elseScope : ElseLabel blockScope { MotherSymbolTree.endCurrentScope("else"); 
                              MotherSymbolTree.currentTable->printTable();
                              quad.addLine2();
                            }

          | ElseLabel ifStatement { }
          ;
ElseLabel : ELSE  { 
                    quad.jumpOperation();
                    quad.addLine2();
                  }
          ;

/* ########################## SWITCH CASE ########################## */ 
switchCase : SWITCH '(' IDCase ')' beginScopeCase caseStatements endScope { 
                                                                    SymbolEntry* entry = MotherSymbolTree.getEntryByName($3);
                                                                    if(entry == NULL)
                                                                      yyerror("Variable is not declared\n");
                                                                    else if(entry->variableType != "int" && entry->variableType != "char")
                                                                      yyerror("Variable is not of type int or char\n");
                                                                    else
                                                                    {
                                                                    MotherSymbolTree.endCurrentScope("switch"); 
                                                                    printf("Switch Scope End\n"); 
                                                                    MotherSymbolTree.currentTable->printTable();}
                                                                    quad.processCaseIds(switchIdentifier);
                                                                    quad.addLineCase();

                                                                  }
           ;

beginScopeCase : beginScope { 
                            quad.jumpStartCase();
                            }
               ;

IDCase : IDENTIFIER { $$ = $1;
                      switchIdentifier = $1;
                    }
       ;

caseStatements : caseStatements caseStatement {}
               | caseStatement {}
               ;

caseStatement : CASE caseIdentifierInt beginCase Code {
                                                MotherSymbolTree.endCurrentScope("case"); 
                                                printf("Case Scope End\n"); 
                                                MotherSymbolTree.currentTable->printTable();
                                                quad.jumpEndCase();
                                                }
              | CASE caseIdentifierChar beginCase Code { 
                                                MotherSymbolTree.endCurrentScope("case"); 
                                                printf("Case Scope End\n"); 
                                                MotherSymbolTree.currentTable->printTable();
                                                quad.jumpEndCase();
                                                }
              | DefaultIdentifier beginCase Code {
                                  MotherSymbolTree.endCurrentScope("case"); 
                                  printf("Case Scope End\n"); 
                                  MotherSymbolTree.currentTable->printTable();
                                  quad.jumpEndCase();
                                  }
              ;

DefaultIdentifier : DEFAULT { caseIdentifier = "default";}
                  ;

beginCase : ':' { MotherSymbolTree.addSymbolTableAndBeginScope(); 
                  printf("Scope Begin\n"); 
                  MotherSymbolTree.currentTable->printTable();
                  quad.insertCase(caseIdentifier);
                  }
          ;

caseIdentifierInt : INTGER_NUMBER {$$ = $1;
                                  caseIdentifier = ConvertFromNumberToString($1);
                                  quad.insertCaseID(caseIdentifier); // for the cmp process
                                  }
                                  
                  ;

caseIdentifierChar : CHAR_IDENTIFIER {$$ = $1;
                                      caseIdentifier = ConvertFromCharToString($1);
                                      quad.insertCaseID(caseIdentifier); // for the cmp process
                                      }
                    ;
                   ;


/* ########################## LOOPS  ##########################*/
/* ########################## FOR LOOP  ##########################*/
forLoop : FOR bracketBegin forLoopExpression  ';' forLoopCondition ';' forLoopIncDecExpression ')' blockScope  {  
                                                                                                        MotherSymbolTree.endCurrentScope("for"); 
                                                                                                        printf("For Scope End\n"); 
                                                                                                        MotherSymbolTree.currentTable->printTable();

                                                                                                        MotherSymbolTree.endCurrentScope("for_initialization"); 
                                                                                                        printf("For Initialization Scope End\n"); 
                                                                                                        MotherSymbolTree.currentTable->printTable();

                                                                                                        quad.endForLoop($7);
                                                                                                      }
        ;
      

bracketBegin : '(' { MotherSymbolTree.addSymbolTableAndBeginScope(); 
                    printf("Scope Begin\n"); 
                    MotherSymbolTree.currentTable->printTable();}
             ;
forLoopCondition : boolExpression {}
                 ;

forLoopIncDecExpression : ID '=' expression {$$ = $1;}
                        | INCREMENT ID  {
                              SymbolEntry* entry = MotherSymbolTree.getEntryByName($2);
                              if(entry == NULL)
                                yyerror("Variable is not declared\n");
                              else if (entry->variableType != "int") 
                                yyerror("Variable is not of type int\n");
                              else if (entry->isConstant == true)
                                yyerror("Variable is constant\n");
                              else if(entry->isInitialised == false)
                                yywarn("Variable is not initialized\n");
                              else{
                                  ConvertFromNumberToString(stoi(entry->value) + 1);
                                  entry->value = std::to_string(stoi(entry->value) + 1);
                                  char* result = new char[4 + strlen($2) + 1];
                                  strcpy(result, "INC ");
                                  strcat(result, $2);
                                  $$ = result;
                                }
                        }
                        | DECREMENT ID  {
                      
                              SymbolEntry* entry = MotherSymbolTree.getEntryByName($2);
                              if(entry == NULL)
                                yyerror("Variable is not declared\n");
                              else if (entry->variableType != "int") 
                                yyerror("Variable is not of type int\n");
                              else if (entry->isConstant == true)
                                yyerror("Variable is constant\n");
                              else if(entry->isInitialised == false)
                                yywarn("Variable is not initialized\n");
                              else{
                                  ConvertFromNumberToString(stoi(entry->value) - 1);
                                  entry->value = std::to_string(stoi(entry->value) - 1);
                                  char* result = new char[4 + strlen($2) + 1];
                                  strcpy(result, "DEC ");
                                  strcat(result, $2);
                                  $$ = result;
                                }
                        
                        }
                        | ID INCREMENT {
                  
                              SymbolEntry* entry = MotherSymbolTree.getEntryByName($1);
                              if(entry == NULL)
                                yyerror("Variable is not declared\n");
                              else if (entry->variableType != "int") 
                                yyerror("Variable is not of type int\n");
                              else if (entry->isConstant == true)
                                yyerror("Variable is constant\n");
                              else if(entry->isInitialised == false)
                                yywarn("Variable is not initialized\n");
                              else{
                                  ConvertFromNumberToString(stoi(entry->value));
                                  entry->value = std::to_string(stoi(entry->value) + 1);
                                  char* result = new char[4 + strlen($2) + 1];
                                  strcpy(result, "INC ");
                                  strcat(result, $1);
                                  $$ = result;
                                }
                    
                        }
                        | ID DECREMENT {
                              SymbolEntry* entry = MotherSymbolTree.getEntryByName($1);
                              if(entry == NULL)
                                yyerror("Variable is not declared\n");
                              else if (entry->variableType != "int") 
                                yyerror("Variable is not of type int\n");
                              else if (entry->isConstant == true)
                                yyerror("Variable is constant\n");
                              else if(entry->isInitialised == false)
                                yywarn("Variable is not initialized\n");
                              else{
                                  ConvertFromNumberToString(stoi(entry->value));
                                  entry->value = std::to_string(stoi(entry->value) - 1);
                                  char* result = new char[4 + strlen($2) + 1];
                                  strcpy(result, "DEC ");
                                  strcat(result, $1);
                                  $$ = result;
                                }
                        }
                        | epsilon {$$="";}
                        ;

forLoopExpression : dataTypes ID '=' expression {
                                                bool isContained = MotherSymbolTree.currentTable->contains($2);
                                                if(isContained){
                                                  yyerror("Variable already declared\n");
                                                }else{
                                                  char* expressionType = sc.determineType($4);

                                                  if(sc.matchTypes($1, expressionType)){
                                                    // printf("Type Match type1 = %s, type2 = %s\n", $1, expressionType);
                                                    SymbolEntry* entry = new SymbolEntry($2, $1, $4, true);
                                              
                                                    // Add the entry to the symbol table
                                                    MotherSymbolTree.currentTable->insert(entry); 
                                                    // printf("Variable added to the symbol table\n");
                                                    MotherSymbolTree.currentTable->printTable();

                                                    quad.unaryOperation("MOV", $2);
                                                    quad.resetLabelCount();
                                                    //quad.clearVariablesStack();
                                                    quad.popVariable();
                                                    quad.startLoop();
                                                  }
                                                  else
                                                  {
                                                    string errorMsg = "Type Mismatch type1 = " + string($1) + ", type2 = " + expressionType;
                                                    yyerror(errorMsg.data());
                                                  }
                                                }
                                              }
                  | ID '=' expression {
                            SymbolTable* table = MotherSymbolTree.getScopeSymbolTable($1);
                                if(table == NULL){
                                  yyerror("Variable is not declared\n");
                                }else{
                                  SymbolEntry* entry = table->getEntry($1);
                                  if(entry->isConstant){
                                    yyerror("Error! Variable is constant\n");
                                  }else{
                                    entry->value = $3;
                                    entry->isInitialised = true;
                                    MotherSymbolTree.currentTable->printTable();

                                    quad.unaryOperation("MOV", $1);
                                    quad.resetLabelCount();
                                    //quad.clearVariablesStack();
                                    quad.popVariable();
                                    quad.startLoop();
                                  }
                                }
                          }
                  | epsilon {
                              quad.startLoop();
                  }
                  ;

/* ########################## WHILE LOOP  ##########################*/
whileLoop : whileLabel '(' boolExpression ')' blockScope {
                                                      MotherSymbolTree.endCurrentScope("while"); 
                                                      printf("While Scope End\n"); 
                                                      MotherSymbolTree.currentTable->printTable();
                                                      quad.endLoop();
                                                    }
          ;
whileLabel : WHILE { 
                    quad.startLoop();
                  }
          ;

doWhileLoop : DOLabel blockScope WHILE '(' boolExpression ')' {
                                                      MotherSymbolTree.endCurrentScope("do_while"); 
                                                      printf("Do While Scope End\n"); 
                                                      MotherSymbolTree.currentTable->printTable();
                                                      quad.endLoop();
                                                    }
            ;

DOLabel : DO { 
                quad.startLoop();
              }
        ;

           
/* ########################## FUNCTIONS ##########################*/
function : functionSignature blockScope { 
                                          MotherSymbolTree.endCurrentScope("function_definition"); 
                                          printf("Function Definition Scope End\n"); 
                                          MotherSymbolTree.currentTable->printTable();

                                          MotherSymbolTree.endCurrentScope("function_signature");
                                          printf("Function Signature Scope End\n");
                                          MotherSymbolTree.currentTable->printTable();
                                          quad.insertEntry("Ret","","","");
                                          quad.isFunctionFlag = 0;
                                        }
         ;

functionSignature : dataTypes ID '(' functionParameters ')' {
                                                                                FunctionTable* function = MotherSymbolTree.addFunctionTable($2, $1, $4);
                                                                                if (function)
                                                                                {
                                                                                  printf("Function Signature Scope Begin\n"); 
                                                                                  MotherSymbolTree.currentTable->printTable();
                                                                                  quad.isFunctionFlag = 1;
                                                                                  quad.insertEntry(concatenateTwoStrings($2,":"),"","","");
                                                                                }
                    
                                                                              }
                  ; 

functionParameters : functionParameters ',' dataTypes ID {$$ = concatenateThreeStrings($1,$3,$4);}
                   | dataTypes ID {$$ = concatenateTwoStrings($1,$2);}
                   | epsilon {$$ = "";}
                   ;

functionCall : ID '(' functionCallParameters ')'{ 
                                                  FunctionTable* func = MotherSymbolTree.getFunctionTable($1);
                                                  if (func == NULL)
                                                  {
                                                    string errorMsg = "Function" + string($1) +  "is not declared";
                                                    yyerror(errorMsg.data());
                                                  }
                                                  else
                                                  {
                                                    bool isMatched = MotherSymbolTree.checkFunctionParameters($1, $3);
                                                    if(!isMatched)
                                                      yyerror("Function parameters do not match");
                                                    else
                                                    {
                                                      $$ = concatenateTwoStrings(func->functionName.data(), func->returnType.data());
                                                      // printf("Function Call: %s\n", $$);
                                                      quad.insertVariable($1);
                                                    }
                                                  }
                                                }
             ;

functionCallParameters : functionCallParameters ',' expression {
                      $$ = concatenateThreeStrings($1, $3, ""); }
                       | expression {$$ = $1;}
                       | epsilon {}
                       ;

/* ########################## BLOCK SCOPES ##########################*/
blockScope : beginScope Code endScope {$$ = $1;}
           | beginScope endScope {$$ = $1;}
           ;

beginScope : '{' { 
                    MotherSymbolTree.addSymbolTableAndBeginScope(); 
                    printf("Scope Begin\n"); 
                    MotherSymbolTree.currentTable->printTable();
                    $$ = quad.getCurrentLine();
                    // quad.addLineStart();
                  }
           ;

endScope : '}' {}
         ;

/* ########################## RETURN ##########################*/
returnStatement : RETURN expression { 
                                      bool isMatched = MotherSymbolTree.checkFunctionReturnType($2);
                                      if (isMatched) $$ = $2;
                                    }
                | RETURN {     FunctionTable* table = dynamic_cast<FunctionTable*>(MotherSymbolTree.currentTable->parent);
                                if(table == NULL)
                                  yyerror("Return statement outside function");
                                else if(table->returnType != "void")
                                  yyerror("Return type does not match");
                                else
                                  $$ = "";
                          }
                ;

epsilon : {}
        ;

ID : IDENTIFIER {$$ = $1;}
   ;


%%  
/* End of Part2 */ 


/*Part3 - Subroutines*/
void yyerror(char *msg){
  /* fprintf(stderr, "%s\n", msg); */
  fprintf(yyout, "line [%d]: Error: %s\n", yylineno, msg);
}

void yywarn(char *msg){
  fprintf(yyout, "line [%d]: Warning: %s\n", yylineno, msg);
}

int main(int argc, char** argv){
  if(argc != 2){
    yyerror("Please enter filename only!");
    return 1;
  }

  FILE *file = fopen(argv[1], "r");

  if(file == NULL){
    yyerror("File not found!\n");
    return 1;
  }
  
  yyin = file;
  yyout = fopen("errors.txt", "w");

  /* do{
    yyparse();
  }while(!feof(yyin)); */


  yyparse();
  fclose(yyin);
  fclose(yyout);
  MotherSymbolTree.printAllTables();
  return 0;
}