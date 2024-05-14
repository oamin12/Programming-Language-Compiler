#include "Quadraples.h"

Quadraples::Quadraples()
{

}

void Quadraples::insertEntry(QuadrapleEntry* entry)
{
    this->quadraples.push_back(entry);
    this->incrementCount();
}

void Quadraples::insertVariable(string name)
{
    labels.push(name);
}

void Quadraples::unaryOperation(char* operation, char* result)
{
    string res(result);
    cout << "res: " << res << endl;
    string op(operation);
    cout << "op: " << op << endl;
    string arg1 = labels.top();
    cout << "arg1: " << arg1 << endl;
    labels.pop();
    cout << "label popped" << endl;
    QuadrapleEntry* entry = new QuadrapleEntry(op, arg1, "", res);
    this->insertEntry(entry);
    this->insertVariable(res);    
}

void Quadraples::binaryOperation(char* operation, char* result)
{
    string res(result);
    string op(operation);
    string arg2 = labels.top();
    labels.pop();
    string arg1 = labels.top();
    labels.pop();

    QuadrapleEntry* entry = new QuadrapleEntry(op, arg1, arg2, res);
    this->insertEntry(entry);
    this->insertVariable(res);
}

char* Quadraples::getCurrentLabel()
{
    std::string label = "T" + std::to_string(this->entryCount);
    char* labelPtr = new char[label.length() + 1]; // +1 for null terminator
    strcpy(labelPtr, label.c_str());
    return labelPtr;
}

void Quadraples::clearVariablesStack()
{
    while (!labels.empty())
    {
        labels.pop();
    }
}


void Quadraples::incrementCount()
{
    this->entryCount++;
}

void Quadraples::incrementLabelCount()
{
    this->labelCount++;
}

void Quadraples::resetCount()
{
    this->entryCount = 0;
}

void Quadraples::resetLabelCount()
{
    this->labelCount = 0;
}


void Quadraples::printQuadraples() const
{
    for (auto quad : this->quadraples)
    {
        quad->printEntry();
    }
}

Quadraples::~Quadraples()
{
    for (auto quad : this->quadraples)
    {
        delete quad;
    }
}

