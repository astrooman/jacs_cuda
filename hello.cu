#include <iostream>
#include <cuda.h>

using std::cout;
using std::endl;

__global__ void my_kernel()
{
    // I do absolutely nothing
}

int main(int argc, char *argv[])
{
    cout << "Hello world!! I will call a CUDA kernel now!!" << endl;
    my_kernel<<<1,1,0>>>();
    cudaDeviceSynchronize();
    return 0;
}
