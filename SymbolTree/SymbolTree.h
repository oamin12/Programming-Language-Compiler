#pragma once



#include "../SymbolTable/SymbolTable.h"

class SymbolTree {
public:
    SymbolTable* currentTable;
    SymbolTable* globalTable;
    unordered_map<string, SymbolTable*> SymbolTables;

    SymbolTree();
    SymbolTable* getScopeSymbolTable(string entryName);
    SymbolEntry* getEntryByName(string entryName);
    void addSymbolTableAndBeginScope();
    void endCurrentScope(string scopeType);
    SymbolTable* contains(string scopeName);
    ~SymbolTree();
};