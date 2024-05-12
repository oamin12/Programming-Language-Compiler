#include <iostream>
using namespace std;
#include <string>

char* ConvertFromNumberToString(float number)
{
    return strdup(to_string(number).c_str());
}

char* ConvertFromNumberToString(int number)
{
    return strdup(to_string(number).c_str());
}

char* ConvertFromCharToString(char ch)
{
    return strdup(&ch);
}