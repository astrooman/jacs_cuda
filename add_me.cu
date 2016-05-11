#include <iostream>
#include <cuda.h>

using std::cout;
using std::endl;

__global__ add_me(int *a, int* b, int *c) {

    if(threadIdx.x < 8)
        c[threadIdx.x] = a[threadIdx.x] + b[threadIdx.x];

}

int main(int argc, char *argv[])
{

    int arr1[8] = {1, 2, 3, 4 , 5 ,6 ,7, 8};
    int arr2[8] = {9, 10, 11, 12, 13, 14, 15 ,16};

    cout << "First array: " << endl;
    for (int x: arr1) {
        cout << x << endl;
    }

    cout << endl << "Second array: " << endl;
    for (int x: arr2) {
        cout << x << endl;
    }

    int *d_a;
    int *d_b;
    int *d_c;

    int h_sum[8];

    cudaMalloc((void**)&d_a, 8 * sizeof(int));
    cudaMalloc((void**)&d_b, 8 * sizeof(int));
    cudaMalloc((void**)&d_c, 8 * sizeof(int));

    cudaMemcpy(d_a, arr1, 8 * sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy(d_b, arr2, 8 * sizeof(int), cudaMemcpyHostToDevice);

    add_me<<<1, 16>>>(d_a, d_b, d_c);

    cudaMemcpy(h_sum, d_c, 8 * sizeof(int), cudaMemcpyDeviceToHost);

    cout << endl << "First array + second array: " << endl;

    for (int ii = 0; ii < 8; ii++)
        cout << h_sum[ii] << endl;

    cudaFree(d_a);
    cudaFree(d_b);
    cudaFree(d_c);

    return 0;
}
