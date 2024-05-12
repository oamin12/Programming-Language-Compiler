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

SymbolEntry* SymbolTree::getEntryByName(string entryName)
{
    SymbolTable* table = this->getScopeSymbolTable(entryName);
    if (table != nullptr)
    {
        return table->getEntry(entryName);
    }
    return nullptr;
}

void SymbolTree::addSymbolTableAndBeginScope()
{
    SymbolTable* table = new SymbolTable(this->currentTable->scopeName + to_string(this->currentTable->children.size()), this->currentTable, {});
    this->SymbolTables[table->scopeName] = table;
    this->currentTable->addChild(table);
    this->currentTable = table;
}

void SymbolTree::endCurrentScope(string scopeType)
{
    this->currentTable->scopeType = scopeType;
    this->currentTable = this->currentTable->parent;
}

SymbolTree::~SymbolTree()
{
    delete this->globalTable;
}