#include <iostream>
#include <cuda.h>
#include <stdio.h>

using std::cout;
using std::endl;

__global__ void my_kernel(float mypi)
{
    printf("Printf hello from the kernel!!\n");
    printf("I'm in thread %i \n", threadIdx.x);
    printf("Someone sent me %f \n", mypi);
}

int main(int argc, char *argv[])
{
    cout << "Hello world!! I will call a CUDA kernel now!!" << endl;
    my_kernel<<<1,1,0>>>(3.1415f);
    cudaDeviceSynchronize();
    return 0;
}
