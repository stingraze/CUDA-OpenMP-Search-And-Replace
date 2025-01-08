#include <cuda_runtime.h>
#include "hybrid_search_replace.cuh"
#include <string>
#include <vector>

// CUDA kernel for search and replace
__global__ void search_and_replace(char *text, size_t text_length, const char *search, const char *replace, size_t search_length, size_t replace_length) {
    size_t idx = blockIdx.x * blockDim.x + threadIdx.x;

    if (idx + search_length > text_length) return;

    // Check for a match
    bool match = true;
    for (size_t i = 0; i < search_length; ++i) {
        if (text[idx + i] != search[i]) {
            match = false;
            break;
        }
    }

    // Perform replacement if there's a match
    if (match) {
        for (size_t i = 0; i < replace_length; ++i) {
            text[idx + i] = replace[i];
        }
        // Null-terminate if replacement is shorter
        for (size_t i = replace_length; i < search_length; ++i) {
            text[idx + i] = '\0';
        }
    }
}

void process_chunk_with_cuda(std::vector<char> &chunk, const std::string &search, const std::string &replace) {
    size_t chunk_size = chunk.size();

    // Allocate memory on GPU
    char *d_text;
    cudaMalloc(&d_text, chunk_size);
    cudaMemcpy(d_text, chunk.data(), chunk_size, cudaMemcpyHostToDevice);

    char *d_search, *d_replace;
    size_t search_length = search.size();
    size_t replace_length = replace.size();
    cudaMalloc(&d_search, search_length);
    cudaMalloc(&d_replace, replace_length);
    cudaMemcpy(d_search, search.c_str(), search_length, cudaMemcpyHostToDevice);
    cudaMemcpy(d_replace, replace.c_str(), replace_length, cudaMemcpyHostToDevice);

    // Launch CUDA kernel
    int threads_per_block = 256;
    int blocks_per_grid = (chunk_size + threads_per_block - 1) / threads_per_block;
    search_and_replace<<<blocks_per_grid, threads_per_block>>>(d_text, chunk_size, d_search, d_replace, search_length, replace_length);

    // Copy the result back to CPU
    cudaMemcpy(chunk.data(), d_text, chunk_size, cudaMemcpyDeviceToHost);

    // Free GPU memory
    cudaFree(d_text);
    cudaFree(d_search);
    cudaFree(d_replace);
}

