#include "SymbolTable.h"

SymbolTable::SymbolTable(string scopeName, SymbolTable* parent, vector<SymbolTable*> children)
{
    this->scopeName = scopeName;
    this->parent = parent;
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

void SymbolTable::printTable() const
{
    cout << "Scope Name: " << this->scopeName << endl;
    cout << "Scope Type: " << this->scopeType << endl;
    if (this->parent) cout << "Parent: " << this->parent->scopeName << endl;
    cout << "Children: ";
    for (auto child : this->children)
    {
        cout << child->scopeName << " ";
    }
    cout << endl;
    cout << "Table: " << endl;
    for (auto entry : this->table)
    {
        cout << entry.first << " : " << entry.second->variableType << " = " << entry.second->value << endl;
    }
}

SymbolTable::~SymbolTable()
{
    this->table.clear();
}