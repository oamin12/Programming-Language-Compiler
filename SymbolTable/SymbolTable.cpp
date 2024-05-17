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
    if (this->children.size() > 0) cout << "Children: ";
    for (auto child : this->children)
    {
        cout << child->scopeName << " ";
    }
    if (this->children.size() > 0) cout << endl;
    cout << "Table: " << endl;
    for (auto entry : this->table)
    {
        cout << entry.first << " : " << entry.second->variableType << endl;
    }
}

void SymbolTable::printTableInFile(std::ostream& os) const
{
    os << "Scope Name: " << this->scopeName << endl;
    os << "Scope Type: " << this->scopeType << endl;
    if (this->parent) os << "Parent: " << this->parent->scopeName << endl;
    if (this->children.size() > 0) os << "Children: ";
    for (auto child : this->children)
    {
        os << child->scopeName << " ";
    }
    if (this->children.size() > 0) os << endl;
    os << "Table: " << endl;
    for (auto entry : this->table)
    {
        os << "Variable Name: " << entry.first << ", type: " << entry.second->variableType << ", " << (entry.second->isConstant ? "constant" : "not constant") << ", " << (entry.second->isInitialised ? "initialized" : "not initialized") << endl;
    }
}

SymbolTable::~SymbolTable()
{
    this->table.clear();
}