#pragma once
#include <iostream>
#include <string>
#include <unordered_map>
#include <vector>
#include <iostream>
using namespace std;

struct QuadrableEntry
{
    /* data */
    string operation;
    string arg1;
    string arg2;
    string result;
    string label;

    QuadrableEntry(string operation, string arg1, string arg2, string result, string label = "")
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

    ~QuadrableEntry()
    {
    }
};
