#include <iostream>
#include <cuda.h>
#include <stdio.h>

using std::cout;
using std::endl;

__global__ void my_kernel_1()
{

    printf("I'm in block %i, thread %i", blockIdx.x, threadIdx.x);

}

__global__ void my_kernel2()
{

    int blockId = blockIdx.y * gridDim.x + blockIdx.x;
    int threadId = blockId * blockDim.x * blockDim.y + threadIdx.y * blockDim.x + threadIdx.x;

    printf("Running thread %i in block %i", threadId, blockId);

    //prinft("Block position: x %i, y %i", blockIdx.x, blockIdx.y);
    //printf("Thread posirion: x %i, y %i", threadIdx.x, threadIdx.y);

}

int main(int argc, char *argv[])
{

    cout << "Hello world!! I will call the first CUDA kernel now!!" << endl;
    my_kernel_1<<<4, 4, 0>>>()

    dim3 nblocks(4, 1, 1);
    dim3 nthreads(4, 1, 1);
    cout << "Launching the second CUDA kernel now!!" << endl;
    my_kernel_1<<<nblocks, nthreads, 0>>>();

    dim3 nblocks2(2,2,1);
    dim3 nthreads2(2,2,1);
    cout << "Launching the third CUDA kernel now!!" << endl;
    my_kernel2<<<nblocks2, nthreads2, 0>>>();

    return 0;
}
