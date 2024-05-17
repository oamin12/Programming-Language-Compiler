#pragma once
#include <iostream>
#include <string>
#include <cstring>
#include <list>
#include <stack>
#include <vector>
#include <fstream>
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
    list<QuadrapleEntry*> quadraples_functions;
    int entryCount = 0;
    int labelCount = 0;
    int lineCount = 0;
    int loopCount = 0;
    stack<string> labels;
    stack<string> lines; // for branching statements line1: line2: etc
    list<string> lines_list; // we use it to pop back the lines for the if else statements
    vector<list<string>> lines_list_vec; // we use it to pop back the lines for the if else statements to handle nested if else
    stack<string> loops; // for loops
    ///Switch case
    list<string> casesIDs;
    
    void incrementCount();
    void incrementLabelCount();
    
public:
    int currentListIndex = -1; // for nested if else
    int isFunctionFlag = 0;

    Quadraples();
    void insertEntry(QuadrapleEntry* entry);
    void insertEntry(string operation, string arg1, string arg2, string result);
    void insertVariable(string name);
    void popVariable();
    void unaryOperation(char* operation, char* result);
    void binaryOperation(char* operation, char* result);
    void branchingOperation(char* jumpType);
    void addLine();
    void addLine2();

    void addLineStart();

    void startLoop();
    void endLoop();
    void endForLoop(char* line);
    
    void incrementLineCount();
    void jumpOperation();
    void clearVariablesStack();
    char* getCurrentLabel();
    char* getCurrentLine();
    char* getCurrentLoop();
    int  getLineCountinStack();
    void printQuadraples() const;
    void resetCount();
    void resetLabelCount();

    //Switch case
    void insertCase(char* caseValue);
    void jumpStartCase();
    void jumpEndCase();
    void addLineCase();
    void insertCaseID(char* caseValue);
    void processCaseIds(char* switchValue);

    void printQuadraplesToFile(char* filename) const;
    ~Quadraples();
};

