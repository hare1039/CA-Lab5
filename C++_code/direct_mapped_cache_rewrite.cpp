#include <iostream>
#include <fstream>
#include <map>
#include <functional>
#include <cmath>
#include <vector>
#include <cstdint>

#define UNTIL(x) while(!(x))

struct Cache
{
    std::vector<std::vector<int> > data;
    std::vector<std::vector<int> > least_used;
    Cache(int size, int block_size, int way): data      (2000, std::vector<int>(way, -1)),
    least_used(2000, std::vector<int>(2000, INT_MAX)){}
    
    bool exist(int index, int pos)
    {
        return (data.at(index).at(pos) != -1);
    }
    
    Cache& add(int index, int tag)
    {
        int mini = INT_MAX;
        int pos(0), small_pos(0);
        for(int &i : least_used.at(index))
        {
            if(mini > i)
            {
                mini = i;
                small_pos = pos;
            }
            pos++;
        }
        data[index][small_pos] = tag;
        return *this;
    }
    
    Cache& update_clock()
    {
        for(std::vector<int> & v : least_used)
            for(int& i : v)
                i--;
        return *this;
    }
    
    int& index_at(int index, int pos)
    {
        return data.at(index).at(pos);
    }
};

typedef unsigned long long int ulli;
ulli operator"" _KB (ulli x) { return x * 1024; }
ulli operator"" _B  (ulli x) { return x; }
ulli operator"" _way(ulli x) { return x; }

double calculate_rate(int cache_size, int block_size, int way, std::istream &input)
{
    std::function<double(double)> log2 = [](double n){return std::log(n) / std::log(2);};
    int offset_bit = static_cast<int>(log2(block_size * way));
    int index_bit  = static_cast<int>(log2(cache_size/block_size));
    int line       = cache_size >> (offset_bit);
    
    Cache cache(line, block_size, way);
    ulli addr, time_x(0), miss_time(0);
    while(input >> std::hex >> addr)
    {
        unsigned int tag, index;
        //    	std::cout << std::hex << addr << " \n";
        index = (addr >> offset_bit) & (line - 1);
        tag   =  addr >> (index_bit + offset_bit);
        //	std::cout << std::hex << tag << " " << std::hex << index << "\n";
        int pos(0);
        bool hited = false;
        while(pos < way && cache.exist(index, pos))
        {
            if(cache.index_at(index, pos) == tag)
            {
                // hit
                hited = true;
                break;
            }
            pos++;
        }
        std::cout << "";
        if(not hited)
        {
            if(pos != way)
            {
                cache.index_at(index, pos) = tag;
                miss_time++;
            }
            else
            {
                cache.add(index, tag);
                miss_time++;
            }
        }
        
        
        cache.update_clock();
        time_x++;
    }
    return static_cast<double>(miss_time) / time_x;
}

int main(int argc, char *argv[])
{
    std::cout << ((argc < 2)? "read from stdin\n": "read from " + std::string(argv[1]) + "\n");
    std::cout << "miss rate: ";
    std::cout << ((argc < 2)? calculate_rate(1_KB, 64_B, 2_way, std::cin): [&]{ std::ifstream i(argv[1]); return
        calculate_rate(1_KB, 64_B, 2_way, i);}());
    std::cout << "\n";
    std::cout << "miss rate: ";
    std::cout << ((argc < 2)? calculate_rate(2_KB, 64_B, 2_way, std::cin): [&]{ std::ifstream i(argv[1]); return
        calculate_rate(2_KB, 64_B, 2_way, i);}());
    std::cout << "\n";
    std::cout << "miss rate: ";
    std::cout << ((argc < 2)? calculate_rate(4_KB, 64_B, 2_way, std::cin): [&]{ std::ifstream i(argv[1]); return
        calculate_rate(4_KB, 64_B, 2_way, i);}());
    std::cout << "\n";
    std::cout << "miss rate: ";
    std::cout << ((argc < 2)? calculate_rate(8_KB, 64_B, 2_way, std::cin): [&]{ std::ifstream i(argv[1]); return
        calculate_rate(8_KB, 64_B, 2_way, i);}());
    std::cout << "\n";
    std::cout << "miss rate: ";
    std::cout << ((argc < 2)? calculate_rate(16_KB, 64_B, 2_way, std::cin): [&]{ std::ifstream i(argv[1]); return
        calculate_rate(16_KB, 64_B, 2_way, i);}());
    std::cout << "\n";
    std::cout << "miss rate: ";
    std::cout << ((argc < 2)? calculate_rate(32_KB, 64_B, 2_way, std::cin): [&]{ std::ifstream i(argv[1]); return
        calculate_rate(32_KB, 64_B, 2_way, i);}());
    std::cout << "\n";
    std::cout << "miss rate: ";
    std::cout << ((argc < 2)? calculate_rate(64_KB, 64_B, 2_way, std::cin): [&]{ std::ifstream i(argv[1]); return
        calculate_rate(64_KB, 64_B, 2_way, i);}());
    std::cout << "\n";
    return 0;
}


