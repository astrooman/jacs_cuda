#include <iostream>
#include <cufft.h>

using std::cout;
using std::endl;

int main(int argc, char *argv[])
{

    cufftComplex *sig1 = new cufftComplex[8];
    cufftComplex *sig2 = new cufftComplex[8];
    cufftComplex *sig3 = new cufftComplex[8];

    for (int ii = 0; ii < 8; ii ++) {
        sig1[ii].x = 1.0f * (ii % 2);
        sig1[ii].y = 0.0f;
        sig2[ii].x = 0.0f;
        sig2[ii].y = -1.0f * (ii % 2);
        sig3[ii].x = sig1[ii].x;
        sig3[ii].y = sig2[ii].y;

    }

    cufftComplex *d_s1;
    cufftComplex *d_s2;
    cufftComplex *d_s3;

    cudaMalloc((void**)&d_s1, 8 * sizeof(cufftComplex));
    cudaMalloc((void**)&d_s2, 8 * sizeof(cufftComplex));
    cudaMalloc((void**)&d_s3, 8 * sizeof(cufftComplex));

    cudaMemcpy(d_s1, sig1, 8 * sizeof(cufftComplex), cudaMemcpyHostToDevice);
    cudaMemcpy(d_s2, sig2, 8 * sizeof(cufftComplex), cudaMemcpyHostToDevice);
    cudaMemcpy(d_s3, sig3, 8 * sizeof(cufftComplex), cudaMemcpyHostToDevice);

    cufftHandle fftplan;
    cufftPlan1d(&fftplan, 8, CUFFT_C2C, 1);
    cufftExecC2C(fftplan, d_s1, d_s1, CUFFT_FORWARD);
    cufftExecC2C(fftplan, d_s2, d_s2, CUFFT_FORWARD);
    cufftExecC2C(fftplan, d_s3, d_s3, CUFFT_FORWARD);

    cufftComplex *fft1 = new cufftComplex[8];
    cufftComplex *fft2 = new cufftComplex[8];
    cufftComplex *fft3 = new cufftComplex[8];

    cudaMemcpy(fft1, d_s1, 8 * sizeof(cufftComplex), cudaMemcpyDeviceToHost);
    cudaMemcpy(fft2, d_s2, 8 * sizeof(cufftComplex), cudaMemcpyDeviceToHost);
    cudaMemcpy(fft3, d_s3, 8 * sizeof(cufftComplex), cudaMemcpyDeviceToHost);

    cout << "Signal 1: " << endl;
    for (int ii = 0; ii < 8; ii++) {
        cout << sig1[ii].x << " + i*" << sig1[ii].y << endl;
    }

    cout << "Signal 1 FFT: " << endl;
    for (int ii = 0; ii < 8; ii++) {
        cout << fft1[ii].x << " + i*" << fft1[ii].y << endl;
    }

    cout << "Signal 2: " << endl;
    for (int ii = 0; ii < 8; ii++) {
        cout << sig2[ii].x << " + i*" << sig2[ii].y << endl;
    }

    cout << "Signal 2 FFT: " << endl;
    for (int ii = 0; ii < 8; ii++) {
        cout << fft2[ii].x << " + i*" << fft2[ii].y << endl;
    }

    cout << "Signal 3: " << endl;
    for (int ii = 0; ii < 8; ii++) {
        cout << sig3[ii].x << " + i*" << sig3[ii].y << endl;
    }

    cout << "Signal 3 FFT: " << endl;
    for (int ii = 0; ii < 8; ii++) {
        cout << fft3[ii].x << " + i*" << fft3[ii].y << endl;
    }

    cudaFree(d_s1);
    cudaFree(d_s2);
    cudaFree(d_s3);

    delete[] sig1;
    delete[] sig2;
    delete[] sig3;
    delete[] fft1;
    delete[] fft2;
    delete[] fft3;

    return 0;
}
