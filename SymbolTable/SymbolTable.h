#pragma once
#include <iostream>
#include <string>
#include <unordered_map>
#include <vector>
#include "../utils.h"

using namespace std;
struct SymbolEntry
{
    string variableName;
    string variableType;
    string value;
    bool isInitialised;
    bool isConstant;
    bool isUsed = false;
    SymbolEntry(string Name, string Type, string value = "0x0000", bool isInitialised = false, bool isConstant = false)
    {
        this->variableName = Name;
        this->variableType = Type;
        vector<string> param = splitString(value);
        for (int i = 0; i < param.size(); i++)
        {
            cout << param[i] << " ";
        }
        if(param.size() == 2)
        {
            if (Type == param[1])
                this->isInitialised = true;
            else
            {
                string errorMsg = "Type mismatch in initialization of " + Name;
                cout << errorMsg;
            }
                
        }
            
        else
        {
            if(Type == "char")
                this->value = value[0];
            else if(Type == "int")
                this->value = to_string((int)stof(value));
            else
                this->value = value;
        }
        cout << "HERE\n";
        this->isInitialised = isInitialised;
        this->isConstant = isConstant;
    }
};

class SymbolTable
{
public:
    string scopeName;
    string scopeType;
    unordered_map<string, SymbolEntry*> table;
    SymbolTable* parent;
    vector<SymbolTable*> children;

    SymbolTable(string scopeName, SymbolTable* parent, vector<SymbolTable*> children);
    void insert(SymbolEntry* entry);
    void addChild(SymbolTable* child);
    bool contains(string entryName);
    SymbolEntry* getEntry(string entryName);
    virtual void printTable() const;
    void printTableInFile(std::ostream& os) const;
    virtual ~SymbolTable();
};