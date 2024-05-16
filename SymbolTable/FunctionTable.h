#pragma once
#include <iostream>
#include <string>
#include <unordered_map>
#include <vector>
#include "SymbolTable.h"

class FunctionTable : public SymbolTable
{
public:
    string functionName;
    string returnType;
    vector<string> parameters;
    FunctionTable(string scopeName, SymbolTable* parent, vector<SymbolTable*> children, string functionName, string returnType, vector<string> parameters);
    virtual void printTable() const;
    ~FunctionTable();
};