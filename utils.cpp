#include "utils.h"

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

std::vector<std::string> splitString(const std::string& str, char delimiter) {
    std::vector<std::string> result;
    std::stringstream ss(str);
    std::string token;
    
    while (std::getline(ss, token, delimiter)) {
        result.push_back(token);
    }
    
    return result;
}

char* concatenateThreeStrings(char* str1, char* str2, char* str3)
{
    string result = string(str1) + "," + string(str2) + " " + string(str3);
    return strdup(result.c_str());
}

char* concatenateTwoStrings(char* str1, char* str2)
{
    string result = string(str1) + " " + string(str2);
    return strdup(result.c_str());
}