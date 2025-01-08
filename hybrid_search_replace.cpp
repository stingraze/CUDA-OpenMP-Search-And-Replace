#include <omp.h>
#include <iostream>
#include <fstream>
#include <vector>
#include <string>
#include "hybrid_search_replace.cuh" // Header file for CUDA functions

// Define constants for chunk size
const size_t CHUNK_SIZE = 1024 * 1024 * 256; // 256 MB per chunk

void process_file(const std::string &input_path, const std::string &output_path, const std::string &search, const std::string &replace) {
    std::ifstream input_file(input_path, std::ios::binary);
    std::ofstream output_file(output_path, std::ios::binary);

    if (!input_file.is_open() || !output_file.is_open()) {
        std::cerr << "Error opening files!" << std::endl;
        return;
    }

    std::vector<char> chunk(CHUNK_SIZE);

    #pragma omp parallel
    {
        while (!input_file.eof()) {
            // Read a chunk of the file
            input_file.read(chunk.data(), CHUNK_SIZE);
            std::streamsize bytes_read = input_file.gcount();

            if (bytes_read > 0) {
                chunk.resize(bytes_read);

                // Use CUDA to process the chunk
                #pragma omp single nowait
                {
                    process_chunk_with_cuda(chunk, search, replace);
                }

                // Write the processed chunk to the output file
                #pragma omp critical
                {
                    output_file.write(chunk.data(), bytes_read);
                }
            }
        }
    }

    input_file.close();
    output_file.close();
}

int main(int argc, char *argv[]) {
    if (argc != 5) {
        std::cerr << "Usage: " << argv[0] << " <input_file> <output_file> <search_word> <replace_word>" << std::endl;
        return 1;
    }

    std::string input_path = argv[1];
    std::string output_path = argv[2];
    std::string search = argv[3];
    std::string replace = argv[4];

    // Process the file
    process_file(input_path, output_path, search, replace);

    return 0;
}

