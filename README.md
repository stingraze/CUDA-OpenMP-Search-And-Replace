# CUDA-OpenMP-Search-And-Replace
Parallel Search &amp; Replace using OpenMP and CUDA

(C)Tsubasa Kato - Inspire Search Corp. - 2025/1/9 - 0:37AM JST
https://www.inspiresearch.io/en
Created with the help of ChatGPT - o1

Tested to work on GH200 machine with ARM 64 vCPU 432GiB of RAM and 96GB of VRAM.

![Screenshot of this script running on GH200](https://github.com/stingraze/CUDA-OpenMP-Search-And-Replace/blob/main/cuda-openmp-word-replacer2.jpg)

Please share your results of how the scalability is with big text files!

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

How to use:

```
./hybrid_search_replace input.txt output.txt "old_word" "new_word"

```
