#include <iostream>
#include <fstream>
#include <cmath>
#include <vector>

struct cache_content
{
    bool         valid = false;
    unsigned int tag;
    int          last_time;
};
typedef unsigned long long int ulli;
ulli operator"" _KB (ulli x) { return x * 1024; }
ulli operator"" _B  (ulli x) { return x; }
ulli operator"" _way(ulli x) { return x; }


void simulate(int way, int cache_size, int block_size, std::string &&file_name)
{
    std::function<double(double)> log2 = [](double n){return std::log(n) / std::log(2);};
    int offset_bit = static_cast<int>( log2(block_size) );
    int index_bit  = static_cast<int>( log2(cache_size/block_size/way) );
    int line       = 1 << index_bit;

    std::vector<std::vector<cache_content> > cache(line, std::vector<cache_content>(way));
    
    std::ifstream input(file_name);
    ulli addr, time_x(0), miss_time(0);
    while(input >> std::hex >> addr)
    {
	unsigned int tag, index;
	index = (addr >> offset_bit) & (line - 1);
        tag   =  addr >> (index_bit + offset_bit);
        bool hit = false;
        for(int i(0); i < way; i++)
	{
            if( cache[index][i].valid && cache[index][i].tag == tag )
	    { // hit
                hit = true;
                cache[index][i].last_time = time_x;
                break;
            }
        }

        if(not hit)
	{ 
            miss_time++;

            int find_empty = false;
            for(int i(0); i < way; i++)
	    {
                if( cache[index][i].valid == false )
		{
                    find_empty = true;
                    cache[index][i].valid     = true;
                    cache[index][i].tag       = tag;
                    cache[index][i].last_time = time_x;
                    break;
                }
            }
            if(find_empty == false)
	    {
                int min_time  = 99999;
                int index_min = -1;

                for(int i(0); i < way; i++)
		{
                    if(min_time > cache[index][i].last_time)
		    {
                        min_time  = cache[index][i].last_time;
                        index_min = i;
                    }
                }
                cache[index][index_min].valid     = true;
                cache[index][index_min].tag       = tag;
                cache[index][index_min].last_time = time_x;
            }

        }
	time_x++;
    }

    std::cout << std::endl;
    std::cout << "way:       \t"    << way           << std::endl;
    std::cout << "miss rate: \t"    << static_cast<double>(miss_time)/time_x << std::endl;
    std::cout << std::endl;
}

int main(int argc, char *argv[])
{
    int block_size = 64_B;
    
    for(int ways(1_way); ways < 16; ways <<= 1)
    {
	for(int cache_size(1_KB); cache_size < 64_KB; cache_size <<= 1)
	{
	    simulate(ways, cache_size, block_size, std::string(argv[1]));
	}
    }
    

    return 0;
}
