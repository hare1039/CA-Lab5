#include <iostream>
#include <fstream>

typedef unsigned long long int ulli;
ulli operator"" _KB (ulli x) { return x * 1024; }
ulli operator"" _B  (ulli x) { return x; }

int decode(std::istream &input)
{    
    std::string s;
    while(std::getline(input, s))
	std::cout << s << "\n";
    return 0;
}

int main(int argc, char *argv[])
{
    if(argc < 2)
    {
	std::cerr << "warning: no input file name. Read from stdin\n";
	return decode(std::cin);
    }
    else
    {
	std::ifstream i(argv[1]);
	if(not i.is_open())
	{
	    std::cerr << argv[1] << " not opened\n";
	    return 1;
	}
	return decode(i);
    }
}
