#pragma once
#include <iostream>
#include <string>
#include <cstring>
#include <list>
#include <stack>
using namespace std;

struct QuadrapleEntry
{
    /* data */
    string operation;
    string arg1;
    string arg2;
    string result;
    string label;

    QuadrapleEntry(string operation, string arg1, string arg2, string result, string label = "")
    {
        this->operation = operation;
        this->arg1 = arg1;
        this->arg2 = arg2;
        this->result = result;
        this->label = "";
    }

    void printEntry()
    {
        cout << this->label << this->operation << " " << this->arg1 << " " << this->arg2 << " " << this->result << endl;
    }
};


class Quadraples
{
private:
    /* data */
    list<QuadrapleEntry*> quadraples;
    int entryCount = 0;
    int labelCount = 0;
    int lineCount = 0;
    stack<string> labels;
    stack<string> lines; // for branching statements line1: line2: etc
    

    
    void incrementCount();
    void incrementLabelCount();
    
public:
    Quadraples();
    void insertEntry(QuadrapleEntry* entry);
    void insertEntry(string operation, string arg1, string arg2, string result);
    void insertVariable(string name);
    void unaryOperation(char* operation, char* result);
    void binaryOperation(char* operation, char* result);
    void branchingOperation(char* jumpType);
    void addLine();
    void addLineStart();
    void incrementLineCount();
    void jumpOperation();
    void clearVariablesStack();
    char* getCurrentLabel();
    char* getCurrentLine();
    int  getLineCountinStack();
    void printQuadraples() const;
    void resetCount();
    void resetLabelCount();
    ~Quadraples();
};

