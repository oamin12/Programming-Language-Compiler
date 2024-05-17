#include "FunctionTable.h"

FunctionTable::FunctionTable(string scopeName, SymbolTable* parent, vector<SymbolTable*> children, string functionName, string returnType, vector<string> parameterNames, vector<string> parameterTypes) : SymbolTable(scopeName, parent, children)
{
    this->functionName = functionName;
    this->returnType = returnType;
    this->parameterNames = parameterNames;
    this->parameterTypes = parameterTypes;
}

void FunctionTable::printTable() const
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
    cout << "Return Type: " << this->returnType << endl;
    if (this->parameterNames.size() > 0) cout << "Parameters: ";
    for (int i = 0; i < this->parameterNames.size(); i++)
    {
        cout << this->parameterTypes[i] << " " << this->parameterNames[i] << ",";
    }
    if (this->parameterNames.size() > 0) cout << endl;
    cout << "Function Name: " << this->functionName << endl;
    cout << "Table: " << endl;
    for (auto entry : this->table)
    {
        cout << entry.first << " : " << entry.second->variableType << " = " << entry.second->value << endl;
    }
}