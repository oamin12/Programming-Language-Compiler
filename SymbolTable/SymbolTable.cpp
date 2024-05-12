#include "SymbolTable.h"

SymbolTable::SymbolTable(string scopeName, SymbolTable* parent, vector<SymbolTable*> children)
{
    this->parent = parent;
    this->scopeName = scopeName;
    this->children = children;
}


void SymbolTable::insert(SymbolEntry* entry)
{
    this->table[entry->variableName] = entry;
}

void SymbolTable::addChild(SymbolTable* child)
{
    this->children.push_back(child);
    child->parent = this;
}

SymbolEntry* SymbolTable::getEntry(string entryName)
{
    return this->table[entryName];
}

bool SymbolTable::contains(string entryName)
{
    return this->table.find(entryName) != this->table.end();
}

SymbolTable::~SymbolTable()
{
    this->table.clear();
}