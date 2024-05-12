#include "SymbolTree.h"

#include <iostream>
using namespace std;
#include <string>
#include <unordered_map>
#include <vector>

SymbolTree::SymbolTree()
{
    this->globalTable = new SymbolTable("global", nullptr, {});
    this->SymbolTables["global"] = this->globalTable;
    this->currentTable = this->globalTable;
}

SymbolTable* SymbolTree::contains(string scopeName)
{
    return this->SymbolTables[scopeName];
}

SymbolTable* SymbolTree::getScopeSymbolTable(string entryName)
{
    SymbolTable* current = this->currentTable;
    while (current != nullptr)
    {
        bool isFound = current->contains(entryName);
        if (isFound)
        {
            return current;
        }
        current = current->parent;
    }
    return nullptr;
}

SymbolTree::~SymbolTree()
{
    delete this->globalTable;
}