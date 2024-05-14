#include "Quadrables.h"

Quadrables::Quadrables(string operation, string arg1, string arg2, string result, string label = "")
{
    if (!operation.empty() && !arg1.empty() && !arg2.empty() && !result.empty())
    {
        QuadrableEntry* entry = new QuadrableEntry(operation, arg1, arg2, result, label);
        this->quadrables.push_back(entry);
    }
}

void Quadrables::insert(QuadrableEntry* entry)
{
    this->quadrables.push_back(entry);
    this->incrementCount();
}

void Quadrables::incrementCount()
{
    this->entryCount++;
}

void Quadrables::incrementLabelCount()
{
    this->labelCount++;
}

void Quadrables::resetCount()
{
    this->entryCount = 0;
}

void Quadrables::resetLabelCount()
{
    this->labelCount = 0;
}


void Quadrables::printQuadrables() const
{
    for (auto quad : this->quadrables)
    {
        quad->printEntry();
    }
}

Quadrables::~Quadrables()
{
    for (auto quad : this->quadrables)
    {
        delete quad;
    }
}

