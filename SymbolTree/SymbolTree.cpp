#include "SymbolTree.h"

#include <iostream>
using namespace std;
#include <string>
#include <unordered_map>
#include <vector>
#include <unordered_set>
#include <queue>
#include <fstream>

#include "../utils.h"

SymbolTree::SymbolTree()
{
    this->globalTable = new SymbolTable("global", nullptr, {});
    this->SymbolTables["global"] = this->globalTable;
    this->currentTable = this->globalTable;
    this->globalTable->scopeType = "global";
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

FunctionTable* SymbolTree::getFunctionTable(string functionName)
{
    return this->FunctionTables[functionName];

}
FunctionTable* SymbolTree::addFunctionTable(string functionName, string returnType, string parameters)
{
    FunctionTable* func = this->getFunctionTable(functionName);
    if (func) return nullptr;

    vector<string> parameterNames;
    vector<string> parameterTypes;
    vector<string> params = splitString(parameters, ',');
    for (int i = 0; i < params.size(); i++)
    {
        vector<string> param = splitString(params[i]);
        parameterTypes.push_back(param[0]);
        parameterNames.push_back(param[1]);
    }
    FunctionTable* table = new FunctionTable(this->currentTable->scopeName + to_string(this->currentTable->children.size()), this->currentTable, {}, functionName, returnType, parameterNames, parameterTypes);
    this->FunctionTables[functionName] = table;
    this->currentTable->addChild(table);
    this->currentTable = table;
    this->currentTable->scopeType = "function";
    unordered_set<string> uniqueParams(parameterNames.begin(), parameterNames.end());
    if (uniqueParams.size() != parameterNames.size())
    {
        cout << "Function " << functionName << " has duplicate parameters" << endl;
        return nullptr;
    }
    for (int i = 0; i < parameterTypes.size(); i++)
    {
        this->addSymbolEntry(parameterNames[i], parameterTypes[i]);
    }

    return table;
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

void SymbolTree::addSymbolEntry(string variableName, string variableType, string value, bool isInitialised, bool isConstant)
{
    if (this->currentTable->contains(variableName))
    {
        cout << "Variable " << variableName << " is already declared in this scope" << endl;
        return;
    }
    SymbolEntry* entry = new SymbolEntry(variableName, variableType, value, isInitialised, isConstant);
    this->currentTable->insert(entry);
}

void SymbolTree::printAllTables(string filename) const {
    if (this->globalTable == nullptr) {
        return;
    }

    std::ofstream file(filename);
    if (file.is_open()) {
        // Create a queue to manage the BFS
        queue<SymbolTable*> tableQueue;
        tableQueue.push(this->globalTable);

        while (!tableQueue.empty()) {
            // Get the next table in the queue
            SymbolTable* current = tableQueue.front();
            tableQueue.pop();

            // Print the current table
            current->printTableInFile(file);
            file << std::endl;

            // Enqueue all children of the current table
            for (SymbolTable* child : current->children) {
                tableQueue.push(child);
            }
        }
        file.close();
    } else {
        cout << "Unable to open file for writing" << std::endl;
    }
}

bool SymbolTree::checkFunctionParameters(char* functionName, char* functionParams)
{
    string params = string(functionParams);
    vector<string> paramList = splitString(params, ',');
    FunctionTable* table = this->getFunctionTable(functionName);
    if (paramList.size() != table->parameterNames.size())
    {
        cout << "Function " << functionName << " has wrong number of parameters" << endl;
        return false;
    }
    for (int i = 0; i < paramList.size(); i++)
    {
        string param = paramList[i];
        vector<string> paramParts = splitString(param, ' ');
        if (paramParts.size() == 1)
        {
            if (sc.determineType(paramParts[0].data()) != table->parameterTypes[i])
            {
                cout << "Function " << functionName << " has wrong parameter type" << endl;
                return false;
            }
        }
        else if (paramParts.size() == 2)
        {
            if (paramParts[1] != table->parameterTypes[i])
            {
                cout << "Function " << functionName << " has wrong parameter type" << endl;
                return false;
            }
        }

    }
    return true;
}

bool SymbolTree::assignVariables(string var, SymbolEntry* entry)
{
    cout << var << " " << entry->variableType << endl;
    vector<string> param = splitString(var);
    for (int i = 0; i < param.size(); i++)
    {
        cout << param[i] << " ";
    }
    if(param.size() == 2)
    {
        if (entry->variableType == param[1])
            entry->isInitialised = true;
        else
        {
            return false;
        }
            
    }
    else
    {
        entry->value = var;
        entry->isInitialised = true;
    }
    return true;
}

SymbolTree::~SymbolTree()
{
    delete this->globalTable;
}