#ifndef HYBRID_SEARCH_REPLACE_CUH
#define HYBRID_SEARCH_REPLACE_CUH

#include <vector>
#include <string>

// Function to process a chunk using CUDA
void process_chunk_with_cuda(std::vector<char> &chunk, const std::string &search, const std::string &replace);

#endif

