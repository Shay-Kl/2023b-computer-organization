
#include <string.h>
#include <stdlib.h>

int foo(int a)
{
    return a;
}

//Returns a*2
int func(int a)
{
    if(a==0)
    {
        return 0;
    }
    func(0);
    foo(foo(foo(foo(foo(1)))));
    return a*2;
}

int main(int argc, char *const argv[])
{
    func(atoi(argv[1]));
    func(atoi(argv[2]));
    func(atoi(argv[3]));
    return 0;
}