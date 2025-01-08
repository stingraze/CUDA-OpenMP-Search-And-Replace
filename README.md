# CUDA-OpenMP-Search-And-Replace
Parallel Search &amp; Replace using OpenMP and CUDA

Tested to work on GH200 machine with ARM 64 vCPU 432GiB of RAM and 96GB of VRAM.

Please share your results of how the scalability is with big text files!

(C)Tsubasa Kato - Inspire Search Corp - 2025/1/9 - 0:37AM JST
Created with the help of ChatGPT - o1

To compile:

1.

```
nvcc -c hybrid_search_replace.cu -o hybrid_search_replace_cuda.o
```
2.

```
g++ -fopenmp -c hybrid_search_replace.cpp -o hybrid_search_replace_openmp.o
```
3.

```
g++ -fopenmp hybrid_search_replace_cuda.o hybrid_search_replace_openmp.o -o hybrid_search_replace -lcudart -L/usr/local/cuda/lib64
```

