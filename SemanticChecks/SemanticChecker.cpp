#include "SemanticChecker.h"
#include <algorithm>
#include <cstring>

SemanticChecker::SemanticChecker()
{
    this->errors = new list<string>;
    this->warnings = new list<string>;
}



bool SemanticChecker::isInt(char* str)
{
    char* temp = str;
    bool isFirstChar = true;
    while(*temp)
    {
        if(isFirstChar && *temp == '-')
        {
            isFirstChar = false;
            temp++;
            continue;
        }
        if(!isdigit(*temp))
            return false;
        temp++;
    }
    return true;
}

bool SemanticChecker::isFloat(char* str)
{
    char* temp = str;
    bool decimal = false;
    bool isFirstChar = true;
    while(*temp)
    {
        if(isFirstChar && *temp == '-')
        {
            isFirstChar = false;
            temp++;
            continue;
        }
        if(!isdigit(*temp))
        {
            if(*temp == '.' && !decimal)
                decimal = true;
            else
                return false;
        }
        temp++;
    }
    return true;
}

bool SemanticChecker::isString(char* str)
{
    if(str[0] == '"' && str[strlen(str) - 1] == '"')
        return true;
    return false;
}

bool SemanticChecker::isChar(char* letter)
{
    if(strlen(letter) == 2 && isAlphaNumeric(letter[0]))
        return true;
    return false;
}

// bool SemanticChecker::isBool(char* str)
// {
//     if(strcmp(str, "true") == 0 || strcmp(str, "false") == 0)
//         return true;
//     return false;
// }

bool SemanticChecker::isAlphaNumeric(char letter)
{
    if((letter >= 'a' && letter <= 'z') || (letter >= 'A' && letter <= 'Z') || (letter >= '0' && letter <= '9'))
        return true;
    return false;
}

bool SemanticChecker::matchTypes(char* type1, char* type2)
{
    if((strcmp(type1, type2) == 0) || //same type
        (strcmp(type1, "int") == 0 && strcmp(type2, "float") == 0) ||  //int to float
        (strcmp(type1, "float") == 0 && strcmp(type2, "int") == 0) || //float to int
        (strcmp(type1, "string") == 0 && strcmp(type2, "char") == 0)||
        (strcmp(type1, "int") == 0 && strcmp(type2, "bool") == 0)||
        (strcmp(type1, "bool") == 0 && strcmp(type2, "int") == 0))
        return true;

    return false;
}

char* SemanticChecker::determineType(int str)
{
    return (char*)"int";
}

char* SemanticChecker::determineType(float str)
{
    return (char*)"float";
}

char* SemanticChecker::determineType(char* str)
{
    if(isInt(str))
        return (char*)"int";
    else if(isFloat(str))
        return (char*)"float";
    // else if(isBool(str))
    //     return (char*)"bool";
    else if(isString(str))
        return (char*)"string";
    else if(isChar(str))
        return (char*)"char";
    else
        return (char*)"undefined";
}

void SemanticChecker::addError(int lineNumber, char* str)
{   
    string error = "Error at line " + to_string(lineNumber) + ": " + str;
    this->errors->push_back(error);
}

void SemanticChecker::addWarning(int lineNumber, char* str)
{
    string warning = "Warning at line " + to_string(lineNumber) + ": " + str;
    this->warnings->push_back(str);
}

void SemanticChecker::printErrors()
{
    for(auto it = this->errors->begin(); it != this->errors->end(); it++)
        cout << *it << endl;
}

void SemanticChecker::printWarnings()
{
    for(auto it = this->warnings->begin(); it != this->warnings->end(); it++)
        cout << *it << endl;
}

SemanticChecker::~SemanticChecker()
{
    this->errors->clear();
    this->warnings->clear();

    delete this->errors;
    delete this->warnings;
}
