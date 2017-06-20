#include <iostream>
#include <fstream>
#include <cmath>
#include <vector>
#include <climits>

struct cache_cell
{
    bool         valid = false;
    unsigned int tag;
    int          last_time;

    cache_cell& set_valid(bool v)
    {
	valid = v;
	return *this;
    }
    cache_cell& set_tag(unsigned int v)
    {
	tag = v;
	return *this;
    }
    cache_cell& set_last_time(int v)
    {
	last_time = v;
	return *this;
    }
};
typedef unsigned long long int ulli;
ulli operator"" _KB (ulli x) { return x * 1024; }
ulli operator"" _B  (ulli x) { return x; }
ulli operator"" _way(ulli x) { return x; }


void simulate(int way, int cache_size, int block_size, std::string file_name)
{
    std::function<double(double)> log2 = [](double n){return std::log(n) / std::log(2);};
    int offset_bit = static_cast<int>( log2(block_size) );
    int index_bit  = static_cast<int>( log2(cache_size/block_size/way) );
    int line       = 1 << index_bit;

    std::vector<std::vector<cache_cell> > cache(line, std::vector<cache_cell>(way));
    
    std::ifstream input(file_name);
    ulli addr, time_x(0), miss_time(0);
    while(input >> std::hex >> addr)
    {
	unsigned int tag, index;
	index = (addr >> offset_bit) & (line - 1);
        tag   =  addr >> (index_bit + offset_bit);
        bool hit = false;
	for(cache_cell &cell : cache.at(index))
            if( cell.valid && cell.tag == tag )
	    { 
                hit = true;
                cell.set_last_time(time_x);
                break;
            }
        

        if(not hit)
	{ 
            miss_time++;
	    
            int empty = false;
	    for(cache_cell &cell : cache.at(index))
                if( not cell.valid )
		{
                    empty = true;
                    cell.set_valid(true)
			.set_tag(tag)
			.set_last_time(time_x);
                    break;
                }
            
            if( not empty )
	    {
                int min_time  = INT_MAX;
                int index_min = -1;

	        for(int i(0); i < way; i++)
                    if(min_time > cache.at(index).at(i).last_time)
		    {
                        min_time  = cache.at(index).at(i).last_time;
                        index_min = i;
                    }
                
		cache.at(index).at(index_min).set_valid(true)
                                             .set_tag(tag)
                                             .set_last_time(time_x);
            }

        }
	time_x++;
    }
    std::cout << "cache size \t"    << cache_size  << std::endl;
    std::cout << "block size \t"    << block_size  << std::endl;
    std::cout << "miss rate: \t"    << static_cast<double>(miss_time)/time_x << std::endl;
    std::cout << std::endl;
}

int main(int argc, char *argv[])
{
    std::vector<std::string> files{"./ICACHE.txt", "./DCACHE.txt"};
    for(std::string &file : files)
    {
	std::cout << "from: " << file << "\n";
	for(int cache_size(4_KB); cache_size <= 256_KB; cache_size <<= 1)
	    for(int block_size(16_B); block_size <= 256_B; block_size <<= 1)
		simulate(1_way, cache_size, block_size, file);
    }
	
    return 0;
}
