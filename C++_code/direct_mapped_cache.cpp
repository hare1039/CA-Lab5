#include <iostream>
#include <cstdio>
#include <cmath>

struct cache_content
{
    bool v;
    unsigned int tag;
//  unsigned int data[16];    
};

const int K=1024;

double log2( double n )  
{  
    // log(n)/log(2) is log2.  
    return log( n ) / log(double(2));  
}


double simulate(int cache_size, int block_size)
{
    unsigned int tag, index, x;
    
    int offset_bit = static_cast<int>(log2(block_size));
    int index_bit  = static_cast<int>(log2(cache_size/block_size));
    int line = cache_size >> (offset_bit);
    
    cache_content *cache = new cache_content[line];
    std::cout << "cache line:" << line << std::endl;
    
    for(int j = 0; j < line; j++)
    	cache[j].v = false;
    
    FILE * fp = fopen("../verilog_code/Lab03/DCACHE.txt", "r");		//read file using c styled
    int total(0), miss(0);
    while(fscanf(fp,"%x",&x)!=EOF)
    {
//    	std::cout << std::hex << x << " ";
    	index = (x >> offset_bit) & (line-1);
    	tag   =  x >> (index_bit + offset_bit);
    	if(cache[index].v && cache[index].tag==tag)
	{
	    cache[index].v = true; 			//hit
    	}
    	else
	{						
	    cache[index].v   = true;			//miss
	    cache[index].tag = tag;
	    miss++;
    	}

	total++;
    }
    fclose(fp);
    
    delete [] cache;
    return static_cast<double>(miss)/total;
}
	
int main()
{
	// Let us simulate 4KB cache with 16B blocks
    std::cout << "miss: " << simulate(256*K, 16) << "\n";
    std::cout << "miss: " << simulate(256*K, 32) << "\n";
    std::cout << "miss: " << simulate(256*K, 64) << "\n";
    std::cout << "miss: " << simulate(256*K, 128) << "\n";
    std::cout << "miss: " << simulate(256*K, 256) << "\n";
		    
}
