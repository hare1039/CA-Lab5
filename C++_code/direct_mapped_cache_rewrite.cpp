#include <iostream>
#include <fstream>
#include <map>
#include <functional>
#include <cmath>
#include <vector>

struct Cache
{
    std::vector<int>  data;
    std::vector<bool> valid;
    Cache(int size): data(size), valid(size, false) {}
};

typedef unsigned long long int ulli;
ulli operator"" _KB (ulli x) { return x * 1024; }
ulli operator"" _B  (ulli x) { return x; }

int calculate_rate(int cache_size, int block_size, std::istream &input)
{
    ulli addr;
    std::function<double(double)> log2 = [](double n){return std::log(n) / std::log(2);};
    unsigned int tag, index, x;
    int offset_bit = static_cast<int>(log2(block_size));
    int index_bit  = static_cast<int>(log2(cache_size/block_size));
    int line       = cache_size >> (offset_bit);

    Cache cache(line);
    while(input >> addr)
    {
	
	
    }
    return 0;
}

int main(int argc, char *argv[])
{
    std::cout << ((argc < 2)? "read from stdin\n": "read from " + std::string(argv[1]) + "\n");
    return (argc < 2)? calculate_rate(4_KB, 16_B, std::cin): [&]{ std::ifstream i(argv[1]); return
		       calculate_rate(4_KB, 16_B, i);}();
}
