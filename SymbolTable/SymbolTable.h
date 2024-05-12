#pragma once
#include <iostream>
#include <string>
#include <unordered_map>
#include <vector>
using namespace std;

struct SymbolEntry
{
    string variableName;
    string variableType;
    string value = "0x0000";
    bool isConstant = false;
    bool isInitialised = false;
    bool isUsed = false;
    SymbolEntry(string Name, string Type)
    {
        this->variableName = Name;
        this->variableType = Type;
    }
};

class SymbolTable
{
public:
    string scopeName;
    unordered_map<string, SymbolEntry*> table;
    SymbolTable* parent;
    vector<SymbolTable*> children;

    SymbolTable(string scopeName, SymbolTable* parent, vector<SymbolTable*> children);
    void insert(SymbolEntry* entry);
    void addChild(SymbolTable* child);
    bool contains(string entryName);
    SymbolEntry* getEntry(string entryName);
    ~SymbolTable();
};