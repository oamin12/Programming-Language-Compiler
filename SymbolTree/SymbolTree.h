#pragma once



#include "../SymbolTable/SymbolTable.h"
#include "../SymbolTable/FunctionTable.h"
#include "../SemanticChecks/SemanticChecker.h"

extern SemanticChecker sc;

class SymbolTree {
public:
    SymbolTable* currentTable;
    SymbolTable* globalTable;
    unordered_map<string, SymbolTable*> SymbolTables;
    unordered_map<string, FunctionTable*> FunctionTables;

    SymbolTree();
    SymbolTable* getScopeSymbolTable(string entryName);
    SymbolEntry* getEntryByName(string entryName);
    FunctionTable* getFunctionTable(string functionName);
    FunctionTable* addFunctionTable(string functionName, string returnType, string parameters);
    void addSymbolTableAndBeginScope();
    void endCurrentScope(string scopeType);
    void addSymbolEntry(string variableName, string variableType, string value = "0x0000", bool isInitialised = false, bool isConstant = false);
    SymbolTable* contains(string scopeName);
    bool checkFunctionParameters(char* functionName, char* functionParams);
    void printAllTables(string filename="symbol_table.txt") const;
    bool assignVariables(string var, SymbolEntry* entry);
    ~SymbolTree();
};