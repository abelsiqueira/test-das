#include <stdio.h>

#define gpuErrchk(ans) { gpuAssert((ans), __FILE__, __LINE__); }

inline void gpuAssert(cudaError_t code, char *file, int line, bool abort=true)
{
   if (code != cudaSuccess)
   {
      fprintf(stderr,"GPUassert: %s %s %d\n", cudaGetErrorString(code), file, line);
      if (abort) exit(code);
   }
}

__global__
void saxpy(int n, float a, float *x, float *y) {
  int i = blockIdx.x * blockDim.x + threadIdx.x;
  printf("%d\n", i);
  if (i < n)
    y[i] = a * x[i] + y[i];
}

int main(void) {
  int N = 1 << 3;
  float *x, *y, *d_x, *d_y;
  cudaError_t err;

  x = (float *) malloc(N * sizeof(float));
  y = (float *) malloc(N * sizeof(float));

  err = cudaMalloc(&d_x, N * sizeof(float));
  gpuErrchk(err);
  err = cudaMalloc(&d_y, N * sizeof(float));
  gpuErrchk(err);

  for (int i = 0; i < N; i++) {
    x[i] = 1.0f;
    y[i] = 2.0f;
  }

  err = cudaMemcpy(d_x, x, N * sizeof(float), cudaMemcpyHostToDevice);
  gpuErrchk(err);
  err = cudaMemcpy(d_y, y, N * sizeof(float), cudaMemcpyHostToDevice);
  gpuErrchk(err);

  saxpy<<<(N + 255) / 256, 256>>>(N, 2.0f, d_x, d_y);
  gpuErrchk( cudaPeekAtLastError() );

  err = cudaMemcpy(y, d_y, N * sizeof(float), cudaMemcpyDeviceToHost);
  gpuErrchk(err);

  float maxError = 0.0f;
  for (int i = 0; i < N; i++)
    maxError = max(maxError, abs(y[i] - 4.0f));
  printf("Max error: %f\n", maxError);

  printf("N = %d\n", N);
  for (int i = 0; i < N; i++)
    printf("y[%d] = %f\n", i, y[i]);

  cudaFree(d_x);
  cudaFree(d_y);
  free(x);
  free(y);
}