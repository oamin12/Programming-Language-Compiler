#pragma once



#include "../SymbolTable/SymbolTable.h"
#include "../SymbolTable/FunctionTable.h"

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
    void addFunctionTable(string functionName, string returnType, vector<string> parameters);
    void addSymbolTableAndBeginScope();
    void endCurrentScope(string scopeType);
    SymbolTable* contains(string scopeName);
    ~SymbolTree();
};