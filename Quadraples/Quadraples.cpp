#include "Quadraples.h"

Quadraples::Quadraples()
{

}

void Quadraples::insertEntry(QuadrapleEntry* entry)
{
    this->quadraples.push_back(entry);
    this->incrementCount();
}

void Quadraples::insertEntry(string operation, string arg1, string arg2, string result)
{
    QuadrapleEntry* entry = new QuadrapleEntry(operation, arg1, arg2, result);
    this->insertEntry(entry);
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

void Quadraples::branchingOperation(char* jumpType)
{
    string line = getCurrentLine();
    this->lineCount++;
    lines.push(line);
    lines_list.push_front(line);
    string arg2 = labels.top();
    labels.pop();
    string arg1 = labels.top();
    labels.pop();
    
    string jump(jumpType);
    
    if(jump == ">")
    {
        jump = "JLE";
    }
    else if(jump == "<")
    {
        jump = "JGE";
    }
    else if(jump == "==")
    {
        jump = "JNE";
    }
    else if(jump == "!=")
    {
        jump = "JE";
    }
    else if(jump == ">=")
    {
        jump = "JLT";
    }
    else if(jump == "<=")
    {
        jump = "JGT";
    }
    
    QuadrapleEntry* entry = new QuadrapleEntry("CMP", arg1, arg2, "", "");
    QuadrapleEntry* lineEntry = new QuadrapleEntry(jump, "", "", line);
    this->insertEntry(entry);
    this->insertEntry(lineEntry);
}
//after this is called we have
//CMP arg1 arg2
//JMP/JLT/JGT/JEQ/JNE line

void Quadraples::addLine()
{
    string line = lines.top() + ":";
    lines.pop();
    QuadrapleEntry* entry = new QuadrapleEntry(line, "", "", "");
    this->insertEntry(entry);
}

void Quadraples::addLine2()
{
    string line = lines_list.back() + ":";
    lines_list.pop_back();
    QuadrapleEntry* entry = new QuadrapleEntry(line, "", "", "");
    this->insertEntry(entry);
}


void Quadraples::addLineStart()
{
    string line = getCurrentLine();
    QuadrapleEntry* entry = new QuadrapleEntry(line + ":", "", "", "");
    this->insertEntry(entry);
    lines.push(line);
}

void Quadraples::startLoop()
{
    string loop = getCurrentLoop();
    this->loopCount++;
    QuadrapleEntry* entry = new QuadrapleEntry(loop + ":", "", "", "");
    this->insertEntry(entry);
    loops.push(loop);
}

void Quadraples::endLoop()
{
    string loop = loops.top();
    string line = lines.top();
    loops.pop();
    lines.pop();
    QuadrapleEntry* entry = new QuadrapleEntry("JMP", "", "", loop);
    this->insertEntry(entry);
    QuadrapleEntry* entry2 = new QuadrapleEntry(line + ":", "", "", "");
    this->insertEntry(entry2);
}

void Quadraples::incrementLineCount()
{
    this->lineCount++;
}

void Quadraples::jumpOperation()
{
    string line = getCurrentLine();
    this->lineCount++;
    
    lines_list.push_front(line);
    QuadrapleEntry* entry = new QuadrapleEntry("JMP", "", "", line);
    this->insertEntry(entry);
}
//after this is called we have
//JMP line
    


char* Quadraples::getCurrentLabel()
{
    std::string label = "T" + std::to_string(this->entryCount);
    char* labelPtr = new char[label.length() + 1]; // +1 for null terminator
    strcpy(labelPtr, label.c_str());
    return labelPtr;
}

char* Quadraples::getCurrentLine()
{
    std::string line = "Line" + std::to_string(this->lineCount);
    char* linePtr = new char[line.length() + 1]; // +1 for null terminator
    strcpy(linePtr, line.c_str());
    return linePtr;
}

char *Quadraples::getCurrentLoop()
{
    std::string loop = "Loop" + std::to_string(this->loopCount);
    char* loopPtr = new char[loop.length() + 1]; // +1 for null terminator
    strcpy(loopPtr, loop.c_str());
    return loopPtr;
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

int Quadraples::getLineCountinStack()
{
    return lines.size();
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

