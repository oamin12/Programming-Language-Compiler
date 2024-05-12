#pragma once



#include "../SymbolTable/SymbolTable.h"

class SymbolTree {
public:
    SymbolTable* currentTable;
    SymbolTable* globalTable;
    unordered_map<string, SymbolTable*> SymbolTables;

    SymbolTree();
    SymbolTable* getScopeSymbolTable(string entryName);
    SymbolTable* contains(string scopeName);
    ~SymbolTree();
};