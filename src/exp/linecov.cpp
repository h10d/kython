// #include "linecov.hpp"

int abc(int fct, int abc)
{
    if (fct == 10)
    {
        return 1;
    }
    else
    {
        if (abc < 5)
        {
            return fct;
        }
        else
        {
            return abc;
        }
    }
}
