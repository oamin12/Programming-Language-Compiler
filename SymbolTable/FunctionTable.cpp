#include "FunctionTable.h"

FunctionTable::FunctionTable(string scopeName, SymbolTable* parent, vector<SymbolTable*> children, string functionName, string returnType, vector<string> parameters) : SymbolTable(scopeName, parent, children)
{
    this->functionName = functionName;
    this->returnType = returnType;
    this->parameters = parameters;
}

void FunctionTable::printTable() const
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
    cout << "Return Type: " << this->returnType << endl;
    cout << "Parameters: ";
    for (auto param : this->parameters)
    {
        cout << param << " ";
    }
    cout << endl;
    cout << "Table: " << endl;
    for (auto entry : this->table)
    {
        cout << entry.first << " : " << entry.second->variableType << " = " << entry.second->value << endl;
    }
}