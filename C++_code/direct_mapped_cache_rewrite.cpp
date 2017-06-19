#include <iostream>
#include <fstream>
#include <map>
#include <functional>
#include <cmath>

struct Cache
{
    std::map<int, int>  data;
    Cache(int size, int block_size){}

    bool exist(int index)
    {
	return (data.find(index) != data.end());
    }

    Cache& add(int index, int tag)
    {
	data[index] = tag;
	return *this;
    }

    int& index_at(int index)
    {
	return data[index];
    }
};

typedef unsigned long long int ulli;
ulli operator"" _KB (ulli x) { return x * 1024; }
ulli operator"" _B  (ulli x) { return x; }

double calculate_rate(int cache_size, int block_size, std::istream &input)
{
    std::function<double(double)> log2 = [](double n){return std::log(n) / std::log(2);};
    int offset_bit = static_cast<int>(log2(block_size));
    int index_bit  = static_cast<int>(log2(cache_size/block_size));
    int line       = cache_size >> (offset_bit);

    Cache cache(line, block_size);
    ulli addr, time_x(0), miss_time(0);
    while(input >> std::hex >> addr)
    {
	unsigned int tag, index;
//    	std::cout << std::hex << addr << " \n";
    	index = (addr >> offset_bit) & (line - 1);
    	tag   =  addr >> (index_bit + offset_bit);
//	std::cout << std::hex << tag << " " << std::hex << index << "\n";
	if(! cache.exist(index))
	{
	    cache.add(index, tag);
	    miss_time++;
	}
	else if(cache.index_at(index) != tag)
	{
	    cache.add(index, tag);
	    miss_time++;
	}
	time_x++;
    }
    return static_cast<double>(miss_time) / time_x;
}

int main(int argc, char *argv[])
{
    std::cout << ((argc < 2)? "read from stdin\n": "read from " + std::string(argv[1]) + "\n");
    std::cout << "miss rate: ";
    std::cout << ((argc < 2)? calculate_rate(4_KB, 16_B, std::cin): [&]{ std::ifstream i(argv[1]); return
		              calculate_rate(4_KB, 16_B, i);}());
    std::cout << "\n";
    return 0;
}
