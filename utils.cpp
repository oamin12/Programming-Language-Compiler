#include <iostream>
using namespace std;
#include <string>

// char* ConvertFromNumberToString(float number)
// {
//     return strdup(to_string(number).c_str());
// }

char* ConvertFromNumberToString(int number)
{
    return strdup(to_string(number).c_str());
}

char* ConvertFromCharToString(char ch)
{
    return strdup(&ch);
}

char* CompareValues(char* value1, char* value2, char* oper) 
{
    int comparisonResult = strcmp(value1, value2);
    
    if (strcmp(oper, "==") == 0)
    {
        return ConvertFromNumberToString(comparisonResult == 0);
    }
    else if (strcmp(oper, "!=") == 0)
    {
        return ConvertFromNumberToString(comparisonResult != 0);
    }
    else if (strcmp(oper, ">") == 0)
    {
        return ConvertFromNumberToString(comparisonResult > 0);
    }
    else if (strcmp(oper, "<") == 0)
    {
        return ConvertFromNumberToString(comparisonResult < 0);
    }
    else if (strcmp(oper, ">=") == 0)
    {
        return ConvertFromNumberToString(comparisonResult >= 0);
    }
    else if (strcmp(oper, "<=") == 0)
    {
        return ConvertFromNumberToString(comparisonResult <= 0);
    }
    else
    {
        return strdup("0");
    }
}

char* ANDing(char* value1, char* value2)
{
    return ConvertFromNumberToString(atoi(value1) && atoi(value2));
}

char* ORing(char* value1, char* value2)
{
    return ConvertFromNumberToString(atoi(value1) || atoi(value2));
}

char* NOTing(char* value)
{
    return ConvertFromNumberToString(!atoi(value));
}