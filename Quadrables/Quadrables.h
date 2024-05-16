#pragma once
#include <iostream>
#include <string>
#include <unordered_map>
#include <list>
#include "QuadrableEntry.h"


using namespace std;

class Quadrables
{
private:
    /* data */
    list<QuadrableEntry*> quadrables;
    int entryCount = 0;
    int labelCount = 0;
    
    void incrementCount();
    void incrementLabelCount();
    
public:
    Quadrables(string operation, string arg1, string arg2, string result, string label = "");
    void insert(QuadrableEntry* entry);
    void printQuadrables() const;
    void resetCount();
    void resetLabelCount();
    ~Quadrables();
};

