#include <chrono>
#include <iostream>
#include <cuda.h>

using std::cout;
using std::endl;

__global__ multiply_me_GPU(int *a, int *b, int *c) {


}

multiply_me_CPU(int *a, int *b, int *c) {

}


int main(int argc, char *argv[])
{

    int N = 2048;

    int *h_a = new int[N * N];
    int *h_b = new int[N * N];
    int *h_c = new int[N * N];
    int *h_c2 = new int [N * N];

    for (int ii = 0; ii < N; ii++) {
        h_a[ii] = ii;
        h_b[ii] = 2 * ii;
    }

    int *d_a;
    int *d_b;
    int *d_c;

    float copy_elapsed;
    cudaEvent_t copy_start;
    cudaEvent_t copy_stop;
    cudaEventCreate(&copy_start);
    cudaEventCreate(&copy_stop);

    cudaEventRecord(copy_start, 0);
    cudaMalloc((void**)&d_a, N * N * sizeof(int));
    cudaMalloc((void**)&d_b, N * N * sizeof(int));
    cudaMalloc((void**)&d_c, N * N * sizeof(int));

    cudaMemcpy(d_a, h_a, N * N * sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy(d_b, h_b, N * N * sizeof(int), cudaMemcpyHostToDevice);
    cudaEventRecord(copy_stop, 0);
    cudaEventSynchronise(copy_stop);
    cudaElapsedTime(&copy_elapsed, copy_start, copy_stop);

    float GPU_elapsed;
    cudaEvent_t GPU_start;
    cudaEvent_t GPU_stop;
    cudaEventCreate(&GPU_start);
    cudaEventCreate(&GPU_stop);

    cudaEventRecord(GPU_start, 0);
    multiply_me_GPU<<<1, 256>>>(d_a, d_b, d_c);
    cudaEventRecord(GPU_stop, 0);
    cudaEventSynchronise(GPU_stop);
    cudaElapsedTime(&GPU_elapsed, GPU_start, GPU_stop)

    cudaMemcpy(h_c, d_c, N * N * sizeof(int), cudaMemcpyDeviceToHost);

    std::chrono::time_point<std::chrono::system_clock> CPU_start, CPU_stop;
    std::chrono::duration<double> CPU_elapsed;

    CPU_start = std::chrono::system_clock::now();
    multiply_me_CPU(h_a, h_b, h_c2);
    CPU_stop = std::chrono::system_clock::now();
    CPU_elapsed = CPU_start - CPU_stop;

    cout << "It tool " << copy_elapsed / 1000.0f << "s to copy to data to the GPU" << endl;
    cout << "It took " << GPU_elapsed / 1000.0f << "s to multiply the matrix on the GPU" << endl;
    cout << "It took " << CPU_elapsed.count() << "s to multiply the matrix on the CPU" << endl;

    delete[] h_a;
    delete[] h_b;
    delete[] h_c;
    delete[] h_c2;

    cudaFree(d_a);
    cudaFree(d_b);
    cudaFree(d_c);

    return 0;
}
