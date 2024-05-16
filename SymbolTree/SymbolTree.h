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
    FunctionTable* addFunctionTable(string functionName, string returnType, string parameters);
    void addSymbolTableAndBeginScope();
    void endCurrentScope(string scopeType);
    void addSymbolEntry(string variableName, string variableType, string value = "0x0000", bool isInitialised = false, bool isConstant = false);
    SymbolTable* contains(string scopeName);
    ~SymbolTree();
};